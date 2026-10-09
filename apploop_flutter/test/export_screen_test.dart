import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:apploop_flutter/screens/export_screen.dart';

import 'fakes/fake_app_loop_api.dart';

Future<void> _pumpExport(WidgetTester tester, FakeAppLoopApi api) async {
  await tester.pumpWidget(MaterialApp(home: ExportScreen(api: api)));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('without wishes there is nothing to export', (tester) async {
    await _pumpExport(tester, FakeAppLoopApi());

    expect(find.text('Wish to export'), findsOneWidget);
    expect(find.text('Copy'), findsNothing);
    expect(find.text('Share'), findsNothing);
  });

  testWidgets('selecting a wish renders the export preview', (tester) async {
    final api = FakeAppLoopApi()..wishes = [testWish(title: 'Export me')];
    await _pumpExport(tester, api);

    await tester.tap(find.text('Wish to export'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Export me').last);
    await tester.pumpAndSettle();

    expect(api.calls, contains('exportWish'));
    expect(find.textContaining('# Export of wish'), findsOneWidget);
    expect(find.text('Copy'), findsOneWidget);
    expect(find.text('Share'), findsOneWidget);
  });
}
