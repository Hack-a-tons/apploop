/// Functional module picked for a generated app, based on wish keywords.
enum WishModule {
  counter,
  notes,
  checklist,
  quiz;

  /// Dart file name of the module screen.
  String get fileName => '${toString().split('.').last}.dart';

  /// Widget class of the module screen.
  String get widgetName {
    final name = toString().split('.').last;
    return '${name[0].toUpperCase()}${name.substring(1)}Screen';
  }

  /// Extra pub dependency the module needs, if any.
  String? get pubDependency => switch (this) {
    WishModule.notes => 'shared_preferences',
    _ => null,
  };
}

/// Picks a module from wish keywords. Deterministic: first match in
/// priority order wins; [WishModule.counter] is the default.
WishModule pickModule(String title, String description) {
  final text = '$title\n$description'.toLowerCase();
  bool hasAny(List<String> keywords) => keywords.any(text.contains);
  if (hasAny(['quiz', 'learn', 'study', 'flash', 'exam', 'trivia'])) {
    return WishModule.quiz;
  }
  if (hasAny(['note', 'journal', 'memo', 'idea', 'diary'])) {
    return WishModule.notes;
  }
  if (hasAny(['todo', 'to-do', 'task', 'remind', 'grocery', 'shopping'])) {
    return WishModule.checklist;
  }
  if (hasAny([
    'list',
    'check',
    'habit',
    'routine',
    'packing',
    'bucket',
  ])) {
    return WishModule.checklist;
  }
  return WishModule.counter;
}

/// Derives a stable Material seed color (ARGB hex) from a slug by hashing
/// it into a fixed palette. Same slug always yields the same color.
String seedColorForSlug(String slug) {
  const palette = [
    '0xFF4AC981', // AppLoop green
    '0xFF2D9CDB', // blue
    '0xFF9B51E0', // purple
    '0xFFF2994A', // orange
    '0xFFEB5757', // red
    '0xFF219653', // dark green
  ];
  var hash = 0;
  for (final unit in slug.codeUnits) {
    hash = (hash * 31 + unit) & 0x7fffffff;
  }
  return palette[hash % palette.length];
}

/// Title-cases a slug for display: `plant_identifier` → `Plant Identifier`.
String displayNameForSlug(String slug) {
  final words = slug.split('_').where((w) => w.isNotEmpty).map((w) {
    return '${w[0].toUpperCase()}${w.substring(1)}';
  });
  final name = words.join(' ');
  return name.isEmpty ? 'App' : name;
}
