import 'dart:io';

import 'package:test/test.dart';

import 'package:apploop_server/src/build/app_generator.dart';
import 'package:apploop_server/src/build/wish_module.dart';

/// End-to-end generation with the real Flutter SDK. Uses the counter
/// module so no extra `pub get` (network) is needed.
void main() {
  group('AppGenerator', () {
    test(
      'generates a complete project with rendered lib files',
      () async {
        final dir = await Directory.systemTemp.createTemp('apploop-gen-');
        try {
          final app = await AppGenerator().generate(
            targetDir: Directory('${dir.path}/tap_counter'),
            slug: 'tap_counter',
            organization: 'com.hurated.apploop',
            title: 'Tap Counter',
            description: 'Tap fast and count',
          );

          expect(app.module, WishModule.counter);
          expect(app.bundleId, 'com.hurated.apploop.tap_counter');
          for (final file in app.files) {
            expect(
              File('${app.directory.path}/$file').existsSync(),
              isTrue,
              reason: '$file missing',
            );
          }
          expect(
            File(
              '${app.directory.path}/ios/Runner.xcodeproj/project.pbxproj',
            ).existsSync(),
            isTrue,
            reason: 'iOS shell missing',
          );
          final main = await File(
            '${app.directory.path}/lib/main.dart',
          ).readAsString();
          expect(main, isNot(contains('__')));
          final manifest = await File(
            '${app.directory.path}/apploop.json',
          ).readAsString();
          expect(manifest, contains('tap_counter'));
          final pbxproj = await File(
            '${app.directory.path}/ios/Runner.xcodeproj/project.pbxproj',
          ).readAsString();
          expect(
            pbxproj,
            contains(
              'PRODUCT_BUNDLE_IDENTIFIER = com.hurated.apploop.tap_counter;',
            ),
          );
          expect(pbxproj, isNot(contains('tapCounter')));
        } finally {
          await dir.delete(recursive: true);
        }
      },
      timeout: const Timeout(Duration(minutes: 5)),
    );

    test(
      'is deterministic for the same wish',
      () async {
        final dir = await Directory.systemTemp.createTemp('apploop-det-');
        try {
          Future<Map<String, String>> snapshot(String name) async {
            final app = await AppGenerator().generate(
              targetDir: Directory('${dir.path}/$name'),
              slug: 'my_list',
              organization: 'com.hurated.apploop',
              title: 'My List',
              description: 'A list of things',
            );
            final files = <String, String>{};
            for (final file in app.files) {
              files[file] = await File(
                '${app.directory.path}/$file',
              ).readAsString();
            }
            return files;
          }

          final first = await snapshot('a');
          final second = await snapshot('b');
          expect(second, first);
        } finally {
          await dir.delete(recursive: true);
        }
      },
      timeout: const Timeout(Duration(minutes: 8)),
    );
  });
}
