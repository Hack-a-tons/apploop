import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:apploop_flutter/screens/recording_detail_screen.dart';

import 'fakes/fake_app_loop_api.dart';

Future<void> _pumpDetail(
  WidgetTester tester,
  FakeAppLoopApi api, {
  int recordingId = 1,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      home: RecordingDetailScreen(api: api, recordingId: recordingId),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('shows empty state and progress with no comments', (
    tester,
  ) async {
    await _pumpDetail(tester, FakeAppLoopApi());

    expect(find.text('0 of 0 resolved'), findsOneWidget);
    expect(find.textContaining('No issues yet'), findsOneWidget);
    expect(find.byIcon(Icons.add_comment), findsOneWidget);
  });

  testWidgets('lists comments with severity, quote and progress', (
    tester,
  ) async {
    final api = FakeAppLoopApi();
    api.comments = [api.testComment(resolved: true)];
    await _pumpDetail(tester, api);

    expect(find.text('1 of 1 resolved'), findsOneWidget);
    expect(find.text('Test issue'), findsOneWidget);
    expect(find.text('high'), findsOneWidget);
    expect(find.text('It broke here'), findsOneWidget);
  });

  testWidgets('resolve toggle calls the api', (tester) async {
    final api = FakeAppLoopApi();
    api.comments = [api.testComment(resolved: false)];
    await _pumpDetail(tester, api);

    expect(find.text('0 of 1 resolved'), findsOneWidget);
    await tester.tap(find.text('Resolve'));
    await tester.pumpAndSettle();

    expect(api.calls, contains('setResolved'));
    expect(find.text('1 of 1 resolved'), findsOneWidget);
  });

  testWidgets('add button opens the edit sheet', (tester) async {
    await _pumpDetail(tester, FakeAppLoopApi());

    await tester.tap(find.byIcon(Icons.add_comment));
    await tester.pumpAndSettle();

    expect(find.text('Add comment'), findsOneWidget);
  });
}
