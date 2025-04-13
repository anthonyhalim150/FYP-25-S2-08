import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import '../utils/sanitize.dart';

class RegisterButton extends StatefulWidget {
  final void Function(String msg) onSuccess;
  final void Function(String msg) onError;

  const RegisterButton({
    super.key,
    required this.onSuccess,
    required this.onError,
  });

  @override
  State<RegisterButton> createState() => _RegisterButtonState();
}

class _RegisterButtonState extends State<RegisterButton> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final secureStorage = FlutterSecureStorage();
  final backendUrl = "http://10.0.2.2:3000";
  final sanitize = Sanitize();

  String? emailError;
  String? passwordError;
  bool isSubmitting = false;
  bool hasTypedEmail = false;
  bool hasTypedPassword = false;

  void validateInputs() {
    final emailResult = sanitize.isValidEmail(emailController.text);
    final passwordResult = sanitize.isValidPassword(passwordController.text);

    setState(() {
      emailError = hasTypedEmail ? (emailResult.valid ? null : emailResult.message) : null;
      passwordError = hasTypedPassword ? (passwordResult.valid ? null : passwordResult.message) : null;
    });
  }

  bool get isFormValid =>
      sanitize.isValidEmail(emailController.text).valid &&
      sanitize.isValidPassword(passwordController.text).valid;

  Future<void> register() async {
    final emailResult = sanitize.isValidEmail(emailController.text);
    final passwordResult = sanitize.isValidPassword(passwordController.text);

    if (!emailResult.valid || !passwordResult.valid) {
      validateInputs();
      widget.onError('Please fix the input errors');
      return;
    }

    setState(() => isSubmitting = true);

    try {
        final response = await http.post(
          Uri.parse('$backendUrl/auth/register'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'email': emailResult.value,
            'password': passwordResult.value,
          }),
        );

      final cookie = response.headers['set-cookie'];
      if (response.statusCode == 201 && cookie != null) {
        final jwt = cookie.split(';').first.split('=').last;
        await secureStorage.write(key: 'jwt_cookie', value: jwt);
        widget.onSuccess('Registration successful');
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        final Map<String, dynamic> errorData = jsonDecode(response.body);
        widget.onError(errorData['message'] ?? 'Registration failed');
      }
      } catch (e) {
        widget.onError('Server error: $e');
      } finally {
        setState(() => isSubmitting = false);
      }
    }


  @override
  void initState() {
    super.initState();
    emailController.addListener(() {
      if (!hasTypedEmail && emailController.text.isNotEmpty) {
        setState(() => hasTypedEmail = true);
      }
      validateInputs();
    });
    passwordController.addListener(() {
      if (!hasTypedPassword && passwordController.text.isNotEmpty) {
        setState(() => hasTypedPassword = true);
      }
      validateInputs();
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: emailController,
          decoration: InputDecoration(
            labelText: 'Email',
            hintText: 'example@email.com',
            errorText: emailError,
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: passwordController,
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'Password',
            hintText: 'Must be at least 6 characters',
            errorText: passwordError,
          ),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: isFormValid && !isSubmitting ? register : null,
          child: isSubmitting
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Register'),
        ),
      ],
    );
  }
}
