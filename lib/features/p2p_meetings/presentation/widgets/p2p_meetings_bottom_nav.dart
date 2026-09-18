import 'package:flutter/material.dart';
import 'package:unity_app/core/theme/app_color.dart';
import 'package:unity_app/core/theme/app_typography.dart';

class P2pMeetingsBottomNav extends StatelessWidget {
  final int activeTab; // 0: Completed, 1: Scheduled
  final int? completedCount;
  final int? scheduledCount;
  final ValueChanged<int> onTabChanged;

  const P2pMeetingsBottomNav({
    super.key,
    required this.activeTab,
    this.completedCount,
    this.scheduledCount,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.lightSurface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, -3),
          ),
        ],
        border: Border(
          top: BorderSide(color: AppColor.lightBorder, width: 0.8),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: _buildNavItem(
                  label: 'Completed',
                  icon: Icons.check_circle_outline_rounded,
                  isSelected: activeTab == 0,
                  count: completedCount,
                  onTap: () => onTabChanged(0),
                ),
              ),
              const SizedBox(width: 56), // Space for centered FAB
              Expanded(
                child: _buildNavItem(
                  label: 'Schedule Invites',
                  icon: Icons.calendar_month_outlined,
                  isSelected: activeTab == 1,
                  count: scheduledCount,
                  onTap: () => onTabChanged(1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required String label,
    required IconData icon,
    required bool isSelected,
    int? count,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                ShaderMask(
                  blendMode: BlendMode.srcIn,
                  shaderCallback: (bounds) => (isSelected
                          ? AppColor.brandGradient
                          : LinearGradient(
                              colors: [
                                AppColor.lightTextTertiary,
                                AppColor.lightTextTertiary,
                              ],
                            ))
                      .createShader(bounds),
                  child: Icon(icon, size: 22),
                ),
                if (count != null && count > 0)
                  Positioned(
                    top: -4,
                    right: -10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColor.primaryBlue
                            : AppColor.lightTextTertiary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 14,
                        minHeight: 14,
                      ),
                      child: Text(
                        count > 99 ? '99+' : count.toString(),
                        style: const TextStyle(
                          color: AppColor.white,
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
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                color: isSelected
                    ? AppColor.primaryBlue
                    : AppColor.lightTextTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
