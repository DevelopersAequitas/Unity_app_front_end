import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';

class ProfileSectionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final int completionPercentage;
  final VoidCallback onTap;
  final Color accentColor;

  const ProfileSectionTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.completionPercentage,
    required this.onTap,
    this.accentColor = AppColor.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 4),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColor.borderSubtle),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm + 2),
            child: Row(
              children: [
                // Icon
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                  child: Icon(
                    icon,
                    size: 18,
                    color: accentColor,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm + 2),

                // Title & Subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: AppTypography.labelLarge.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColor.textPrimary,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColor.textTertiary,
                          fontSize: 11,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: AppSpacing.xs),

                // Percentage Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                  decoration: BoxDecoration(
                    color: completionPercentage == 100
                        ? const Color(0xFF10B981).withValues(alpha: 0.1)
                        : AppColor.backgroundSubtle,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
                    border: Border.all(
                      color: completionPercentage == 100
                          ? const Color(0xFF10B981).withValues(alpha: 0.3)
                          : AppColor.borderSubtle,
                    ),
                  ),
                  child: Text(
                    '$completionPercentage%',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: completionPercentage == 100
                          ? const Color(0xFF10B981)
                          : (completionPercentage > 50 ? AppColor.primary : AppColor.textTertiary),
                    ),
                  ),
                ),

                const SizedBox(width: AppSpacing.xs),

                const Icon(
                  Icons.chevron_right_rounded,
                  size: 18,
                  color: AppColor.textTertiary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
