import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:apploop_flutter/screens/test_session_screen.dart';

import 'fakes/fake_app_loop_api.dart';

Future<void> _pumpSession(
  WidgetTester tester,
  FakeAppLoopApi api, {
  int buildId = 1,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      home: TestSessionScreen(api: api, buildId: buildId),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('shows how-to hint and empty recordings', (tester) async {
    await _pumpSession(tester, FakeAppLoopApi());

    expect(find.textContaining('microphone ON'), findsOneWidget);
    expect(find.text('Pick screen recording'), findsOneWidget);
    expect(find.text('Audio note'), findsOneWidget);
    expect(
      find.text('No recordings yet for this build.'),
      findsOneWidget,
    );
  });

  testWidgets('lists recordings with statuses', (tester) async {
    final api = FakeAppLoopApi();
    // Seed through the fake's own flow, as the app would, before pumping.
    final recording = await api.startRecording(1);
    await api.completeRecording(recording.id!);
    await _pumpSession(tester, api);

    expect(find.text('Recording ${recording.id}'), findsOneWidget);
    expect(find.textContaining('Status: uploaded'), findsOneWidget);
  });
}
