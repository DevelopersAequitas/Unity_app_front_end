import 'package:flutter/material.dart';
import '../../../../../core/theme/app_color.dart';

class CircleCategoriesTabBar extends StatelessWidget {
  final TabController controller;
  final int openCount;
  final int closedCount;

  const CircleCategoriesTabBar({
    super.key,
    required this.controller,
    required this.openCount,
    required this.closedCount,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final secondaryText =
        isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      padding: const EdgeInsets.all(2.5),
      decoration: BoxDecoration(
        color: isDark ? AppColor.darkSurface : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark ? AppColor.darkBorder : const Color(0xFFE5E7EB),
          width: 0.8,
        ),
      ),
      child: TabBar(
        controller: controller,
        indicator: BoxDecoration(
          color: isDark ? AppColor.darkSurfaceSubtle : Colors.white,
          borderRadius: BorderRadius.circular(7),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        labelColor:
            isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary,
        unselectedLabelColor: secondaryText,
        labelStyle: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w500),
        unselectedLabelStyle:
            const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w400),
        dividerColor: Colors.transparent,
        indicatorSize: TabBarIndicatorSize.tab,
        tabs: [
          Tab(height: 30, text: 'Open ($openCount)'),
          Tab(height: 30, text: 'Closed ($closedCount)'),
        ],
      ),
    );
  }
}
