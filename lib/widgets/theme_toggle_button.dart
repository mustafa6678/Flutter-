import 'package:flutter/material.dart';

import '../core/core.dart';

class ThemeToggleButton extends StatelessWidget {
  final bool isDark;
  final VoidCallback onPressed;

  const ThemeToggleButton({super.key, required this.isDark, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: AppConstants.themeAnimationDuration,
      transitionBuilder: (child, anim) => RotationTransition(
        turns: anim,
        child: FadeTransition(opacity: anim, child: child),
      ),
      child: IconButton(
        key: ValueKey(isDark),
        tooltip: isDark ? 'Switch to light mode' : 'Switch to dark mode',
        icon: Icon(
          isDark ? Icons.wb_sunny_rounded : Icons.nightlight_round,
          color: AppColors.gold,
        ),
        onPressed: onPressed,
      ),
    );
  }
}
