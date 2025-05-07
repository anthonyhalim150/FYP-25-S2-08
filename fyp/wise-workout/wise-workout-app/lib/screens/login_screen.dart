import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'dart:io';
import '../services/auth_service.dart';
import '../widgets/google_login_button.dart';
import '../widgets/apple_login_button.dart';
import '../widgets/facebook_login_button.dart';
import '../utils/sanitize.dart';
import 'questionnaires/questionnaire_screen.dart';

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
  final sanitize = Sanitize();
  final backendUrl = "http://10.0.2.2:3000";

  Future<void> loginWithEmail() async {
    final emailResult = sanitize.isValidEmail(emailController.text);
    final passwordResult = sanitize.isValidPassword(passwordController.text);

    if (!emailResult.valid) {
      showError(emailResult.message ?? 'Invalid email');
      return;
    }

    if (!passwordResult.valid) {
      showError(passwordResult.message ?? 'Invalid password');
      return;
    }

    final email = emailResult.value;
    final password = passwordResult.value;


    final response = await http.post(
      Uri.parse('$backendUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    final cookie = response.headers['set-cookie'];
    if (response.statusCode == 200 && cookie != null) {
      final jwt = cookie.split(';').first.split('=').last;
      await secureStorage.write(key: 'jwt_cookie', value: jwt);
      showSuccess('Login successful');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const QuestionnaireScreen(step: 1, responses: {}),
        ),
      );
    } else {
      showError('Invalid email or password');
    }
  }

  Future<void> loginWithGoogle() async {
    final email = await authService.signInWithGoogle();
    if (email == null) {
      showError('Google sign-in was cancelled or failed');
      return;
    }

    final response = await http.post(
      Uri.parse('$backendUrl/auth/google'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );

    final cookie = response.headers['set-cookie'];
    if (response.statusCode == 200 && cookie != null) {
      final jwt = cookie.split(';').first.split('=').last;
      await secureStorage.write(key: 'jwt_cookie', value: jwt);
      showSuccess('Google login successful');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const QuestionnaireScreen(step: 1, responses: {}),
        ),
      );

    } else {
      showError('Google login failed');
    }
  }

  Future<void> loginWithFacebook() async {
    final email = await authService.signInWithFacebook();
    if (email == null) {
      showError('Facebook sign-in was cancelled or failed');
      return;
    }

    final response = await http.post(
      Uri.parse('$backendUrl/auth/facebook'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );

    final cookie = response.headers['set-cookie'];
    if (response.statusCode == 200 && cookie != null) {
      final jwt = cookie.split(';').first.split('=').last;
      await secureStorage.write(key: 'jwt_cookie', value: jwt);
      showSuccess('Facebook login successful');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const QuestionnaireScreen(step: 1, responses: {}),
        ),
      );

    } else {
      showError('Facebook login failed');
    }
  }

  void showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.red),
    );
  }

  void showSuccess(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isAndroid = Platform.isAndroid;
    final bool isIOS = Platform.isIOS;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Welcome Back",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 32),
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
                const SizedBox(height: 24),
                Row(
                  children: const [
                    Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text("or continue with"),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 16),
                if (isAndroid) ...[
                  GoogleLoginButton(onPressed: loginWithGoogle),
                  const SizedBox(height: 12),
                ],
                if (isIOS) ...[
                  const AppleLoginButton(),
                  const SizedBox(height: 12),
                ],
                FacebookLoginButton(
                  onPressed: loginWithFacebook,
                ),
                const SizedBox(height: 24),
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/register');
                    },
                    child: Text(
                      "No account yet? Register here",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blue.shade700,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
