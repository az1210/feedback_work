String? validateInput(String? value, {String fieldName = 'Field'}) {
  if (value == null || value.trim().isEmpty) {
    return '$fieldName cannot be empty';
  }
  if (value.length < 3) {
    return '$fieldName must be at least 3 characters long';
  }
  return null;
}

String? validateEmail(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Email cannot be empty';
  }
  final emailRegex =
      RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
  if (!emailRegex.hasMatch(value)) {
    return 'Enter a valid email address';
  }
  return null;
}
