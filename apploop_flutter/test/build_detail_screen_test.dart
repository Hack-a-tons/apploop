import 'package:apploop_client/apploop_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:apploop_flutter/screens/build_detail_screen.dart';

import 'fakes/fake_app_loop_api.dart';

Future<void> _pumpBuild(
  WidgetTester tester,
  FakeAppLoopApi api, {
  int buildId = 1,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      home: BuildDetailScreen(api: api, buildId: buildId),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('ready build shows TestFlight chip and install button', (
    tester,
  ) async {
    final api = FakeAppLoopApi()
      ..builds = [testBuild(status: 'ready')]
      ..info = TestflightInfo(
        buildNumber: 7,
        version: '1.0',
        status: 'ready',
        testflightState: 'READY',
        installUrl: 'https://testflight.apple.com/join/AbCdEfGh',
      );
    await _pumpBuild(tester, api);

    expect(find.textContaining('TestFlight: READY'), findsOneWidget);
    expect(find.text('Install in TestFlight'), findsOneWidget);
    expect(find.text('Retry build'), findsNothing);
  });

  testWidgets('failed build offers retry and calls the api', (tester) async {
    final api = FakeAppLoopApi()..builds = [testBuild(status: 'failed')];
    await _pumpBuild(tester, api);

    expect(find.text('Retry build'), findsOneWidget);
    await tester.tap(find.text('Retry build'));
    await tester.pumpAndSettle();

    expect(api.calls, contains('retryBuild'));
    expect(find.textContaining('Status: queued'), findsOneWidget);
  });

  testWidgets('ready build without link explains itself', (tester) async {
    final api = FakeAppLoopApi()..builds = [testBuild(status: 'ready')];
    await _pumpBuild(tester, api);

    expect(find.text('Install in TestFlight'), findsNothing);
    expect(
      find.textContaining('No TestFlight invite link yet'),
      findsOneWidget,
    );
  });
}
