import 'package:flutter/material.dart';

import '../core/core.dart';

class AuthTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool obscureText;
  final TextInputType keyboardType;
  final bool isDark;

  const AuthTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    required this.isDark,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? AppColors.goldBright : AppColors.black;

    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: TextStyle(color: textColor),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: textColor.withOpacity(0.6)),
        prefixIcon: Icon(icon, color: AppColors.gold),
        filled: true,
        fillColor: isDark ? AppColors.charcoal : AppColors.creamCard,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppColors.goldDeep.withOpacity(0.5)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppColors.goldDeep.withOpacity(0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.gold, width: 1.5),
        ),
      ),
    );
  }
}
