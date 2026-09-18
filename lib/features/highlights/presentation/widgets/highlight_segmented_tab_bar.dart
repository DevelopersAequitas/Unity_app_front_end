import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';

class HighlightSegmentedTabBar extends StatelessWidget {
  final TabController controller;
  final List<String> tabTitles;

  const HighlightSegmentedTabBar({
    super.key,
    required this.controller,
    required this.tabTitles,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: isDark ? AppColor.darkSurface : AppColor.lightSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? AppColor.darkBorder : AppColor.lightBorder),
      ),
      child: TabBar(
        controller: controller,
        indicator: BoxDecoration(
          color: AppColor.primaryBlue,
          borderRadius: BorderRadius.circular(9),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: Colors.white,
        unselectedLabelColor: isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary,
        labelStyle: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w500),
        dividerColor: Colors.transparent,
        tabs: tabTitles.map((t) => Tab(text: t)).toList(),
      ),
    );
  }
}
