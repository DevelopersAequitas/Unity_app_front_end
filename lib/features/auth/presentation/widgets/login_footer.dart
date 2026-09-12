import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';

class LoginFooter extends StatelessWidget {
  final VoidCallback? onTermsTap;
  final VoidCallback? onPrivacyTap;

  const LoginFooter({super.key, this.onTermsTap, this.onPrivacyTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textSecondary = isDark
        ? AppColor.darkTextSecondary
        : AppColor.lightTextSecondary;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'By continuing, you agree to our',
          style: AppTypography.bodySmall.copyWith(color: textSecondary),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: onTermsTap ?? () {},
              child: Text(
                'Terms of Service',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColor.primaryBlue,
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.underline,
                  decorationColor: AppColor.primaryBlue,
                ),
              ),
            ),
            Text(
              ' and ',
              style: AppTypography.bodySmall.copyWith(color: textSecondary),
            ),
            GestureDetector(
              onTap: onPrivacyTap ?? () {},
              child: Text(
                'Privacy Policy.',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColor.primaryBlue,
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.underline,
                  decorationColor: AppColor.primaryBlue,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        Text(
          'A Global Community\nfor Entrepreneurs',
          textAlign: TextAlign.center,
          style: AppTypography.bodySmall.copyWith(
            color: isDark
                ? AppColor.primaryBlue.withValues(alpha: 0.7)
                : AppColor.primaryBlue.withValues(alpha: 0.6),
            height: 1.4,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
