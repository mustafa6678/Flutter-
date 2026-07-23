import 'package:flutter/material.dart';

import '../core/core.dart';
import '../models/models.dart';

class GameStatusBar extends StatelessWidget {
  final GameStatus status;
  final Player currentPlayer;
  final GameMode mode;
  final Player humanPlayer;
  final Scoreboard scoreboard;
  final bool isDark;

  const GameStatusBar({
    super.key,
    required this.status,
    required this.currentPlayer,
    required this.mode,
    required this.humanPlayer,
    required this.scoreboard,
    required this.isDark,
  });

  String get _turnLabel {
    if (status.isOver) {
      switch (status) {
        case GameStatus.xWon:
          return _labelFor(Player.x, won: true);
        case GameStatus.oWon:
          return _labelFor(Player.o, won: true);
        case GameStatus.draw:
          return "It's a draw!";
        case GameStatus.playing:
          return '';
      }
    }
    return "${_labelFor(currentPlayer, won: false)}'s turn";
  }

  String _labelFor(Player player, {required bool won}) {
    final markLabel = player.label;
    if (mode == GameMode.vsComputer) {
      final isHuman = player == humanPlayer;
      final who = isHuman ? 'You' : 'Computer';
      return won ? '$who ($markLabel) win!' : who;
    }
    return won ? 'Player $markLabel wins!' : 'Player $markLabel';
  }

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? AppColors.goldBright : AppColors.black;

    return Column(
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: Text(
            _turnLabel,
            key: ValueKey(_turnLabel),
            style: TextStyle(
              color: textColor,
              fontSize: 20,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _ScorePill(label: 'X', value: scoreboard.xWins, isDark: isDark),
            const SizedBox(width: 12),
            _ScorePill(label: 'Draws', value: scoreboard.draws, isDark: isDark),
            const SizedBox(width: 12),
            _ScorePill(label: 'O', value: scoreboard.oWins, isDark: isDark),
          ],
        ),
      ],
    );
  }
}

class _ScorePill extends StatelessWidget {
  final String label;
  final int value;
  final bool isDark;

  const _ScorePill({required this.label, required this.value, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? AppColors.charcoal : AppColors.creamCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.goldDeep.withOpacity(0.6)),
      ),
      child: Column(
        children: [
          Text(
            '$value',
            style: const TextStyle(
              color: AppColors.gold,
              fontWeight: FontWeight.w800,
              fontSize: 16,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: isDark ? AppColors.goldBright.withOpacity(0.7) : AppColors.black.withOpacity(0.6),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
