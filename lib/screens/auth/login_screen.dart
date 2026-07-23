import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/core.dart';
import '../../providers/providers.dart';
import '../../widgets/widgets.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final auth = context.read<AuthProvider>();
    await auth.signIn(
      email: _emailController.text,
      password: _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final isDark = context.watch<ThemeProvider>().isDarkMode;
    final textColor = isDark ? AppColors.goldBright : AppColors.black;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark ? AppColors.darkBackgroundGradient : AppColors.lightBackgroundGradient,
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ShaderMask(
                    shaderCallback: (bounds) => AppColors.goldGradient.createShader(bounds),
                    child: const Text(
                      'TIC TAC TOE',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2.5,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Sign in to track your play history',
                    style: TextStyle(color: textColor.withOpacity(0.65), fontSize: 13),
                  ),
                  const SizedBox(height: 36),
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
                    label: 'Password',
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
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
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
                          : const Text('Sign In', style: TextStyle(fontWeight: FontWeight.w700)),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextButton(
                    onPressed: auth.isLoading
                        ? null
                        : () => Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => const SignUpScreen()),
                            ),
                    child: Text(
                      "Don't have an account? Sign up",
                      style: TextStyle(color: textColor.withOpacity(0.75)),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(child: Divider(color: textColor.withOpacity(0.2))),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text('or', style: TextStyle(color: textColor.withOpacity(0.5))),
                      ),
                      Expanded(child: Divider(color: textColor.withOpacity(0.2))),
                    ],
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: auth.isLoading
                        ? null
                        : () => context.read<AuthProvider>().signInAnonymously(),
                    icon: Icon(Icons.person_outline_rounded, color: textColor),
                    label: Text('Continue as Guest', style: TextStyle(color: textColor)),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppColors.goldDeep.withOpacity(0.6)),
                      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
