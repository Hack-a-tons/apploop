import 'package:test/test.dart';

import 'package:apploop_server/src/store/slugify.dart';

void main() {
  group('slugifyWishTitle', () {
    test('lowercases and joins with underscores', () {
      expect(slugifyWishTitle('Plant Identifier!'), 'plant_identifier');
    });

    test('collapses runs of separators and trims them', () {
      expect(slugifyWishTitle('  --My  ___App--  '), 'my_app');
    });

    test('falls back to app for empty input', () {
      expect(slugifyWishTitle('!!!'), 'app');
      expect(slugifyWishTitle(''), 'app');
    });

    test('prefixes digit-led slugs so packages stay valid', () {
      expect(slugifyWishTitle('2 Fast'), 'app_2_fast');
    });

    test('caps length without leaving a trailing underscore', () {
      final slug = slugifyWishTitle(
        'a very long app title that surely exceeds thirty characters',
        maxLength: 30,
      );
      expect(slug.length, lessThanOrEqualTo(30));
      expect(slug.endsWith('_'), isFalse);
      expect(slug, matches(RegExp(r'^[a-z][a-z0-9_]*$')));
    });
  });
}
