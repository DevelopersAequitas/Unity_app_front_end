import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/app_date_formatter.dart';

class ChatDateHeader extends StatelessWidget {
  final DateTime date;

  const ChatDateHeader({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 12),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: isDark
              ? AppColor.darkSurfaceSubtle
              : AppColor.lightSurfaceSubtle,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? AppColor.darkBorder : AppColor.lightBorder,
          ),
        ),
        child: Text(
          AppDateFormatter.formatChatDateHeader(date),
          style: AppTypography.bodySmall.copyWith(
            fontSize: 11,
            color: isDark
                ? AppColor.darkTextSecondary
                : AppColor.lightTextSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
