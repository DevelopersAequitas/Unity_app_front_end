import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/router/app_router.dart';

class HighlightsHeader extends StatelessWidget {
  const HighlightsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Highlights',
                  style: AppTypography.displayMedium.copyWith(
                    color: isDark
                        ? AppColor.darkTextPrimary
                        : AppColor.lightTextPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Explore. Participate. Make an Impact.',
                  style: AppTypography.bodyMedium.copyWith(
                    color: isDark
                        ? AppColor.darkTextSecondary
                        : AppColor.lightTextSecondary,
                  ),
                ),
              ],
            ),
          ),
          _buildNotificationBell(context, isDark),
        ],
      ),
    );
  }

  Widget _buildNotificationBell(BuildContext context, bool isDark) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(AppRoutes.notifications);
      },
      borderRadius: BorderRadius.circular(24),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isDark ? AppColor.darkSurface : AppColor.lightSurface,
          border: Border.all(
            color: isDark ? AppColor.darkBorder : AppColor.lightBorder,
            width: 1,
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              Icons.notifications_none_rounded,
              size: 24,
              color: isDark
                  ? AppColor.darkTextPrimary
                  : AppColor.lightTextPrimary,
            ),
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColor.primaryPink,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
