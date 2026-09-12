import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';

class RegisterTermsNotice extends StatelessWidget {
  const RegisterTermsNotice({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final secondaryColor = isDark
        ? AppColor.darkTextSecondary
        : AppColor.lightTextSecondary;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Text.rich(
          TextSpan(
            text: 'By creating an account, you agree to our\n',
            style: AppTypography.bodySmall.copyWith(
              color: secondaryColor,
              fontSize: 11,
              height: 1.4,
            ),
            children: [
              TextSpan(
                text: 'Terms of Service',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColor.primaryBlue,
                  fontWeight: FontWeight.w500,
                  fontSize: 11,
                ),
              ),
              const TextSpan(text: ' and '),
              TextSpan(
                text: 'Privacy Policy',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColor.primaryBlue,
                  fontWeight: FontWeight.w500,
                  fontSize: 11,
                ),
              ),
              const TextSpan(text: '.'),
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
