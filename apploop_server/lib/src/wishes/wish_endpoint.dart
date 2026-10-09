import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';

import '../generated/protocol.dart';

/// Wishes: what the user told the phone they want built.
///
/// Every method requires a signed-in user and only ever touches rows
/// owned by that user (matched via the auth user id).
class WishEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// Creates a wish from a spoken or typed title and description.
  Future<AppWish> createWish(
    Session session,
    String title,
    String description,
  ) async {
    final owner = session.authenticated!.authUserId;
    final cleanTitle = title.trim();
    if (cleanTitle.isEmpty) {
      throw ArgumentError('Wish title must not be empty.');
    }
    return AppWish.db.insertRow(
      session,
      AppWish(
        authUserId: owner,
        title: cleanTitle,
        descriptionText: description.trim(),
      ),
    );
  }

  /// Lists the signed-in user's wishes, newest first.
  Future<List<AppWish>> listMyWishes(Session session) async {
    final owner = session.authenticated!.authUserId;
    return AppWish.db.find(
      session,
      where: (t) => t.authUserId.equals(owner),
      orderBy: (t) => t.id.desc(),
    );
  }

  /// Replaces title and description of a wish owned by the caller.
  Future<AppWish> updateWish(
    Session session,
    int id,
    String title,
    String description,
  ) async {
    final wish = await _ownedWish(session, id);
    final cleanTitle = title.trim();
    if (cleanTitle.isEmpty) {
      throw ArgumentError('Wish title must not be empty.');
    }
    return AppWish.db.updateRow(
      session,
      wish.copyWith(
        title: cleanTitle,
        descriptionText: description.trim(),
      ),
    );
  }

  /// Deletes a wish owned by the caller (builds and feedback cascade).
  Future<void> deleteWish(Session session, int id) async {
    final wish = await _ownedWish(session, id);
    await AppWish.db.deleteRow(session, wish);
  }

  /// Freezes the loop: the wish is done, ready for export.
  Future<AppWish> markSatisfied(Session session, int id) async {
    final wish = await _ownedWish(session, id);
    return AppWish.db.updateRow(session, wish.copyWith(status: 'satisfied'));
  }

  /// Reopens the loop after it was marked satisfied.
  Future<AppWish> reopenWish(Session session, int id) async {
    final wish = await _ownedWish(session, id);
    return AppWish.db.updateRow(session, wish.copyWith(status: 'testing'));
  }

  /// Loads a wish by id, or throws when it does not exist or belongs to
  /// someone else (deliberately indistinguishable to avoid leaking rows).
  Future<AppWish> _ownedWish(Session session, int id) async {
    final owner = session.authenticated!.authUserId;
    final wish = await AppWish.db.findById(session, id);
    if (wish == null || wish.authUserId != owner) {
      throw StateError('Wish not found.');
    }
    return wish;
  }
}
