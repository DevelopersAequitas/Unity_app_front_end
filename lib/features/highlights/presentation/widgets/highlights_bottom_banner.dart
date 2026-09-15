import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';

class HighlightsBottomBanner extends StatelessWidget {
  final VoidCallback? onTap;

  const HighlightsBottomBanner({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: isDark
                ? [
                    const Color(0xFF1E2433),
                    const Color(0xFF282338),
                  ]
                : [
                    const Color(0xFFEFF6FF),
                    const Color(0xFFF5EEFD),
                  ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          border: Border.all(
            color: isDark ? AppColor.darkBorder : AppColor.lightBorder,
            width: 1,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Small actions.\nStronger community.',
                          style: AppTypography.titleMedium.copyWith(
                            color: isDark
                                ? AppColor.darkTextPrimary
                                : AppColor.lightTextPrimary,
                            height: 1.25,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Participate. Collaborate. Create impact.',
                          style: AppTypography.bodySmall.copyWith(
                            color: isDark
                                ? AppColor.darkTextSecondary
                                : AppColor.lightTextSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  _buildRightAction(isDark),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRightAction(bool isDark) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Together\nWe Grow ↗',
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColor.primaryBlue,
                    fontStyle: FontStyle.italic,
                    height: 1.15,
                  ),
                  textAlign: TextAlign.right,
                ),
              ],
            ),
          ],
        ),
        const SizedBox(width: 8),
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: isDark ? AppColor.darkSurface : AppColor.white,
            shape: BoxShape.circle,
            border: Border.all(
              color: isDark ? AppColor.darkBorder : AppColor.lightBorder,
              width: 1,
            ),
          ),
          child: Icon(
            Icons.chevron_right_rounded,
            size: 20,
            color: isDark
                ? AppColor.darkTextPrimary
                : AppColor.lightTextPrimary,
          ),
        ),
      ],
    );
  }
}
