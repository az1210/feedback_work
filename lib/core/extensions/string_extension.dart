extension StringExtensions on String {
  String toTitleCase() {
    String cleanedString = replaceAll(RegExp(r'[^a-zA-Z0-9]'), ' ');

    List<String> words = cleanedString.split(' ');

    for (int i = 0; i < words.length; i++) {
      if (words[i].isNotEmpty) {
        words[i] =
            words[i][0].toUpperCase() + words[i].substring(1).toLowerCase();
      }
    }

    return words.join(' ');
  }
}
