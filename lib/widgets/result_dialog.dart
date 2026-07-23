import 'package:flutter/material.dart';

import '../core/core.dart';
import '../models/models.dart';

class ResultDialog extends StatelessWidget {
  final GameStatus status;
  final GameMode mode;
  final Player humanPlayer;
  final bool isDark;
  final VoidCallback onPlayAgain;
  final VoidCallback onBackToMenu;

  const ResultDialog({
    super.key,
    required this.status,
    required this.mode,
    required this.humanPlayer,
    required this.isDark,
    required this.onPlayAgain,
    required this.onBackToMenu,
  });

  String get _title {
    switch (status) {
      case GameStatus.draw:
        return "It's a Draw!";
      case GameStatus.xWon:
        return mode == GameMode.vsComputer
            ? (humanPlayer == Player.x ? 'You Win! 🎉' : 'Computer Wins')
            : 'Player X Wins! 🎉';
      case GameStatus.oWon:
        return mode == GameMode.vsComputer
            ? (humanPlayer == Player.o ? 'You Win! 🎉' : 'Computer Wins')
            : 'Player O Wins! 🎉';
      case GameStatus.playing:
        return '';
    }
  }

  IconData get _icon {
    if (status == GameStatus.draw) return Icons.handshake_rounded;
    return Icons.emoji_events_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final bg = isDark ? AppColors.charcoal : AppColors.creamCard;
    final textColor = isDark ? AppColors.goldBright : AppColors.black;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 32),
      child: Container(
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.gold, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: AppColors.gold.withOpacity(0.25),
              blurRadius: 30,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: const BoxDecoration(
                gradient: AppColors.goldGradient,
                shape: BoxShape.circle,
              ),
              child: Icon(_icon, color: AppColors.black, size: 36),
            ),
            const SizedBox(height: 20),
            Text(
              _title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textColor,
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 28),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onBackToMenu,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: textColor,
                      side: BorderSide(color: AppColors.goldDeep),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: const Text('Menu'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onPlayAgain,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.gold,
                      foregroundColor: AppColors.black,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: const Text('Play Again'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
