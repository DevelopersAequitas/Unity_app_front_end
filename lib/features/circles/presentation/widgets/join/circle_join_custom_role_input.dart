import 'package:flutter/material.dart';
import '../../../../../core/theme/app_color.dart';
import '../../../../../core/theme/app_typography.dart';

class CircleJoinCustomRoleInput extends StatelessWidget {
  final TextEditingController controller;

  const CircleJoinCustomRoleInput({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColor.darkSurface : AppColor.lightSurface;
    final borderColor = isDark ? AppColor.darkBorder : AppColor.lightBorder;
    final primaryText = isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary;
    final secondaryText = isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Specify Custom Role',
          style: AppTypography.labelSmall.copyWith(color: secondaryText),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          style: AppTypography.bodyMedium.copyWith(color: primaryText),
          decoration: InputDecoration(
            hintText: 'e.g. Architect, Consultant, Contractor...',
            hintStyle: AppTypography.bodySmall.copyWith(color: secondaryText),
            filled: true,
            fillColor: cardBg,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColor.primaryBlue, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
