import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';

class ProfileCompletionCard extends StatelessWidget {
  final int percentage;

  const ProfileCompletionCard({
    super.key,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 4),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColor.lightSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColor.lightBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 52,
            height: 52,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 52,
                  height: 52,
                  child: CircularProgressIndicator(
                    value: percentage / 100.0,
                    strokeWidth: 4.5,
                    backgroundColor: AppColor.lightSurfaceSubtle,
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColor.primaryBlue),
                  ),
                ),
                ShaderMask(
                  shaderCallback: (bounds) => AppColor.brandGradient.createShader(bounds),
                  child: Text(
                    '$percentage%',
                    style: AppTypography.labelLarge.copyWith(
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      fontSize: 12.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Profile Completeness',
                  style: AppTypography.titleSmall.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColor.lightTextPrimary,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  percentage == 100
                      ? 'Your profile is fully complete and verified.'
                      : 'Complete all sections to maximize your network visibility.',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColor.lightTextTertiary,
                    fontSize: 11.5,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
