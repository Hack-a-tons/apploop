/// Converts a wish title into a URL-safe slug for bundle ids and SKUs.
/// Lowercase, runs of non-alphanumerics become one dash, capped at
/// [maxLength] without leaving a trailing dash. Never empty.
String slugifyWishTitle(String title, {int maxLength = 30}) {
  var slug = title
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
      .replaceAll(RegExp(r'^-+|-+$'), '');
  if (slug.length > maxLength) {
    slug = slug.substring(0, maxLength).replaceAll(RegExp(r'-+$'), '');
  }
  return slug.isEmpty ? 'app' : slug;
}
