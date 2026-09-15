import 'package:flutter/material.dart';
import '../../../../../core/theme/app_color.dart';
import '../../../../../core/theme/app_typography.dart';

class PaywallSecureBadge extends StatelessWidget {
  const PaywallSecureBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColor.darkSurface : AppColor.white;
    final borderColor = isDark ? AppColor.darkBorder : AppColor.lightBorder;
    final primaryText = isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary;
    final secondaryText = isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor, width: 0.8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF3B82F6).withValues(alpha: 0.12),
            ),
            child: const Center(
              child: Icon(
                Icons.verified_user_outlined,
                color: Color(0xFF3B82F6),
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Secure Payments via Zoho Billing',
                  style: AppTypography.bodySmall.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    color: primaryText,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'UPI • Cards • Netbanking • 100% Secure',
                  style: AppTypography.bodySmall.copyWith(
                    fontSize: 10,
                    color: secondaryText,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            size: 20,
            color: isDark ? AppColor.darkTextTertiary : AppColor.lightTextTertiary,
          ),
        ],
      ),
    );
  }
}
