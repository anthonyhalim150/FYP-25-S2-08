import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/auth_service.dart';
import '../widgets/google_login_button.dart';
import '../widgets/apple_login_button.dart';
import '../widgets/facebook_login_button.dart';
import '../utils/sanitize.dart';
import 'questionnaires/questionnaire_screen.dart';
import 'questionnaires/questionnaire_screen_start.dart';

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

  bool _obscurePassword = true;

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
      await navigateAfterLogin(jwt);
    } else {
      showError('Invalid email or password');
    }
  }

  Future<void> loginWithGoogle() async {
    final googleData = await authService.signInWithGoogle();
    if (googleData == null) {
      showError('Google sign-in was cancelled or failed');
      return;
    }

    final response = await http.post(
      Uri.parse('$backendUrl/auth/google'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': googleData['email'],
        'firstName': googleData['firstName'],
        'lastName': googleData['lastName'],
      }),
    );

    print('Google login status: ${response.statusCode}');
    print('Google login response: ${response.body}');

    final cookie = response.headers['set-cookie'];
    if (response.statusCode == 200 && cookie != null) {
      final jwt = cookie.split(';').first.split('=').last;
      await secureStorage.write(key: 'jwt_cookie', value: jwt);
      showSuccess('Google login successful');
      await navigateAfterLogin(jwt);
    } else {
      showError('Google login failed');
    }
  }

  Future<void> loginWithFacebook() async {
    final fbData = await authService.signInWithFacebook();
    if (fbData == null) {
      showError('Facebook sign-in was cancelled or failed');
      return;
    }

    final response = await http.post(
      Uri.parse('$backendUrl/auth/facebook'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': fbData['email'],
        'firstName': fbData['firstName'],
        'lastName': fbData['lastName'],
      }),
    );

    print('Facebook login status: ${response.statusCode}');
    print('Facebook login response: ${response.body}');

    final cookie = response.headers['set-cookie'];
    if (response.statusCode == 200 && cookie != null) {
      final jwt = cookie.split(';').first.split('=').last;
      await secureStorage.write(key: 'jwt_cookie', value: jwt);
      showSuccess('Facebook login successful');
      await navigateAfterLogin(jwt);
    } else {
      showError('Facebook login failed');
      }
  }

  Future<void> navigateAfterLogin(String jwt) async {
    final hasPreferences = await checkPreferences(jwt);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (hasPreferences) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => SplashAndOnboardingWrapper(),
          ),
        );
      }
    });
  }

  Future<bool> checkPreferences(String jwt) async {
    final res = await http.get(
      Uri.parse('$backendUrl/questionnaire/check'),
      headers: {'Cookie': 'session=$jwt'},
    );

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return data['hasPreferences'] as bool;
    } else {
      showError('Failed to check preferences');
      return false;
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
                Image.asset(
                  'assets/icons/fitquest-icon.png',
                  height: 150,
                ),
                const SizedBox(height: 32),
                const Text(
                  "Email",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: 'Enter Your Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Password",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    hintText: 'Enter Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo.shade900,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                  onPressed: loginWithEmail,
                  child: const Text(
                    'CONTINUE YOUR JOURNEY! →',
                    style: TextStyle(letterSpacing: 1.2),
                  ),
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
                FacebookLoginButton(onPressed: loginWithFacebook),
                const SizedBox(height: 24),
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/forgot-password');
                    },
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(color: Colors.indigo),
                    ),
                  ),
                ),
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/register');
                    },
                    child: const Text(
                      'Create Account?',
                      style: TextStyle(color: Colors.indigo),
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
