import 'package:flutter/material.dart';

import '../core/core.dart';
import '../models/models.dart';

class GameCell extends StatelessWidget {
  final Player value;
  final bool isWinningCell;
  final bool isDark;
  final VoidCallback onTap;

  const GameCell({
    super.key,
    required this.value,
    required this.isWinningCell,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final baseColor = isDark ? AppColors.charcoal : AppColors.creamCard;
    final borderColor = isWinningCell
        ? AppColors.gold
        : (isDark ? AppColors.slate : AppColors.creamBorder);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppConstants.markAnimationDuration,
        decoration: BoxDecoration(
          color: isWinningCell ? AppColors.gold.withOpacity(0.16) : baseColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: isWinningCell ? 2 : 1),
          boxShadow: isWinningCell
              ? [
                  BoxShadow(
                    color: AppColors.gold.withOpacity(0.35),
                    blurRadius: 14,
                    spreadRadius: 1,
                  ),
                ]
              : [],
        ),
        child: Center(
          child: AnimatedSwitcher(
            duration: AppConstants.markAnimationDuration,
            transitionBuilder: (child, animation) => ScaleTransition(
              scale: animation,
              child: child,
            ),
            child: value.isNone
                ? const SizedBox.shrink(key: ValueKey('empty'))
                : Text(
                    value.label,
                    key: ValueKey(value),
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w800,
                      color: value == Player.x
                          ? AppColors.gold
                          : (isDark ? AppColors.goldBright : AppColors.black),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
