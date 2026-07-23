import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/core.dart';
import '../../providers/providers.dart';
import '../../widgets/widgets.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final auth = context.read<AuthProvider>();
    final success = await auth.signUp(
      email: _emailController.text,
      password: _passwordController.text,
      displayName: _nameController.text,
    );
    if (success && mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final isDark = context.watch<ThemeProvider>().isDarkMode;
    final textColor = isDark ? AppColors.goldBright : AppColors.black;

    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark ? AppColors.darkBackgroundGradient : AppColors.lightBackgroundGradient,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 12),
                Text(
                  'Join in to save your win/loss history',
                  style: TextStyle(color: textColor.withOpacity(0.65), fontSize: 13),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 28),
                AuthTextField(
                  controller: _nameController,
                  label: 'Display Name',
                  icon: Icons.badge_outlined,
                  isDark: isDark,
                ),
                const SizedBox(height: 16),
                AuthTextField(
                  controller: _emailController,
                  label: 'Email',
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  isDark: isDark,
                ),
                const SizedBox(height: 16),
                AuthTextField(
                  controller: _passwordController,
                  label: 'Password (min. 6 characters)',
                  icon: Icons.lock_outline_rounded,
                  obscureText: true,
                  isDark: isDark,
                ),
                if (auth.errorMessage != null) ...[
                  const SizedBox(height: 14),
                  Text(
                    auth.errorMessage!,
                    style: const TextStyle(color: AppColors.danger, fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
                ],
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: auth.isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.gold,
                    foregroundColor: AppColors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: auth.isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.black),
                        )
                      : const Text('Create Account', style: TextStyle(fontWeight: FontWeight.w700)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
