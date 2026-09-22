import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';

class LoginTitleSection extends StatelessWidget {
  final String channel;

  const LoginTitleSection({super.key, this.channel = 'email'});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor =
        isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary;
    final secondaryTextColor =
        isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary;

    final title =
        channel == 'whatsapp' ? 'Enter your mobile number' : 'Enter your email';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 120),
        Text(
          title,
          style: AppTypography.displayMedium.copyWith(
            color: primaryTextColor,
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'We will send a verification code to authenticate your account.',
          style: AppTypography.bodySmall.copyWith(
            color: secondaryTextColor,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}
