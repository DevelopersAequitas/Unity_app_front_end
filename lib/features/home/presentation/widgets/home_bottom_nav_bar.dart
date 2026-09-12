import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';

class HomeBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int>? onItemSelected;
  final VoidCallback? onCreateTap;

  const HomeBottomNavBar({
    super.key,
    this.selectedIndex = 0,
    this.onItemSelected,
    this.onCreateTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColor.darkSurface : AppColor.lightSurface;
    final borderColor = isDark ? AppColor.darkBorder : AppColor.lightBorder;
    final activeColor = AppColor.primaryBlue;
    final inactiveColor = isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary;

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        border: Border(top: BorderSide(color: borderColor, width: 1)),
      ),
      padding: const EdgeInsets.only(top: 6, bottom: 6),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _NavItem(
              icon: Icons.home_rounded,
              label: 'Home',
              isSelected: selectedIndex == 0,
              activeColor: activeColor,
              inactiveColor: inactiveColor,
              onTap: () => onItemSelected?.call(0),
            ),
            _NavItem(
              icon: Icons.people_outline_rounded,
              label: 'Peers',
              isSelected: selectedIndex == 1,
              activeColor: activeColor,
              inactiveColor: inactiveColor,
              onTap: () => onItemSelected?.call(1),
            ),
            _CenterPlusButton(onTap: onCreateTap),
            _NavItem(
              icon: Icons.bubble_chart_outlined,
              label: 'Circles',
              isSelected: selectedIndex == 3,
              activeColor: activeColor,
              inactiveColor: inactiveColor,
              onTap: () => onItemSelected?.call(3),
            ),
            _NavItem(
              icon: Icons.auto_awesome_outlined,
              label: 'Highlights',
              isSelected: selectedIndex == 4,
              activeColor: activeColor,
              inactiveColor: inactiveColor,
              onTap: () => onItemSelected?.call(4),
            ),
          ],
        ),
      ),
    );
  }
}

class _CenterPlusButton extends StatelessWidget {
  final VoidCallback? onTap;

  const _CenterPlusButton({this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: AppColor.brandGradient,
        ),
        child: const Center(
          child: Icon(Icons.add_rounded, color: AppColor.white, size: 24),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final Color activeColor;
  final Color inactiveColor;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.activeColor,
    required this.inactiveColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? activeColor : inactiveColor;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: 60,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 22, color: color),
            const SizedBox(height: 2),
            Text(
              label,
              style: AppTypography.labelSmall.copyWith(
                color: color,
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
