import 'package:test/test.dart';

import 'package:apploop_server/src/builds/wish_module.dart';

void main() {
  group('pickModule', () {
    test('picks quiz for learning wishes', () {
      expect(pickModule('Spanish Quiz', 'learn words'), WishModule.quiz);
    });

    test('picks notes for journal wishes', () {
      expect(pickModule('My Journal', 'daily notes'), WishModule.notes);
    });

    test('picks checklist for todo wishes', () {
      expect(pickModule('Groceries', 'shopping list'), WishModule.checklist);
    });

    test('quiz wins over notes on ties (priority order)', () {
      expect(
        pickModule('Study notes', 'learn with notes'),
        WishModule.quiz,
      );
    });

    test('defaults to counter', () {
      expect(pickModule('Tapper', 'tap fast'), WishModule.counter);
      expect(pickModule('', ''), WishModule.counter);
    });
  });

  group('seedColorForSlug', () {
    test('is stable and a valid color literal', () {
      final first = seedColorForSlug('plant_identifier');
      expect(seedColorForSlug('plant_identifier'), first);
      expect(first, matches(RegExp(r'^0xFF[0-9A-F]{6}$')));
      expect(seedColorForSlug('other_slug'), isNot(first));
    });
  });

  group('displayNameForSlug', () {
    test('title-cases slugs', () {
      expect(displayNameForSlug('plant_identifier'), 'Plant Identifier');
      expect(displayNameForSlug('app'), 'App');
    });
  });
}
