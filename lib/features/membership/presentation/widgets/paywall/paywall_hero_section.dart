import 'package:flutter/material.dart';
import '../../../../../core/theme/app_color.dart';
import '../../../../../core/theme/app_typography.dart';

class PaywallHeroSection extends StatelessWidget {
  const PaywallHeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryText = isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary;
    final secondaryText = isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              style: AppTypography.displayLarge.copyWith(
                fontWeight: FontWeight.w600,
                color: primaryText,
                height: 1.15,
                fontSize: 26,
              ),
              children: [
                const TextSpan(text: 'Go Further with '),
                WidgetSpan(
                  alignment: PlaceholderAlignment.baseline,
                  baseline: TextBaseline.alphabetic,
                  child: ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [Color(0xFF1D4ED8), Color(0xFF8B5CF6), Color(0xFFE11D48)],
                    ).createShader(bounds),
                    child: Text(
                      'Peers Pro',
                      style: AppTypography.displayLarge.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        fontSize: 26,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Connect, collaborate, and create opportunities with verified peers.',
            style: AppTypography.bodySmall.copyWith(
              color: secondaryText,
              height: 1.35,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
