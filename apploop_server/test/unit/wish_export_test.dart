import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

import 'package:apploop_server/src/export/wish_export.dart';
import 'package:apploop_server/src/generated/protocol.dart';

AppWish _wish() => AppWish(
  id: 1,
  authUserId: _user,
  title: 'Plant Identifier',
  descriptionText: 'Point and learn',
  status: 'satisfied',
  currentIteration: 2,
);

final _user = UuidValue.fromString(
  '00000000-0000-4000-8000-000000000001',
);

void main() {
  group('buildWishExport', () {
    test('renders the whole loop story', () {
      final markdown = buildWishExport(
        wish: _wish(),
        storeApp: StoreApp(
          id: 1,
          wishId: 1,
          bundleId: 'com.hurated.loop.plant',
          sku: 'com.hurated.loop.plant',
          appName: 'Plant Identifier',
          status: 'ready',
          ascAppId: '123',
          testflightLink: 'https://testflight.apple.com/join/AbC',
        ),
        builds: [
          AppBuild(
            id: 10,
            wishId: 1,
            storeAppId: 1,
            iteration: 1,
            buildNumber: 3,
            status: 'ready',
            testflightState: 'READY',
          ),
        ],
        recordingsByBuild: {
          10: [
            FeedbackRecording(
              id: 100,
              buildId: 10,
              authUserId: _user,
              transcript: 'it crashed on save',
              status: 'ready',
            ),
          ],
        },
        commentsByRecording: {
          100: [
            FeedbackComment(
              id: 1000,
              recordingId: 100,
              authUserId: _user,
              title: 'Crash on save',
              text: 'it crashed\nSuggested fix: guard null',
              severity: 'high',
              timestamps: '[00:12]',
              resolved: true,
            ),
            FeedbackComment(
              id: 1001,
              recordingId: 100,
              authUserId: _user,
              title: 'Typo',
              severity: 'low',
              resolved: false,
            ),
          ],
        },
        exportedAt: DateTime.utc(2026, 10, 9),
      );

      expect(markdown, contains('# Plant Identifier'));
      expect(markdown, contains('Point and learn'));
      expect(markdown, contains('com.hurated.loop.plant'));
      expect(markdown, contains('https://testflight.apple.com/join/AbC'));
      expect(markdown, contains('Iteration 1 — build 3'));
      expect(markdown, contains('it crashed on save'));
      expect(markdown, contains('[x] **high** Crash on save ([00:12])'));
      expect(markdown, contains('Suggested fix: guard null'));
      expect(markdown, contains('[ ] **low** Typo'));
      expect(markdown, contains('Exported from AppLoop.'));
    });

    test('works without store app, builds or comments', () {
      final markdown = buildWishExport(
        wish: _wish(),
        storeApp: null,
        builds: const [],
        recordingsByBuild: const {},
        commentsByRecording: const {},
        exportedAt: DateTime.utc(2026, 10, 9),
      );

      expect(markdown, contains('# Plant Identifier'));
      expect(markdown, isNot(contains('TestFlight app')));
      expect(markdown, isNot(contains('## Iteration')));
    });
  });
}
