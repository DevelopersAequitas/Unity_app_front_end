import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';

class NotificationEmptyView extends StatelessWidget {
  final VoidCallback onRefresh;

  const NotificationEmptyView({
    super.key,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleColor = isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary;
    final subColor = isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: isDark ? AppColor.darkSurfaceSubtle : AppColor.badgePinkBg,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.notifications_none_rounded,
                size: 28,
                color: AppColor.primaryPink,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'No notifications yet',
              style: AppTypography.titleMedium.copyWith(
                fontWeight: FontWeight.w500,
                color: titleColor,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Your network activity will appear here.',
              style: AppTypography.bodySmall.copyWith(
                color: subColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: onRefresh,
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                side: BorderSide(color: isDark ? AppColor.darkBorder : AppColor.lightBorder),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: Text(
                'Refresh',
                style: AppTypography.labelSmall.copyWith(
                  color: AppColor.primaryBlue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
