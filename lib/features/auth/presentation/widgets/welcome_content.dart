import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';

class WelcomeContent extends StatelessWidget {
  const WelcomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor = isDark
        ? AppColor.darkTextPrimary
        : AppColor.lightTextPrimary;
    final secondaryTextColor = isDark
        ? AppColor.darkTextSecondary
        : AppColor.lightTextSecondary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: AppTypography.displayMedium.copyWith(
              color: primaryTextColor,
              fontSize: 22,
              fontWeight: FontWeight.w600,
              height: 1.2,
              wordSpacing: 1.5,
            ),
            children: const [
              TextSpan(text: 'PEERS ARE PARTNERS\n'),
              TextSpan(text: 'IN BUSINESS AND'),
              TextSpan(
                text: '\nFRIENDS IN LIFE.',
                style: TextStyle(color: AppColor.primaryPink),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'A structured community for entrepreneurs to learn, collaborate and grow together.',
          style: AppTypography.bodyLarge.copyWith(
            color: secondaryTextColor,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
