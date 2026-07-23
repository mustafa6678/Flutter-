import 'package:flutter/material.dart';

import '../core/core.dart';
import '../models/models.dart';
import 'game_cell.dart';

class GameBoard extends StatelessWidget {
  final List<Player> board;
  final List<int>? winningLine;
  final bool isDark;
  final bool interactive;
  final void Function(int index) onCellTap;

  const GameBoard({
    super.key,
    required this.board,
    required this.winningLine,
    required this.isDark,
    required this.interactive,
    required this.onCellTap,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: AppColors.goldGradient,
        ),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isDark ? AppColors.black : AppColors.cream,
            borderRadius: BorderRadius.circular(18),
          ),
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: AppConstants.cellCount,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: AppConstants.boardSize,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
            itemBuilder: (context, index) {
              return IgnorePointer(
                ignoring: !interactive,
                child: GameCell(
                  value: board[index],
                  isWinningCell: winningLine?.contains(index) ?? false,
                  isDark: isDark,
                  onTap: () => onCellTap(index),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
