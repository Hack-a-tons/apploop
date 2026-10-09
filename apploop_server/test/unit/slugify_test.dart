import 'package:test/test.dart';

import 'package:apploop_server/src/store/slugify.dart';

void main() {
  group('slugifyWishTitle', () {
    test('lowercases and dasherizes', () {
      expect(slugifyWishTitle('Plant Identifier!'), 'plant-identifier');
    });

    test('collapses runs of separators and trims dashes', () {
      expect(slugifyWishTitle('  --My  ___App--  '), 'my-app');
    });

    test('falls back to app for empty input', () {
      expect(slugifyWishTitle('!!!'), 'app');
      expect(slugifyWishTitle(''), 'app');
    });

    test('caps length without leaving a trailing dash', () {
      final slug = slugifyWishTitle(
        'a very long app title that surely exceeds thirty characters',
        maxLength: 30,
      );
      expect(slug.length, lessThanOrEqualTo(30));
      expect(slug.endsWith('-'), isFalse);
    });
  });
}
