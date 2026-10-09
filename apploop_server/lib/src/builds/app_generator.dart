import 'dart:convert';
import 'dart:io';

import 'app_template.dart';
import 'wish_module.dart';

/// Generates a buildable Flutter app from a wish.
///
/// Runs `flutter create` for the native shells, then overlays the
/// AppLoop `lib/` files rendered from templates. Deterministic: the same
/// inputs always produce byte-identical `lib/` files.
class AppGenerator {
  final String flutterBin;

  AppGenerator({String? flutterBin}) : flutterBin = flutterBin ?? 'flutter';

  /// Generates into [targetDir] (created if needed) and returns the
  /// summary. Throws [StateError] with the tool output on failure.
  Future<GeneratedApp> generate({
    required Directory targetDir,
    required String slug,
    required String organization,
    required String title,
    required String description,
  }) async {
    if (!RegExp(r'^[a-z][a-z0-9_]*$').hasMatch(slug)) {
      throw ArgumentError.value(
        slug,
        'slug',
        'Must be a valid Dart package name.',
      );
    }
    final module = pickModule(title, description);
    final seedColor = seedColorForSlug(slug);

    await targetDir.create(recursive: true);
    await _run(flutterBin, [
      'create',
      '--org',
      organization,
      '--project-name',
      slug,
      '--platforms',
      'ios,android',
      '.',
    ], targetDir);

    final files = AppTemplate.renderAppFiles(
      module: module,
      wishTitle: AppTemplate.escapeDartString(title.trim()),
      wishDescription: AppTemplate.escapeDartString(description.trim()),
      seedColor: seedColor,
    );
    files['test/widget_test.dart'] = AppTemplate.renderWidgetTest(slug);
    for (final entry in files.entries) {
      final file = File('${targetDir.path}/${entry.key}');
      await file.parent.create(recursive: true);
      await file.writeAsString(entry.value);
    }

    final dependency = module.pubDependency;
    if (dependency != null) {
      await _run(flutterBin, ['pub', 'add', dependency], targetDir);
    }

    // `flutter create` camelCases the iOS bundle id suffix (tapCounter);
    // force the exact id so it matches the App Store Connect record.
    final bundleId = '$organization.$slug';
    final pbxproj = File(
      '${targetDir.path}/ios/Runner.xcodeproj/project.pbxproj',
    );
    if (await pbxproj.exists()) {
      final patched = (await pbxproj.readAsString()).replaceAllMapped(
        RegExp(r'PRODUCT_BUNDLE_IDENTIFIER = ([A-Za-z0-9.-]+);'),
        (match) {
          final current = match.group(1)!;
          final value = current.endsWith('.RunnerTests')
              ? '$bundleId.RunnerTests'
              : bundleId;
          return 'PRODUCT_BUNDLE_IDENTIFIER = $value;';
        },
      );
      await pbxproj.writeAsString(patched);
    }

    final manifest = {
      'tool': 'apploop',
      'slug': slug,
      'organization': organization,
      'bundleId': bundleId,
      'title': title,
      'description': description,
      'module': module.name,
      'seedColor': seedColor,
    };
    await File(
      '${targetDir.path}/apploop.json',
    ).writeAsString('${jsonEncode(manifest)}\n');

    return GeneratedApp(
      directory: targetDir,
      module: module,
      bundleId: bundleId,
      files: files.keys.toList(),
    );
  }

  Future<void> _run(
    String executable,
    List<String> args,
    Directory workingDirectory,
  ) async {
    final result = await Process.run(
      executable,
      args,
      workingDirectory: workingDirectory.path,
    );
    if (result.exitCode != 0) {
      throw StateError(
        '$executable ${args.join(' ')} failed '
        '(exit ${result.exitCode}):\n${result.stdout}\n${result.stderr}',
      );
    }
  }
}

class GeneratedApp {
  final Directory directory;
  final WishModule module;
  final String bundleId;
  final List<String> files;

  const GeneratedApp({
    required this.directory,
    required this.module,
    required this.bundleId,
    required this.files,
  });
}
