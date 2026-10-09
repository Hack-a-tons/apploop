import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

// Import the generated test helper file, it contains everything you need.
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';

import 'test_tools/serverpod_test_tools.dart';

/// Two fixed auth user ids used to simulate two different signed-in users.
/// They only need to be valid UUID strings: the endpoint parses the
/// session's user identifier into a UUID.
const _userA = '00000000-0000-4000-8000-000000000001';
const _userB = '00000000-0000-4000-8000-000000000002';

TestSessionBuilder _asUser(TestSessionBuilder builder, String userId) {
  return builder.copyWith(
    authentication: AuthenticationOverride.authenticationInfo(
      userId,
      const <Scope>{},
    ),
  );
}

/// Inserts the auth user row the foreign key on wishes requires.
/// (The auth override alone does not create the row.)
Future<void> _seedUser(TestSessionBuilder builder, String userId) async {
  await AuthUser.db.insertRow(
    builder.build(),
    AuthUser(id: UuidValue.fromString(userId), scopeNames: const {}),
  );
}

void main() {
  withServerpod('Given Wish endpoint', (sessionBuilder, endpoints) {
    test(
      'when creating a wish with a title then it is stored for that user',
      () async {
        await _seedUser(sessionBuilder, _userA);
        final wish = await endpoints.wish.createWish(
          _asUser(sessionBuilder, _userA),
          'Plant identifier',
          'Point the camera at a plant',
        );
        expect(wish.id, isNotNull);
        expect(wish.title, 'Plant identifier');
        expect(wish.status, 'draft');

        final wishes = await endpoints.wish.listMyWishes(
          _asUser(sessionBuilder, _userA),
        );
        expect(wishes.map((w) => w.id), contains(wish.id));
      },
    );

    test(
      'when creating a wish with an empty title then it throws',
      () async {
        await _seedUser(sessionBuilder, _userA);
        expect(
          () => endpoints.wish.createWish(
            _asUser(sessionBuilder, _userA),
            '   ',
            'no title',
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      'when listing wishes then other users wishes are not included',
      () async {
        await _seedUser(sessionBuilder, _userA);
        await _seedUser(sessionBuilder, _userB);
        await endpoints.wish.createWish(
          _asUser(sessionBuilder, _userA),
          'User A wish',
          '',
        );
        final wishesB = await endpoints.wish.listMyWishes(
          _asUser(sessionBuilder, _userB),
        );
        expect(wishesB, isEmpty);
      },
    );

    test(
      'when updating another users wish then it throws',
      () async {
        await _seedUser(sessionBuilder, _userA);
        final wish = await endpoints.wish.createWish(
          _asUser(sessionBuilder, _userA),
          'User A wish',
          '',
        );
        expect(
          () => endpoints.wish.updateWish(
            _asUser(sessionBuilder, _userB),
            wish.id!,
            'Hacked',
            '',
          ),
          throwsStateError,
        );
      },
    );

    test(
      'when marking satisfied and reopening then status changes accordingly',
      () async {
        await _seedUser(sessionBuilder, _userA);
        final builderA = _asUser(sessionBuilder, _userA);
        final wish = await endpoints.wish.createWish(builderA, 'Loop wish', '');
        final satisfied = await endpoints.wish.markSatisfied(
          builderA,
          wish.id!,
        );
        expect(satisfied.status, 'satisfied');
        final reopened = await endpoints.wish.reopenWish(builderA, wish.id!);
        expect(reopened.status, 'testing');
      },
    );

    test(
      'when deleting a wish then it disappears from the list',
      () async {
        await _seedUser(sessionBuilder, _userA);
        final builderA = _asUser(sessionBuilder, _userA);
        final wish = await endpoints.wish.createWish(builderA, 'Gone soon', '');
        await endpoints.wish.deleteWish(builderA, wish.id!);
        final wishes = await endpoints.wish.listMyWishes(builderA);
        expect(wishes.map((w) => w.id), isNot(contains(wish.id)));
      },
    );
  });
}
