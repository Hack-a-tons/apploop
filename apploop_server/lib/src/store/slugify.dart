/// Converts a wish title into a URL-safe slug for bundle ids and SKUs.
/// Lowercase words joined by underscores — valid as a Dart package name,
/// an Apple bundle id suffix, and a URL path segment. Capped at
/// [maxLength] without leaving a trailing underscore. Never empty.
String slugifyWishTitle(String title, {int maxLength = 30}) {
  String trim(String s) => s.replaceAll(RegExp(r'^_+|_+$'), '');

  var slug = trim(title.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '_'));
  if (slug.isEmpty) return 'app';
  if (RegExp(r'^[0-9]').hasMatch(slug)) slug = 'app_$slug';
  if (slug.length > maxLength) slug = trim(slug.substring(0, maxLength));
  return slug.isEmpty ? 'app' : slug;
}
