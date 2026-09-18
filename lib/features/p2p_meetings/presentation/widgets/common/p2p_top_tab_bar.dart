import 'package:flutter/material.dart';
import 'package:unity_app/core/theme/app_color.dart';
import 'package:unity_app/core/theme/app_typography.dart';

class P2pTopTabBar extends StatelessWidget {
  final int selectedIndex; // 0: completed, 1: scheduled
  final ValueChanged<int> onTabSelected;

  const P2pTopTabBar({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColor.lightSurfaceSubtle,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColor.lightBorder),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildTabItem(
              title: 'Completed Meetings',
              icon: Icons.check_circle_outline_rounded,
              isSelected: selectedIndex == 0,
              onTap: () => onTabSelected(0),
            ),
          ),
          Expanded(
            child: _buildTabItem(
              title: 'Scheduled Invites',
              icon: Icons.calendar_month_outlined,
              isSelected: selectedIndex == 1,
              onTap: () => onTabSelected(1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabItem({
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Material(
      color: isSelected ? AppColor.lightSurface : Colors.transparent,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: isSelected
                    ? AppColor.primaryBlue
                    : AppColor.lightTextDisabled,
              ),
              const SizedBox(width: 6),
              Text(
                title,
                style: AppTypography.bodySmall.copyWith(
                  fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                  fontSize: 12.5,
                  color: isSelected
                      ? AppColor.primaryBlue
                      : AppColor.lightTextSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
