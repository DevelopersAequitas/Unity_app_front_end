import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';

class CirclesBottomBar extends StatelessWidget {
  final int activeTab;
  final int myCirclesCount;
  final int myRequestsCount;
  final ValueChanged<int> onTabSelected;

  const CirclesBottomBar({
    super.key,
    required this.activeTab,
    required this.myCirclesCount,
    required this.myRequestsCount,
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
                label: 'My Circles',
                icon: Icons.bubble_chart_outlined,
                activeIcon: Icons.bubble_chart_rounded,
                isSelected: activeTab == 0,
                count: myCirclesCount,
                onTap: () => onTabSelected(0),
              ),
            ),
            Expanded(
              child: _BottomTabItem(
                label: 'Join a Circle',
                icon: Icons.explore_outlined,
                activeIcon: Icons.explore_rounded,
                isSelected: activeTab == 1,
                onTap: () => onTabSelected(1),
              ),
            ),
            Expanded(
              child: _BottomTabItem(
                label: 'My Requests',
                icon: Icons.pending_actions_outlined,
                activeIcon: Icons.pending_actions_rounded,
                isSelected: activeTab == 2,
                count: myRequestsCount,
                onTap: () => onTabSelected(2),
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
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                AnimatedScale(
                  scale: isSelected ? 1.12 : 1.0,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOutBack,
                  child: isSelected
                      ? ShaderMask(
                          shaderCallback: (bounds) =>
                              AppColor.brandGradient.createShader(bounds),
                          blendMode: BlendMode.srcIn,
                          child: Icon(
                            activeIcon,
                            size: 22,
                            color: Colors.white,
                          ),
                        )
                      : Icon(
                          icon,
                          size: 22,
                          color: color,
                        ),
                ),
                if (count != null && count! > 0)
                  Positioned(
                    top: -4,
                    right: -10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColor.primaryPink
                            : (isDark ? AppColor.darkBorder : AppColor.lightBorder),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '$count',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? Colors.white
                              : (isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 3),
            isSelected
                ? ShaderMask(
                    shaderCallback: (bounds) =>
                        AppColor.brandGradient.createShader(bounds),
                    blendMode: BlendMode.srcIn,
                    child: Text(
                      label,
                      style: AppTypography.labelSmall.copyWith(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                : Text(
                    label,
                    style: AppTypography.labelSmall.copyWith(
                      color: color,
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
