import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:apploop_flutter/screens/wish_detail_screen.dart';

import 'fakes/fake_app_loop_api.dart';

Future<void> _pumpWish(
  WidgetTester tester,
  FakeAppLoopApi api, {
  int wishId = 1,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      home: WishDetailScreen(
        api: api,
        wish: testWish(id: wishId),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('without a store app it offers provisioning', (tester) async {
    await _pumpWish(tester, FakeAppLoopApi());

    expect(find.text('Provision TestFlight app'), findsOneWidget);
    expect(find.text('Request TestFlight build'), findsNothing);
  });

  testWidgets('provisioning calls the api', (tester) async {
    final api = FakeAppLoopApi();
    await _pumpWish(tester, api);

    await tester.tap(find.text('Provision TestFlight app'));
    await tester.pumpAndSettle();

    expect(api.calls, contains('requestApp'));
  });

  testWidgets('ready store app offers a build and link editing', (
    tester,
  ) async {
    final api = FakeAppLoopApi()
      ..storeApps = {1: testStoreApp(status: 'ready')};
    await _pumpWish(tester, api);

    expect(find.text('Request TestFlight build'), findsOneWidget);
    expect(find.text('Save invite link'), findsOneWidget);
  });

  testWidgets('failed store app offers retry', (tester) async {
    final api = FakeAppLoopApi()
      ..storeApps = {1: testStoreApp(status: 'failed')};
    await _pumpWish(tester, api);

    expect(find.text('Retry provisioning'), findsOneWidget);
  });

  testWidgets('satisfy button calls the api', (tester) async {
    final api = FakeAppLoopApi();
    await _pumpWish(tester, api);

    expect(find.text('Satisfied'), findsOneWidget);
    await tester.tap(find.text('Satisfied'));
    await tester.pumpAndSettle();

    expect(api.calls, contains('markSatisfied'));
  });

  testWidgets('iterations list navigates to build detail', (tester) async {
    final api = FakeAppLoopApi();
    await _pumpWish(tester, api);

    expect(find.text('Iterations (0)'), findsOneWidget);
    expect(find.text('No builds yet for this wish.'), findsOneWidget);
  });
}
