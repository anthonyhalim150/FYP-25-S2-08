import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final emailController = TextEditingController();
  final backendUrl = "http://10.0.2.2:3000";
  bool isSubmitting = false;
  String? message;

  Future<void> sendResetOtp() async {
    setState(() {
      isSubmitting = true;
      message = null;
    });

    try {
      final response = await http.post(
        Uri.parse('$backendUrl/auth/forgot-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': emailController.text.trim()}),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        Navigator.pushNamed(context, '/verify-reset', arguments: emailController.text.trim());
      } else {
        setState(() => message = data['message'] ?? 'Error sending OTP');
      }
    } catch (e) {
      setState(() => message = 'Server error: $e');
    } finally {
      setState(() => isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Forgot Password")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 16),
            if (message != null)
              Text(message!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: isSubmitting ? null : sendResetOtp,
              child: isSubmitting
                  ? const CircularProgressIndicator()
                  : const Text("Send OTP"),
            ),
          ],
        ),
      ),
    );
  }
}
