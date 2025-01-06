extension StringExtensions on String {
  String toTitleCase() {
    return replaceAllMapped(RegExp(r'([a-z])([A-Z])'), (match) {
      return '${match.group(1)} ${match.group(2)}';
    }).replaceFirstMapped(RegExp(r'^[a-z]'), (match) {
      return match.group(0)!.toUpperCase();
    });
  }
}
