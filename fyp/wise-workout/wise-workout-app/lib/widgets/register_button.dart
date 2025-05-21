import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils/sanitize.dart';
import '../screens/otp_screen.dart';
import 'package:flutter/material.dart';

final _backendUrl = 'http://10.0.2.2:3000';

Future<String?> registerUser(BuildContext context, String email, String password) async {
  final sanitize = Sanitize();
  final emailResult = sanitize.isValidEmail(email);
  final passwordResult = sanitize.isValidPassword(password);

  if (!emailResult.valid || !passwordResult.valid) {
    return 'Invalid input: ${emailResult.message ?? ''} ${passwordResult.message ?? ''}';
  }

  try {
    final response = await http.post(
      Uri.parse('$_backendUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': emailResult.value,
        'password': passwordResult.value,
      }),
    );

    if (response.statusCode == 201) {
      // Navigate to OTP screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => OtpScreen(email: emailResult.value),
        ),
      );
      return null; // no error
    } else {
      final Map<String, dynamic> errorData = jsonDecode(response.body);
      return errorData['message'] ?? 'Registration failed';
    }
  } catch (e) {
    return 'Server error: $e';
  }
}
