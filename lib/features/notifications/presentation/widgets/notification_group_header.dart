import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';

class NotificationGroupHeader extends StatelessWidget {
  final String title;
  final String dateSubtitle;

  const NotificationGroupHeader({
    super.key,
    required this.title,
    this.dateSubtitle = '',
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleColor = isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary;
    final subColor = isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Text(
            title,
            style: AppTypography.titleSmall.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: titleColor,
            ),
          ),
          if (dateSubtitle.isNotEmpty)
            Text(
              dateSubtitle,
              style: AppTypography.bodySmall.copyWith(
                fontSize: 11,
                color: subColor,
              ),
            ),
        ],
      ),
    );
  }
}
