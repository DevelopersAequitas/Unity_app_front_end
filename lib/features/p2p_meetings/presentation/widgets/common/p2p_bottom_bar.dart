import 'package:flutter/material.dart';
import 'package:unity_app/core/theme/app_color.dart';
import 'package:unity_app/core/theme/app_typography.dart';

class P2pBottomBar extends StatelessWidget {
  final int activeTab;
  final int? completedCount;
  final int? scheduledCount;
  final ValueChanged<int> onTabSelected;

  const P2pBottomBar({
    super.key,
    required this.activeTab,
    this.completedCount,
    this.scheduledCount,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColor.darkSurface : AppColor.lightSurface;
    final borderColor = isDark ? AppColor.darkBorder : AppColor.lightBorder;

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        border: Border(top: BorderSide(color: borderColor, width: 1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: _BottomTabItem(
                label: 'Completed Meetings',
                icon: Icons.check_circle_outline_rounded,
                activeIcon: Icons.check_circle_rounded,
                isSelected: activeTab == 0,
                count: completedCount,
                onTap: () => onTabSelected(0),
              ),
            ),
            Expanded(
              child: _BottomTabItem(
                label: 'Schedule Invites',
                icon: Icons.calendar_month_outlined,
                activeIcon: Icons.calendar_month_rounded,
                isSelected: activeTab == 1,
                count: scheduledCount,
                onTap: () => onTabSelected(1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomTabItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final IconData activeIcon;
  final bool isSelected;
  final int? count;
  final VoidCallback onTap;

  const _BottomTabItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
    required this.isSelected,
    this.count,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = isSelected
        ? AppColor.primaryBlue
        : (isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary);

    return InkWell(
      onTap: onTap,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  isSelected ? activeIcon : icon,
                  color: color,
                  size: 22,
                ),
                if (count != null && count! > 0)
                  Positioned(
                    top: -2,
                    right: -8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColor.primaryBlue : AppColor.lightTextDisabled,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      constraints: const BoxConstraints(minWidth: 14, minHeight: 14),
                      child: Text(
                        count! > 99 ? '99+' : count.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: AppTypography.labelSmall.copyWith(
                color: color,
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
