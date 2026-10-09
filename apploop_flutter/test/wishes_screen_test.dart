import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:apploop_flutter/screens/wishes_screen.dart';

import 'fakes/fake_app_loop_api.dart';

Future<void> _pumpWishes(WidgetTester tester, FakeAppLoopApi api) async {
  await tester.pumpWidget(MaterialApp(home: WishesScreen(api: api)));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('shows empty state when there are no wishes', (tester) async {
    await _pumpWishes(tester, FakeAppLoopApi());

    expect(find.textContaining('No wishes yet'), findsOneWidget);
    expect(find.byIcon(Icons.mic), findsOneWidget);
  });

  testWidgets('lists wishes from the api', (tester) async {
    final api = FakeAppLoopApi()
      ..wishes = [testWish(title: 'Plant app'), testWish(id: 2, title: 'Quiz')];
    await _pumpWishes(tester, api);

    expect(find.text('Plant app'), findsOneWidget);
    expect(find.text('Quiz'), findsOneWidget);
  });

  testWidgets('shows error with retry when loading fails', (tester) async {
    final api = FakeAppLoopApi()..error = Exception('offline');
    await _pumpWishes(tester, api);

    expect(find.textContaining('Could not load wishes'), findsOneWidget);

    api.error = null;
    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();

    expect(find.textContaining('No wishes yet'), findsOneWidget);
  });
}
