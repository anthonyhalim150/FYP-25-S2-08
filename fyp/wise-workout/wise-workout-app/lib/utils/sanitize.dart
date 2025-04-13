class SanitizeResult {
  final String value;
  final bool valid;
  final String? message;

  SanitizeResult._(this.value, this.valid, [this.message]);

  factory SanitizeResult.valid(String value) =>
      SanitizeResult._(value, true);

  factory SanitizeResult.invalid(String message) =>
      SanitizeResult._('', false, message);
}

class Sanitize {
  String sanitizeInput(String? input) {
    if (input == null) return '';
    return input.trim().replaceAll(RegExp(r'<[^>]*>?'), '');
  }

  SanitizeResult isValidEmail(String? email) {
    final sanitized = sanitizeInput(email);
    final regex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

    if (sanitized.isEmpty) {
      return SanitizeResult.invalid("Email cannot be empty.");
    }

    if (!regex.hasMatch(sanitized)) {
      return SanitizeResult.invalid("Invalid email format.");
    }

    return SanitizeResult.valid(sanitized);
  }

  SanitizeResult isValidPassword(String? password) {
    final sanitized = sanitizeInput(password);

    if (sanitized.isEmpty) {
      return SanitizeResult.invalid("Password cannot be empty.");
    }

    if (sanitized.length < 6) {
      return SanitizeResult.invalid("Password must be at least 6 characters.");
    }

    return SanitizeResult.valid(sanitized);
  }
}
