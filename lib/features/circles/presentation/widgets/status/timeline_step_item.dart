import 'package:flutter/material.dart';
import '../../../../../core/theme/app_color.dart';
import '../../../../../core/theme/app_typography.dart';

class TimelineStepItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String status;
  final IconData icon;
  final bool isLast;

  const TimelineStepItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.status,
    required this.icon,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isDone = status == 'completed';
    final isProgress = status == 'in_progress';
    final isRejected = status == 'rejected';

    final color = isDone
        ? AppColor.success
        : isRejected
            ? AppColor.error
            : isProgress
                ? AppColor.primaryBlue
                : (isDark ? AppColor.darkTextDisabled : AppColor.lightTextDisabled);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
                border: Border.all(color: color, width: 1.2),
              ),
              child: Icon(icon, size: 13, color: color),
            ),
            if (!isLast)
              Container(
                width: 1.5,
                height: 18,
                color: color.withValues(alpha: 0.25),
              ),
          ],
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTypography.bodySmall.copyWith(
                  fontWeight: FontWeight.w500,
                  color: isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary,
                ),
              ),
              const SizedBox(height: 1),
              Text(
                subtitle,
                style: AppTypography.bodySmall.copyWith(
                  color: isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary,
                  fontSize: 11,
                ),
              ),
              if (!isLast) const SizedBox(height: 8),
            ],
          ),
        ),
      ],
    );
  }
}
