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
import 'package:apploop_server/src/builds/app_generator.dart';
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
      if (task != null) {
        await worker.run(task);
        continue;
      }
      final recording = await worker.client.feedbackBuilder.claimRecordingTask(
        token,
      );
      if (recording != null) {
        await worker.processRecording(recording);
        continue;
      }
      await Future.delayed(_pollInterval);
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

  /// Processes one claimed recording: download video, run
  /// `explain.sh debug`, upload screenshots, post transcript + issues.
  /// Never throws: failures complete with a note so manual comments
  /// keep working.
  Future<void> processRecording(RecordingTask task) async {
    final recording = task.recording;
    stdout.writeln('processing recording ${recording.id} ...');
    try {
      if (task.videoUrl.isEmpty) {
        await client.feedbackBuilder.completeRecordingProcessing(
          token,
          recording.id!,
          'Audio-only recording — automatic issue extraction needs video. '
              'Add comments manually.',
          '[]',
          [],
        );
        return;
      }
      final explainSh = env['EXPLAIN_SH'] ?? '${env['HOME']}/bin/explain.sh';
      if (!File(explainSh).existsSync()) {
        stdout.writeln('explain.sh not found at $explainSh — skipping.');
        return;
      }
      final dir = Directory('${workRoot.path}/recording_${recording.id}');
      if (dir.existsSync()) dir.deleteSync(recursive: true);
      await dir.create(recursive: true);
      final video = File('${dir.path}/video.mov');
      await _download(task.videoUrl, video);
      final out = Directory('${dir.path}/out');
      final result = await Process.run(explainSh, [
        'debug',
        video.path,
        '-o',
        out.path,
      ]);
      stdout.write(result.stdout);
      if (result.exitCode != 0) {
        stderr.writeln('explain.sh failed: ${result.stderr}');
      }
      final transcript = await _readText(
        File('${out.path}/transcript.txt'),
      );
      final issues = await _readIssues(out);
      final shots = await _uploadShots(out, recording.id!, issues.length);
      final screenshotByIssue = <String>[];
      for (var i = 0; i < issues.length; i++) {
        screenshotByIssue.add(shots[i] ?? '');
      }
      await client.feedbackBuilder.completeRecordingProcessing(
        token,
        recording.id!,
        transcript,
        jsonEncode(issues),
        screenshotByIssue,
      );
      stdout.writeln(
        'recording ${recording.id} ready (${issues.length} issues).',
      );
    } catch (e) {
      stderr.writeln('processing failed: $e');
      await client.feedbackBuilder.completeRecordingProcessing(
        token,
        recording.id!,
        'Automatic processing failed ($e). Add comments manually.',
        '[]',
        [],
      );
    }
  }

  Future<void> _download(String url, File target) async {
    final request = await HttpClient().getUrl(Uri.parse(url));
    final response = await request.close();
    if (response.statusCode != 200) {
      throw StateError('Download failed (HTTP ${response.statusCode}).');
    }
    await response.pipe(target.openWrite());
  }

  Future<String> _readText(File file) async {
    if (!file.existsSync()) return '';
    return file.readAsString();
  }

  /// Reads `issues.raw.json`, falling back to `issues.tsv` converted to
  /// the same shape, else an empty list.
  Future<List<Map<String, dynamic>>> _readIssues(Directory out) async {
    final raw = File('${out.path}/issues.raw.json');
    if (raw.existsSync()) {
      final decoded = jsonDecode(await raw.readAsString());
      if (decoded is List) {
        return decoded
            .whereType<Map>()
            .map((e) => Map<String, dynamic>.from(e))
            .toList();
      }
    }
    final tsv = File('${out.path}/issues.tsv');
    if (!tsv.existsSync()) return [];
    final issues = <Map<String, dynamic>>[];
    for (final line in await tsv.readAsLines()) {
      if (line.trim().isEmpty) continue;
      final cols = line.split('\t');
      while (cols.length < 6) {
        cols.add('');
      }
      issues.add({
        'title': cols[0],
        'severity': cols[1].isEmpty ? 'medium' : cols[1],
        'timestamps': cols[2].isEmpty ? <String>[] : [cols[2]],
        'quote': cols[3],
        'fix': cols[4],
      });
    }
    return issues;
  }

  /// Uploads unique screenshots and maps issue index → shot file name.
  /// Issue rows are 1-based; candidate frames are cand-NN.jpg.
  Future<Map<int, String>> _uploadShots(
    Directory out,
    int recordingId,
    int issueCount,
  ) async {
    final byIssue = <int, String>{};
    final shotsDir = Directory('${out.path}/shots');
    if (!shotsDir.existsSync()) return byIssue;
    final map = <String, String>{};
    final shotmap = File('${shotsDir.path}/shotmap.tsv');
    if (shotmap.existsSync()) {
      for (final line in await shotmap.readAsLines()) {
        final cols = line.split('\t');
        if (cols.length == 2 && cols[1].isNotEmpty) {
          map[cols[0]] = cols[1];
        }
      }
    }
    final uploaded = <String>{};
    for (var n = 1; n <= issueCount; n++) {
      final cand = 'cand-${n.toString().padLeft(2, '0')}.jpg';
      final shot = map[cand];
      if (shot == null) continue;
      if (!uploaded.contains(shot)) {
        final file = File('${shotsDir.path}/$shot');
        if (!file.existsSync()) continue;
        final description = await client.feedbackBuilder
            .getScreenshotUploadDescription(token, recordingId, shot);
        final ok = await FileUploader(description).upload(
          file.openRead(),
          await file.length(),
        );
        if (!ok) throw StateError('Screenshot upload failed ($shot).');
        uploaded.add(shot);
      }
      byIssue[n - 1] = shot;
    }
    return byIssue;
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
