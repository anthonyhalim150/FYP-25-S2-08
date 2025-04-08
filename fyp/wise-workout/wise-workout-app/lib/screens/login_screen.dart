
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final secureStorage = FlutterSecureStorage();
  final authService = AuthService();
  final backendUrl = "http://10.0.2.2:3000";

  Future<void> loginWithEmail() async {
    final response = await http.post(
      Uri.parse('$backendUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': emailController.text.trim(),
        'password': passwordController.text.trim(),
      }),
    );

    final cookie = response.headers['set-cookie'];
    if (response.statusCode == 200 && cookie != null) {
      final jwt = cookie.split(';').first.split('=').last;
      await secureStorage.write(key: 'jwt_cookie', value: jwt);
      showSuccess('Login successful');
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      showError('Invalid email or password');
    }
  }

  Future<void> loginWithGoogle() async {
  try {
    final email = await authService.signInWithGoogle();
    if (email == null) {
      showError('Google sign-in was cancelled or failed');
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('$backendUrl/auth/google'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      try {
        final cookie = response.headers['set-cookie'];
        if (response.statusCode == 200 && cookie != null) {
          try {
            final jwt = cookie.split(';').first.split('=').last;
            await secureStorage.write(key: 'jwt_cookie', value: jwt);
            showSuccess('Google login successful');
            Navigator.pushReplacementNamed(context, '/home');
          } catch (e) {
            showError('Failed to store JWT securely: $e');
          }
        } else {
          showError('Google login failed. Status: ${response.statusCode}');
        }
      } catch (e) {
        showError('Error processing response cookie: $e');
      }
    } catch (e) {
      showError('HTTP request failed: $e');
    }
  } catch (e) {
    showError('Google sign-in error: $e');
  }
}


  void showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.red));
  }

  void showSuccess(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.green));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: loginWithEmail,
              child: const Text('Login'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: loginWithGoogle,
              child: const Text('Continue with Google'),
            ),
          ],
        ),
      ),
    );
  }
}
