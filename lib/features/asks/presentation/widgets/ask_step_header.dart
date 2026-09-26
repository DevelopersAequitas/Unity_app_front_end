import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';

class AskStepHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool showTitle;

  const AskStepHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.showTitle = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleColor =
        isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary;
    final subtitleColor =
        isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showTitle && title.isNotEmpty) ...[
            Text(
              title,
              style: AppTypography.titleLarge.copyWith(
                fontSize: 19,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.3,
                color: titleColor,
              ),
            ),
            const SizedBox(height: 2),
          ],
          if (subtitle.isNotEmpty)
            Text(
              subtitle,
              style: AppTypography.bodySmall.copyWith(
                fontSize: 13,
                color: subtitleColor,
                height: 1.3,
              ),
            ),
        ],
      ),
    );
  }
}
