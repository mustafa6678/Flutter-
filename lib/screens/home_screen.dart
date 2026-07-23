import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/core.dart';
import '../models/models.dart';
import '../providers/providers.dart';
import '../widgets/widgets.dart';
import 'game_screen.dart';
import 'history_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _startGame(BuildContext context, GameMode mode) {
    context.read<GameProvider>().startNewMatch(selectedMode: mode);
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 350),
        pageBuilder: (_, __, ___) => const GameScreen(),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(begin: const Offset(0, 0.05), end: Offset.zero)
                  .animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
              child: child,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final authProvider = context.watch<AuthProvider>();
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            tooltip: 'Play history',
            icon: const Icon(Icons.history_rounded, color: AppColors.gold),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const HistoryScreen()),
            ),
          ),
          ThemeToggleButton(
            isDark: isDark,
            onPressed: () => themeProvider.toggleTheme(),
          ),
          IconButton(
            tooltip: 'Sign out',
            icon: const Icon(Icons.logout_rounded, color: AppColors.gold),
            onPressed: () => authProvider.signOut(),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark ? AppColors.darkBackgroundGradient : AppColors.lightBackgroundGradient,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _GoldTitle(isDark: isDark),
                const SizedBox(height: 12),
                Text(
                  'Welcome, ${authProvider.displayName}',
                  style: TextStyle(
                    color: (isDark ? AppColors.goldBright : AppColors.black).withOpacity(0.7),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 40),
                ModeSelectorCard(
                  mode: GameMode.twoPlayer,
                  icon: Icons.people_alt_rounded,
                  isDark: isDark,
                  onTap: () => _startGame(context, GameMode.twoPlayer),
                ),
                const SizedBox(height: 16),
                ModeSelectorCard(
                  mode: GameMode.vsComputer,
                  icon: Icons.smart_toy_rounded,
                  isDark: isDark,
                  onTap: () => _startGame(context, GameMode.vsComputer),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GoldTitle extends StatelessWidget {
  final bool isDark;
  const _GoldTitle({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => AppColors.goldGradient.createShader(bounds),
      child: Text(
        'TIC TAC TOE',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 34,
          fontWeight: FontWeight.w900,
          letterSpacing: 3,
          color: Colors.white,
          shadows: [
            Shadow(
              color: AppColors.gold.withOpacity(isDark ? 0.5 : 0.25),
              blurRadius: 20,
            ),
          ],
        ),
      ),
    );
  }
}
