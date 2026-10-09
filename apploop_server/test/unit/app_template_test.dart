import 'package:test/test.dart';

import 'package:apploop_server/src/build/app_template.dart';
import 'package:apploop_server/src/build/wish_module.dart';

void main() {
  group('AppTemplate.escapeDartString', () {
    test('escapes quotes, dollars, backslashes and newlines', () {
      expect(
        AppTemplate.escapeDartString("it's \$5 \\ nice\nok"),
        r"it\'s \$5 \\ nice\nok",
      );
    });
  });

  group('AppTemplate.renderAppFiles', () {
    for (final module in WishModule.values) {
      test('renders ${module.name} with no placeholders left', () {
        final files = AppTemplate.renderAppFiles(
          module: module,
          wishTitle: 'Test App',
          wishDescription: 'Does things',
          seedColor: '0xFF4AC981',
        );
        expect(
          files.keys.toSet(),
          {
            'lib/main.dart',
            'lib/wish.dart',
            'lib/modules/${module.fileName}',
          },
        );
        for (final content in files.values) {
          expect(content, isNot(contains('__')));
          expect(content, contains('WishInfo'));
        }
        expect(files['lib/main.dart'], contains(module.widgetName));
      });
    }

    test('wish file carries title, description and color', () {
      final files = AppTemplate.renderAppFiles(
        module: WishModule.counter,
        wishTitle: 'Plant Identifier',
        wishDescription: 'Point and learn',
        seedColor: '0xFF2D9CDB',
      );
      final wish = files['lib/wish.dart']!;
      expect(wish, contains("title = 'Plant Identifier'"));
      expect(wish, contains("description = 'Point and learn'"));
      expect(wish, contains('Color(0xFF2D9CDB)'));
    });

    test('widget test references the package and wish title', () {
      final test = AppTemplate.renderWidgetTest('tap_counter');
      expect(test, contains('package:tap_counter/main.dart'));
      expect(test, contains('WishInfo.title'));
      expect(test, isNot(contains('__')));
    });
  });
}
