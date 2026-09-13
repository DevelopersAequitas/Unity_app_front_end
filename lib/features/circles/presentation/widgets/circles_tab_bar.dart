import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';

class CirclesTabBar extends StatelessWidget {
  final int activeTab;
  final int myCirclesCount;
  final ValueChanged<int> onTabSelected;

  const CirclesTabBar({
    super.key,
    required this.activeTab,
    required this.myCirclesCount,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColor.darkSurfaceSubtle : AppColor.lightSurfaceMuted;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 40,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Expanded(
              child: _TabButton(
                title: 'My Circles',
                count: myCirclesCount,
                isSelected: activeTab == 0,
                onTap: () => onTabSelected(0),
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: _TabButton(
                title: 'Join a Circle',
                isSelected: activeTab == 1,
                onTap: () => onTabSelected(1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String title;
  final int? count;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabButton({
    required this.title,
    this.count,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isSelected
        ? Colors.white
        : (isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          gradient: isSelected ? AppColor.brandGradient : null,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: AppTypography.bodySmall.copyWith(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
              ),
              if (count != null && count! > 0) ...[
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.white.withValues(alpha: 0.25)
                        : (isDark ? AppColor.darkBorder : AppColor.lightBorder),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '$count',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: isSelected ? Colors.white : AppColor.primaryPink,
                      height: 1.1,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
