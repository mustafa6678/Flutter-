import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/providers.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isSignUp = false;

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthProvider>();
    
    return Scaffold(
      appBar: AppBar(title: Text(_isSignUp ? 'Sign Up' : 'Login')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password', border: OutlineInputBorder()),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                if (_isSignUp) {
                  await auth.signUp(_emailController.text, _passwordController.text);
                } else {
                  await auth.signIn(_emailController.text, _passwordController.text);
                }
                if (auth.isAuthenticated && mounted) {
                  Navigator.pop(context);
                }
              },
              child: Text(_isSignUp ? 'Sign Up' : 'Login'),
            ),
            TextButton(
              onPressed: () => setState(() => _isSignUp = !_isSignUp),
              child: Text(_isSignUp ? 'Already have an account? Login' : 'Need an account? Sign Up'),
            ),
            const Divider(height: 48),
            OutlinedButton(
              onPressed: () async {
                await auth.signInAnonymously();
                if (auth.isAuthenticated && mounted) {
                  Navigator.pop(context);
                }
              },
              child: const Text('Play as Guest'),
            ),
          ],
        ),
      ),
    );
  }
}
