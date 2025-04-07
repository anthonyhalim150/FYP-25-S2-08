import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  bool isLoading = false;

  void _onLoginPressed() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() => isLoading = true);

      Future.delayed(Duration(seconds: 2), () {
        setState(() => isLoading = false);
        Navigator.pushReplacementNamed(context, '/home');
      });
    }
  }

  Future<void> _signInWithGoogle() async {
    GoogleSignIn _googleSignIn = GoogleSignIn();
    try {
      await _googleSignIn.signIn();
      Navigator.pushReplacementNamed(context, '/home');
    } catch (error) {
      print("Google Sign-In Error: $error");
    }
  }

  Future<void> _signInWithApple() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [AppleIDAuthorizationScopes.email],
      );
      Navigator.pushReplacementNamed(context, '/home');
    } catch (error) {
      print("Apple Sign-In Error: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Wise Workout", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                SizedBox(height: 24),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter your email' : null,
                  onSaved: (value) => email = value!,
                ),
                SizedBox(height: 12),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: (value) =>
                      value!.length < 6 ? 'Minimum 6 characters' : null,
                  onSaved: (value) => password = value!,
                ),
                SizedBox(height: 24),
                isLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _onLoginPressed,
                        child: Text('Login'),
                      ),
                SizedBox(height: 16),
                Text("Or login with"),
                SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: _signInWithGoogle,
                  icon: Icon(Icons.login),
                  label: Text("Google"),
                ),
                SignInWithAppleButton(
                  onPressed: _signInWithApple,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
