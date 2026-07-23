import 'package:flutter/material.dart';

import '../core/core.dart';
import '../models/models.dart';

class ModeSelectorCard extends StatelessWidget {
  final GameMode mode;
  final IconData icon;
  final bool isDark;
  final VoidCallback onTap;

  const ModeSelectorCard({
    super.key,
    required this.mode,
    required this.icon,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? AppColors.goldBright : AppColors.black;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
          decoration: BoxDecoration(
            color: isDark ? AppColors.charcoal : AppColors.creamCard,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.goldDeep.withOpacity(0.7)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: const BoxDecoration(
                  gradient: AppColors.goldGradient,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: AppColors.black, size: 26),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mode.label,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      mode.description,
                      style: TextStyle(
                        color: textColor.withOpacity(0.65),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: AppColors.gold),
            ],
          ),
        ),
      ),
    );
  }
}
