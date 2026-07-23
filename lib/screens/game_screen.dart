import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/core.dart';
import '../models/models.dart';
import '../providers/providers.dart';
import '../widgets/widgets.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  bool _dialogShown = false;

  @override
  Widget build(BuildContext context) {
    final gameProvider = context.watch<GameProvider>();
    final themeProvider = context.watch<ThemeProvider>();
    final isDark = themeProvider.isDarkMode;

    if (gameProvider.isGameOver && !_dialogShown) {
      _dialogShown = true;
      WidgetsBinding.instance.addPostFrameCallback((_) => _showResultDialog(context));
    } else if (!gameProvider.isGameOver) {
      _dialogShown = false;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(gameProvider.mode.label),
        actions: [
          IconButton(
            tooltip: 'Restart round',
            icon: const Icon(Icons.refresh_rounded, color: AppColors.gold),
            onPressed: () => context.read<GameProvider>().restartRound(),
          ),
          ThemeToggleButton(
            isDark: isDark,
            onPressed: () => themeProvider.toggleTheme(),
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
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GameStatusBar(
                  status: gameProvider.status,
                  currentPlayer: gameProvider.currentPlayer,
                  mode: gameProvider.mode,
                  humanPlayer: gameProvider.humanPlayer,
                  scoreboard: gameProvider.scoreboard,
                  isDark: isDark,
                ),
                const SizedBox(height: 32),
                GameBoard(
                  board: gameProvider.board,
                  winningLine: gameProvider.winningLine,
                  isDark: isDark,
                  interactive: !gameProvider.isGameOver && !gameProvider.isAiTurn,
                  onCellTap: (index) => context.read<GameProvider>().makeMove(index),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showResultDialog(BuildContext context) {
    final gameProvider = context.read<GameProvider>();
    final isDark = context.read<ThemeProvider>().isDarkMode;

    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.6),
      builder: (dialogContext) {
        return ResultDialog(
          status: gameProvider.status,
          mode: gameProvider.mode,
          humanPlayer: gameProvider.humanPlayer,
          isDark: isDark,
          onPlayAgain: () {
            Navigator.of(dialogContext).pop();
            gameProvider.restartRound();
          },
          onBackToMenu: () {
            Navigator.of(dialogContext).pop();
            Navigator.of(context).pop();
          },
        );
      },
    );
  }
}
