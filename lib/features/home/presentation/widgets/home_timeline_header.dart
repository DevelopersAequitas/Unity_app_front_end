import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';

class HomeTimelineHeader extends StatelessWidget {
  final String activeFilter;
  final VoidCallback? onFilterTap;

  const HomeTimelineHeader({
    super.key,
    this.activeFilter = 'All',
    this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor = isDark
        ? AppColor.darkTextPrimary
        : AppColor.lightTextPrimary;
    // final filterBorderColor = isDark
    //     ? AppColor.darkBorder
    //     : AppColor.lightBorder;
    // final filterBgColor = isDark ? AppColor.darkSurface : AppColor.lightSurface;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Timeline',
            style: AppTypography.titleMedium.copyWith(
              color: primaryTextColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          // InkWell(
          //   onTap: onFilterTap,
          //   borderRadius: BorderRadius.circular(20),
          //   child: Container(
          //     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          //     decoration: BoxDecoration(
          //       color: filterBgColor,
          //       borderRadius: BorderRadius.circular(20),
          //       border: Border.all(color: filterBorderColor, width: 1),
          //     ),
          //     child: Row(
          //       mainAxisSize: MainAxisSize.min,
          //       children: [
          //         Icon(
          //           Icons.tune_rounded,
          //           size: 14,
          //           color: isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary,
          //         ),
          //         const SizedBox(width: 6),
          //         Text(
          //           activeFilter,
          //           style: AppTypography.bodySmall.copyWith(
          //             color: primaryTextColor,
          //             fontWeight: FontWeight.w500,
          //             fontSize: 12,
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
