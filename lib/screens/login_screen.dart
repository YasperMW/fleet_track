import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'main_shell.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  String? _error;

  static const _hardcodedEmail = 'admin@fleet.co';
  static const _hardcodedPassword = 'admin123';

  void _login() {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      setState(() => _error = 'Please fill in all fields');
      return;
    }

    if (email == _hardcodedEmail && password == _hardcodedPassword) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainShell()),
      );
    } else {
      setState(() => _error = 'Invalid email or password');
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navy,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Logo
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.teal, AppColors.blue],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(Icons.map_rounded,
                      size: 36, color: Colors.black),
                ),
                const SizedBox(height: 16),
                Text('FleetTrack', style: AppText.syne(size: 28, color: AppColors.teal)),
                const SizedBox(height: 6),
                Text('Fleet Management',
                    style: AppText.dm(size: 13, color: AppColors.muted)),
                const SizedBox(height: 48),

                // Email
                _InputField(
                  controller: _emailController,
                  hint: 'Email address',
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 14),

                // Password
                _InputField(
                  controller: _passwordController,
                  hint: 'Password',
                  prefixIcon: Icons.lock_outlined,
                  obscureText: _obscurePassword,
                  suffixIcon: GestureDetector(
                    onTap: () => setState(() => _obscurePassword = !_obscurePassword),
                    child: Icon(
                      _obscurePassword
                          ? Icons.visibility_off_rounded
                          : Icons.visibility_rounded,
                      size: 18,
                      color: AppColors.muted,
                    ),
                  ),
                  onSubmitted: (_) => _login(),
                ),
                const SizedBox(height: 8),

                // Error
                if (_error != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(_error!,
                        style: AppText.dm(size: 12, color: AppColors.red)),
                  ),

                // Login button
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: _login,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.teal, AppColors.blue],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text('Sign In',
                        textAlign: TextAlign.center,
                        style: AppText.dm(
                            size: 15, color: Colors.black, weight: FontWeight.w700)),
                  ),
                ),
                const SizedBox(height: 24),

                // Hardcoded hint
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.navy3,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    children: [
                      Text('Demo Credentials',
                          style: AppText.dm(
                              size: 11, color: AppColors.muted, weight: FontWeight.w600)),
                      const SizedBox(height: 4),
                      Text('admin@fleet.co / admin123',
                          style: AppText.mono(size: 11, color: AppColors.teal)),
                    ],
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

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData prefixIcon;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onSubmitted;

  const _InputField({
    required this.controller,
    required this.hint,
    required this.prefixIcon,
    this.obscureText = false,
    this.suffixIcon,
    this.keyboardType,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.navy2,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: AppText.dm(size: 14),
        onSubmitted: onSubmitted != null ? (v) => onSubmitted!(v) : null,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: AppText.dm(size: 14, color: AppColors.muted),
          prefixIcon: Icon(prefixIcon, size: 20, color: AppColors.muted),
          suffixIcon: suffixIcon,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }
}
