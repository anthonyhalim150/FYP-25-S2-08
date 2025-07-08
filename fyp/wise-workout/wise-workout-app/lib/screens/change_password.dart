import 'package:flutter/material.dart';
import 'profile_screen.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentController = TextEditingController();
  final _newController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _showCurrent = false;
  bool _showNew = false;
  bool _showConfirm = false;
  bool _isLoading = false;
  String? _error;

  bool isPasswordStrong(String password) {
    final regex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^A-Za-z0-9]).{8,}$');
    return regex.hasMatch(password);
  }

  void changePassword() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    await Future.delayed(const Duration(seconds: 1));
    if (_currentController.text != 'old123') {
      setState(() {
        _error = 'Current password is incorrect.';
        _isLoading = false;
      });
      return;
    }
    setState(() {
      _isLoading = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Password changed successfully!')),
    );
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => ProfileScreen(userName: '')),
          (route) => false,
    );
  }

  @override
  void dispose() {
    _currentController.dispose();
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final bgColor = Theme.of(context).scaffoldBackgroundColor;
    final onBg = colorScheme.onBackground;
    final surface = colorScheme.surface;
    final onSurface = colorScheme.onSurface;
    final errorColor = Theme.of(context).colorScheme.error;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0.5,
        iconTheme: IconThemeData(color: onBg),
        title: Text(
          'Change Password',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: onBg,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.vpn_key_rounded,
                    color: colorScheme.primary, size: 48),
                const SizedBox(height: 7),
                Text(
                  "Change your password securely",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: onBg.withOpacity(0.95),
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                AnimatedOpacity(
                  opacity: _error != null ? 1 : 0,
                  duration: const Duration(milliseconds: 300),
                  child: _error != null
                      ? Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: errorColor.withOpacity(0.13),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.error_outline, color: errorColor, size: 19),
                        const SizedBox(width: 7),
                        Expanded(
                          child: Text(
                            _error!,
                            style: TextStyle(color: errorColor, fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                  )
                      : const SizedBox.shrink(),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                  decoration: BoxDecoration(
                    color: surface,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _buildPasswordField(
                          controller: _currentController,
                          label: "Current Password",
                          showPassword: _showCurrent,
                          onToggle: () => setState(() => _showCurrent = !_showCurrent),
                        ),
                        const SizedBox(height: 16),
                        _buildPasswordField(
                          controller: _newController,
                          label: "New Password",
                          showPassword: _showNew,
                          onToggle: () => setState(() => _showNew = !_showNew),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter a new password';
                            } else if (!isPasswordStrong(value)) {
                              return 'Min 8 chars, upper, lower, digit, special char';
                            } else if (value == _currentController.text) {
                              return 'New password must be different';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 3),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Min 8 chars, upper, lower, digit, special char",
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: onSurface.withOpacity(0.55),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildPasswordField(
                          controller: _confirmController,
                          label: "Confirm New Password",
                          showPassword: _showConfirm,
                          onToggle: () => setState(() => _showConfirm = !_showConfirm),
                          validator: (value) {
                            if (value != _newController.text) {
                              return 'Passwords do not match';
                            }
                            if (value == null || value.isEmpty) {
                              return 'Required field';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 26),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isLoading
                                ? null
                                : () {
                              if (_formKey.currentState!.validate()) {
                                changePassword();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colorScheme.primary,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            child: _isLoading
                                ? const SizedBox(
                              width: 26,
                              height: 26,
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                color: Colors.white,
                              ),
                            )
                                : Text(
                              'Change Password',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: colorScheme.onPrimary,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 2),
                      ],
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

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    bool showPassword = false,
    required VoidCallback onToggle,
    String? Function(String?)? validator,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final onSurface = colorScheme.onSurface;

    return TextFormField(
      controller: controller,
      obscureText: !showPassword,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color: onSurface),
        filled: true,
        fillColor: colorScheme.surfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            showPassword ? Icons.visibility : Icons.visibility_off,
            color: colorScheme.onSurface.withOpacity(0.6),
          ),
          onPressed: onToggle,
        ),
      ),
      validator: validator ??
              (value) => (value == null || value.isEmpty) ? 'Required field' : null,
    );
  }
}