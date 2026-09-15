import 'package:flutter/material.dart';
import '../../../../../core/theme/app_color.dart';
import '../../../../../core/theme/app_typography.dart';

class PaywallFooterSkyline extends StatelessWidget {
  const PaywallFooterSkyline({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Text(
                'A Global Community\nof Collaborative Entrepreneurs',
                textAlign: TextAlign.center,
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  height: 1.3,
                  color: const Color(0xFF1E40AF),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(width: 24, height: 1, color: const Color(0xFF2563EB)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      'TOGETHER WE GROW',
                      style: AppTypography.labelSmall.copyWith(
                        letterSpacing: 2.0,
                        fontSize: 9.5,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF1D4ED8),
                      ),
                    ),
                  ),
                  Container(width: 24, height: 1, color: const Color(0xFF2563EB)),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(24),
            bottomRight: Radius.circular(24),
          ),
          child: Container(
            width: double.infinity,
            color: isDark ? AppColor.darkBackground : AppColor.white,
            child: Image.asset(
              'assets/images/skyline_banner.png',
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Image.asset(
                'assets/images/end_screen_image.png',
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => const SizedBox(height: 80),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
