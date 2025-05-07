import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'questionnaires/questionnaire_screen.dart';


class OtpScreen extends StatefulWidget {
  final String email;
  const OtpScreen({super.key, required this.email});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final otpController = TextEditingController();
  final backendUrl = "http://10.0.2.2:3000";

  bool isSubmitting = false;
  String? error;

  Future<void> verifyOtp() async {
    setState(() {
      isSubmitting = true;
      error = null;
    });

    try {
      final response = await http.post(
        Uri.parse('$backendUrl/auth/verify-otp-register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': widget.email,
          'code': otpController.text.trim(),
        }),
      );

      if (response.statusCode == 201) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => QuestionnaireScreen(
              step: 1,
              responses: {},
            ),
          ),
        );
      } else {
        final data = jsonDecode(response.body);
        setState(() => error = data['message'] ?? 'Invalid OTP');
      }
    } catch (e) {
      setState(() => error = 'Server error: $e');
    } finally {
      setState(() => isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enter OTP')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text('A verification code was sent to ${widget.email}'),
            const SizedBox(height: 16),
            TextField(
              controller: otpController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: '6-digit OTP'),
            ),
            const SizedBox(height: 16),
            if (error != null)
              Text(error!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: isSubmitting ? null : verifyOtp,
              child: isSubmitting
                  ? const CircularProgressIndicator()
                  : const Text('Verify'),
            ),
          ],
        ),
      ),
    );
  }
}
