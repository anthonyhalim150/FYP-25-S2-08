import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import '../widgets/register_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final emailController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool showPassword = false;
  bool showConfirmPassword = false;
  bool agreeToTerms = false;
  bool isLoading = false;

  void showSnack(String msg, {bool success = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: success
            ? Colors.green
            : Theme.of(context).colorScheme.error,
      ),
    );
  }

  bool isPasswordStrong(String password) {
    final regex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^A-Za-z0-9]).{8,}$');
    return regex.hasMatch(password);
  }

  Future<void> handleRegister() async {
    if (!agreeToTerms) {
      showSnack("Please agree to the Terms & Conditions");
      return;
    }
    if (usernameController.text.trim().isEmpty) {
      showSnack("Username cannot be empty");
      return;
    }
    if (!isPasswordStrong(passwordController.text)) {
      showSnack("Password must be at least 8 characters and include upper, lower, digit, and special character.");
      return;
    }
    if (passwordController.text != confirmPasswordController.text) {
      showSnack("Passwords do not match");
      return;
    }
    setState(() => isLoading = true);
    final error = await registerUser(
      context,
      emailController.text,
      usernameController.text,
      passwordController.text,
      firstNameController.text,
      lastNameController.text,
    );
    setState(() => isLoading = false);
    if (error != null) {
      showSnack(error);
    } else {
      showSnack("OTP sent to your email!", success: true);
    }
  }

  void showTermsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Terms & Conditions'),
        content: SingleChildScrollView(
          child: Text(
            '''
Welcome to FitQuest!
- Use of this service is at your own risk.
- Respect community guidelines.
- Your data is held confidentially.
Thank you for using FitQuest!
''',
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Close'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset(
                  'assets/icons/fitquest-icon.png',
                  height: 150,
                ),
                const SizedBox(height: 32),
                Text(
                  "Email",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: 'Enter Your Email',
                    hintStyle: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.hintColor,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: colorScheme.surface,
                  ),
                ),
                const SizedBox(height: 16),

                Text(
                  "First Name",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: firstNameController,
                  decoration: InputDecoration(
                    hintText: 'Enter Your First Name',
                    hintStyle: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.hintColor,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: colorScheme.surface,
                  ),
                ),
                const SizedBox(height: 16),

                Text(
                  "Last Name",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: lastNameController,
                  decoration: InputDecoration(
                    hintText: 'Enter Your Last Name',
                    hintStyle: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.hintColor,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: colorScheme.surface,
                  ),
                ),
                const SizedBox(height: 16),

                Text(
                  "Username",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    hintText: 'Choose a Username',
                    hintStyle: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.hintColor,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: colorScheme.surface,
                  ),
                ),
                const SizedBox(height: 16),

                Text(
                  "Password",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: passwordController,
                  obscureText: !showPassword,
                  decoration: InputDecoration(
                    hintText: 'Create Password',
                    hintStyle: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.hintColor,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: colorScheme.surface,
                    suffixIcon: IconButton(
                      icon: Icon(
                        showPassword ? Icons.visibility_off : Icons.visibility,
                        color: theme.iconTheme.color,
                      ),
                      onPressed: () {
                        setState(() => showPassword = !showPassword);
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  "Min 8 chars, upper, lower, digit, special char",
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.hintColor,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 16),

                Text(
                  "Confirm Password",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: confirmPasswordController,
                  obscureText: !showConfirmPassword,
                  decoration: InputDecoration(
                    hintText: 'Re-enter Password',
                    hintStyle: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.hintColor,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: colorScheme.surface,
                    suffixIcon: IconButton(
                      icon: Icon(
                        showConfirmPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: theme.iconTheme.color,
                      ),
                      onPressed: () {
                        setState(() => showConfirmPassword = !showConfirmPassword);
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Checkbox(
                      value: agreeToTerms,
                      activeColor: colorScheme.primary,
                      onChanged: (val) => setState(() => agreeToTerms = val ?? false),
                    ),
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                          text: 'I agree to the ',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.textTheme.bodyMedium?.color,
                          ),
                          children: [
                            TextSpan(
                              text: 'Terms & Conditions',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: colorScheme.primary,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()..onTap = showTermsDialog,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: isLoading ? null : handleRegister,
                    child: isLoading
                        ? CircularProgressIndicator(
                      color: colorScheme.onPrimary,
                      strokeWidth: 2,
                    )
                        : Text(
                      "Create Account",
                      style: theme.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        letterSpacing: 1,
                        color: colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/');
                    },
                    child: Text(
                      "Already have an account? Click here to go back to the login page!",
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontSize: 14,
                        color: colorScheme.primary,
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