import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'main_shell.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController(text: 'admin@fleet.co');
  final _passwordController = TextEditingController(text: 'admin123');
  bool _obscurePassword = true;
  bool _isLoading = false;
  String? _error;

  static const _hardcodedEmail = 'admin@fleet.co';
  static const _hardcodedPassword = 'admin123';

  void _login() {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      final email = _emailController.text.trim();
      final password = _passwordController.text;

      if (email == _hardcodedEmail && password == _hardcodedPassword) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainShell()),
        );
      } else {
        setState(() {
          _isLoading = false;
          _error = 'Invalid email or password';
        });
      }
    });
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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(0.4, -0.2),
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0E1E38), Color(0xFF070E1C)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Container(
                  width: 44, height: 44,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [AppColors.teal, AppColors.blue]),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.gps_fixed_rounded, size: 22, color: Color(0xFF050C1A)),
                ),
                const SizedBox(height: 16),
                Text('Welcome back', style: AppText.syne(size: 20)),
                const SizedBox(height: 5),
                Text('Sign in to your fleet account', style: AppText.dm(size: 12, color: AppColors.muted)),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.navy3,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.teal.withOpacity(0.4)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.mail_outline_rounded, size: 16, color: AppColors.muted.withOpacity(0.55)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _emailController,
                          style: AppText.dm(size: 13, color: AppColors.text),
                          decoration: InputDecoration.collapsed(
                            hintText: 'Email address',
                            hintStyle: AppText.dm(size: 13, color: AppColors.muted),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.navy3,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.lock_outline_rounded, size: 16, color: AppColors.muted.withOpacity(0.55)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          style: AppText.dm(size: 13, color: AppColors.text),
                          decoration: InputDecoration.collapsed(
                            hintText: 'Password',
                            hintStyle: AppText.dm(size: 13, color: AppColors.muted),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => setState(() => _obscurePassword = !_obscurePassword),
                        child: Icon(
                          _obscurePassword ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                          size: 16, color: AppColors.muted.withOpacity(0.55),
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 16),
                    child: Text('Forgot password?', style: AppText.dm(size: 12, color: AppColors.teal, weight: FontWeight.w500)),
                  ),
                ),
                if (_error != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(_error!, style: AppText.dm(size: 12, color: AppColors.red)),
                  ),
                GestureDetector(
                  onTap: _isLoading ? null : _login,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [AppColors.teal, AppColors.blue]),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [BoxShadow(color: AppColors.teal.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 4))],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (_isLoading)
                          const SizedBox(
                            width: 18, height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF050C1A)),
                          )
                        else ...[
                          Icon(Icons.login_rounded, size: 18, color: const Color(0xFF050C1A)),
                          const SizedBox(width: 6),
                          Text('Sign In', style: AppText.dm(size: 14, color: const Color(0xFF050C1A), weight: FontWeight.w700)),
                        ],
                      ],
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: GestureDetector(
                      onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Contact your fleet administrator to create an account'), behavior: SnackBarBehavior.floating),
                      ),
                      child: RichText(
                        text: TextSpan(
                          style: AppText.dm(size: 12, color: AppColors.muted),
                          children: [
                            const TextSpan(text: 'No account? '),
                            TextSpan(text: 'Contact admin', style: AppText.dm(size: 12, color: AppColors.teal, weight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(child: Container(height: 1, color: AppColors.border)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text('OR', style: AppText.dm(size: 11, color: AppColors.muted, weight: FontWeight.w500)),
                    ),
                    Expanded(child: Container(height: 1, color: AppColors.border)),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.navy3,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.security_rounded, size: 18, color: AppColors.blue),
                      const SizedBox(width: 8),
                      Text('Sign in with SSO', style: AppText.dm(size: 13, weight: FontWeight.w500)),
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
