import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';

class VerifyOtpTitleSection extends StatelessWidget {
  final String identifier;
  final String channel;

  const VerifyOtpTitleSection({
    super.key,
    required this.identifier,
    this.channel = 'email',
  });

  String get _formattedTarget {
    if (identifier.isEmpty) return '';
    return ' ($identifier)';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor =
        isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary;
    final secondaryTextColor =
        isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary;

    final subtitle = channel == 'whatsapp'
        ? 'Enter the 4-digit code sent to your registered WhatsApp number$_formattedTarget'
        : 'Enter the 4-digit code sent to your registered email address$_formattedTarget';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Enter OTP',
          style: AppTypography.displayMedium.copyWith(
            color: primaryTextColor,
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: AppTypography.bodyMedium.copyWith(
            color: secondaryTextColor,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}
