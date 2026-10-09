// AppLoop Mac builder worker.
//
// Long-polls the server for queued builds and runs the whole pipeline on
// this Mac: generate the Flutter app from the wish, build it with
// fastlane, upload to TestFlight, and report back. No Apple credentials
// live in the repo — everything comes from the environment:
//
//   BUILDER_TOKEN      shared token (matches server `builderToken`)
//   APPLOOP_SERVER_URL server URL (default http://localhost:8080/)
//   APPLOOP_WORK_DIR   build checkouts (default ~/.apploop/builds)
//   FLUTTER_BIN        flutter executable (default `flutter`)
//   FASTLANE_BIN       fastlane executable (default `fastlane`)
//   ASC_KEY_ID / ASC_ISSUER_ID / ASC_PRIVATE_KEY  App Store Connect API
//   APPLE_TEAM_ID      Apple Developer team id for signing
//
// Usage: dart run tool/mac_builder.dart
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:apploop_client/apploop_client.dart';
import 'package:apploop_server/src/build/app_generator.dart';
import 'package:apploop_server/src/store/asc_api.dart';

const _pollInterval = Duration(seconds: 10);
const _logFlushInterval = Duration(seconds: 10);

Future<void> main() async {
  final env = Platform.environment;
  final token = env['BUILDER_TOKEN'] ?? '';
  if (token.isEmpty) {
    stderr.writeln(
      'BUILDER_TOKEN is not set. Generate one and put the same value in '
      'the server `builderToken` password.',
    );
    exit(2);
  }
  final serverUrl = env['APPLOOP_SERVER_URL'] ?? 'http://localhost:8080/';
  final workRoot = Directory(
    env['APPLOOP_WORK_DIR'] ?? '${env['HOME']}/.apploop/builds',
  );
  await workRoot.create(recursive: true);

  final worker = _Builder(
    client: Client(serverUrl),
    token: token,
    workRoot: workRoot,
    env: env,
  );
  stdout.writeln('mac_builder polling $serverUrl ...');
  while (true) {
    try {
      final task = await worker.client.builder.claimBuildTask(token);
      if (task == null) {
        await Future.delayed(_pollInterval);
        continue;
      }
      await worker.run(task);
    } catch (e) {
      stderr.writeln('worker error: $e');
      await Future.delayed(_pollInterval);
    }
  }
}

class _Builder {
  final Client client;
  final String token;
  final Directory workRoot;
  final Map<String, String> env;

  _Builder({
    required this.client,
    required this.token,
    required this.workRoot,
    required this.env,
  });

  Future<void> run(BuildTask task) async {
    final build = task.build;
    final log = _Log(client: client, token: token, buildId: build.id!);
    try {
      await log.say('claimed', 'Worker started build #${build.buildNumber}.');

      final dir = Directory('${workRoot.path}/build_${build.id}');
      if (dir.existsSync()) dir.deleteSync(recursive: true);
      await log.say('generating', 'Generating app from wish.');
      final slug = task.bundleId.split('.').last;
      await AppGenerator(
        flutterBin: env['FLUTTER_BIN'],
      ).generate(
        targetDir: dir,
        slug: slug,
        organization: task.organization,
        title: task.wishTitle,
        description: task.wishDescription,
      );
      await _writeFastlane(dir, task);
      await log.say('generating', 'Generated ${task.bundleId}.');

      await log.say('building', 'Running fastlane beta.');
      await _fastlane(dir, task, log, build.buildNumber);

      await log.say('uploading', 'Waiting for the build on TestFlight.');
      final state = await _waitForBuild(task, log);
      await client.builder.completeBuild(
        token,
        build.id!,
        true,
        state,
        log.drain(),
      );
      stdout.writeln('build ${build.id} ready ($state).');
    } catch (e) {
      await client.builder.completeBuild(
        token,
        build.id!,
        false,
        '',
        '${log.drain()}Failed: $e\n',
      );
      stderr.writeln('build ${build.id} failed: $e');
    }
  }

  Future<void> _writeFastlane(Directory dir, BuildTask task) async {
    final scriptDir = Platform.script.toFilePath();
    final templates = Directory(
      '${File(scriptDir).parent.path}/mac_builder/fastlane',
    );
    final target = Directory('${dir.path}/ios/fastlane');
    await target.create(recursive: true);
    for (final name in ['Fastfile', 'Appfile']) {
      await File('${templates.path}/$name').copy('${target.path}/$name');
    }
    await File('${target.path}/changelog.txt').writeAsString(
      '${task.wishTitle} (build ${task.build.buildNumber})\n'
      '${task.wishDescription}\n',
    );
  }

  Future<void> _fastlane(
    Directory dir,
    BuildTask task,
    _Log log,
    int buildNumber,
  ) async {
    final iosDir = Directory('${dir.path}/ios');
    final laneEnv = <String, String>{
      'BUILD_NUMBER': '$buildNumber',
      'APP_IDENTIFIER': task.bundleId,
      if (env['ASC_KEY_ID'] != null) 'ASC_KEY_ID': env['ASC_KEY_ID']!,
      if (env['ASC_ISSUER_ID'] != null) 'ASC_ISSUER_ID': env['ASC_ISSUER_ID']!,
      if (env['ASC_PRIVATE_KEY'] != null)
        'ASC_PRIVATE_KEY': env['ASC_PRIVATE_KEY']!,
      if (env['APPLE_TEAM_ID'] != null) 'APPLE_TEAM_ID': env['APPLE_TEAM_ID']!,
      // Non-interactive fastlane.
      'FASTLANE_HIDE_CHANGELOG': '1',
      'FASTLANE_SKIP_UPDATE_CHECK': '1',
    };
    final code = await _streamProcess(
      env['FASTLANE_BIN'] ?? 'fastlane',
      ['beta'],
      iosDir,
      laneEnv,
      log,
      'building',
    );
    if (code != 0) {
      // One retry without rebuilding when an .ipa was produced.
      final ipa = _findIpa(iosDir);
      if (ipa != null) {
        await log.say('uploading', 'Retrying upload of existing .ipa.');
        final retryCode = await _streamProcess(
          env['FASTLANE_BIN'] ?? 'fastlane',
          ['retry_upload'],
          iosDir,
          {...laneEnv, 'IPA_PATH': ipa.path},
          log,
          'uploading',
        );
        if (retryCode == 0) return;
      }
      throw StateError('fastlane beta failed (exit $code).');
    }
  }

  File? _findIpa(Directory iosDir) {
    for (final entity in iosDir.listSync(recursive: true)) {
      if (entity is File && entity.path.endsWith('.ipa')) return entity;
    }
    return null;
  }

  /// Polls App Store Connect until our build number shows up (max 10 min)
  /// and returns its processing state.
  Future<String> _waitForBuild(BuildTask task, _Log log) async {
    final creds = AppleCredentials(
      keyId: env['ASC_KEY_ID'] ?? '',
      issuerId: env['ASC_ISSUER_ID'] ?? '',
      privateKey: env['ASC_PRIVATE_KEY'] ?? '',
    );
    final api = AppStoreConnectApi(creds);
    try {
      final ascAppId = await _ascAppId(task);
      final deadline = DateTime.now().add(const Duration(minutes: 10));
      while (DateTime.now().isBefore(deadline)) {
        final builds = await api.listBuilds(ascAppId);
        for (final build in builds) {
          if (build.buildNumber == task.build.buildNumber) {
            return build.processingState;
          }
        }
        await Future.delayed(const Duration(seconds: 30));
      }
      throw StateError(
        'Build ${task.build.buildNumber} did not appear on App Store '
        'Connect within 10 minutes of upload.',
      );
    } finally {
      api.close();
    }
  }

  /// The ASC app id for this task's bundle id.
  Future<String> _ascAppId(BuildTask task) async {
    // The server already stored it at provisioning time; the worker
    // re-resolves it so a stale server row can never misroute a build.
    final creds = AppleCredentials(
      keyId: env['ASC_KEY_ID'] ?? '',
      issuerId: env['ASC_ISSUER_ID'] ?? '',
      privateKey: env['ASC_PRIVATE_KEY'] ?? '',
    );
    final api = AppStoreConnectApi(creds);
    try {
      final app = await api.findAppByBundleId(task.bundleId);
      if (app == null) {
        throw StateError('No App Store Connect app for ${task.bundleId}.');
      }
      return app['id']!;
    } finally {
      api.close();
    }
  }

  /// Runs a process, streaming output lines into [log].
  Future<int> _streamProcess(
    String executable,
    List<String> args,
    Directory workingDirectory,
    Map<String, String> environment,
    _Log log,
    String status,
  ) async {
    final process = await Process.start(
      executable,
      args,
      workingDirectory: workingDirectory.path,
      environment: environment,
    );
    final flush = Timer.periodic(_logFlushInterval, (_) => log.flush(status));
    const decoder = Utf8Decoder(allowMalformed: true);
    process.stdout.transform(decoder).listen(log.add);
    process.stderr.transform(decoder).listen(log.add);
    final code = await process.exitCode;
    flush.cancel();
    await log.flush(status);
    return code;
  }
}

/// Batches log lines and flushes them to the server periodically.
class _Log {
  final Client client;
  final String token;
  final int buildId;
  final StringBuffer _buffer = StringBuffer();

  _Log({required this.client, required this.token, required this.buildId});

  void add(String line) => _buffer.write(line);

  Future<void> say(String status, String line) async {
    _buffer.writeln(line);
    await flush(status);
  }

  Future<void> flush(String status) async {
    final text = drain();
    if (text.isEmpty) {
      await client.builder.postBuildProgress(
        token,
        buildId,
        status,
        '',
      );
      return;
    }
    await client.builder.postBuildProgress(token, buildId, status, text);
  }

  String drain() {
    final text = _buffer.toString();
    _buffer.clear();
    return text;
  }
}
