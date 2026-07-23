import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/core.dart';
import '../../providers/providers.dart';
import '../home_screen.dart';
import 'login_screen.dart';

/// Root-level widget that watches sign-in state and shows the login flow
/// or the game itself accordingly. Also keeps [GameProvider.currentUid] in
/// sync so completed matches get saved under the right user.
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    // Keep GameProvider aware of who's signed in (or not) without needing
    // every screen to thread the uid through manually.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GameProvider>().currentUid = auth.uid;
    });

    switch (auth.status) {
      case AuthStatus.unknown:
        return const _SplashLoader();
      case AuthStatus.signedOut:
        return const LoginScreen();
      case AuthStatus.signedIn:
        return const HomeScreen();
    }
  }
}

class _SplashLoader extends StatelessWidget {
  const _SplashLoader();

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark ? AppColors.darkBackgroundGradient : AppColors.lightBackgroundGradient,
        ),
        child: const Center(
          child: CircularProgressIndicator(color: AppColors.gold),
        ),
      ),
    );
  }
}
