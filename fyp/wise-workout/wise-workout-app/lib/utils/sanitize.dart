class Sanitize {
  String clean(String? input) {
    return input?.trim().replaceAll(RegExp(r'<[^>]*>'), '') ?? '';
  }

  bool isValidEmail(String? email) {
    final cleaned = clean(email);
    final regex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    return regex.hasMatch(cleaned);
  }

  bool isValidPassword(String? password) {
    final cleaned = clean(password);
    return cleaned.length >= 6;
  }
}
