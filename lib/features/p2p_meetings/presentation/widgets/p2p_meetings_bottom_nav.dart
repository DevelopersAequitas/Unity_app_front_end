import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';

class P2pMeetingsBottomNav extends StatelessWidget {
  final int activeTab; // 0: Leaderboard, 1: Completed, 2: Schedule Invites
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColor.darkSurface : AppColor.lightSurface,
        border: Border(
          top: BorderSide(
            color: isDark ? AppColor.darkBorder : AppColor.lightBorder,
            width: 0.8,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 60,
          child: Row(
            children: [
              Expanded(
                child: _buildNavItem(
                  label: 'Leaderboard',
                  icon: Icons.leaderboard_outlined,
                  isSelected: activeTab == 0,
                  onTap: () => onTabChanged(0),
                ),
              ),
              Expanded(
                child: _buildNavItem(
                  label: 'Completed',
                  icon: Icons.check_circle_outline_rounded,
                  isSelected: activeTab == 1,
                  count: completedCount,
                  onTap: () => onTabChanged(1),
                ),
              ),
              Expanded(
                child: _buildNavItem(
                  label: 'Schedule Invites',
                  icon: Icons.calendar_month_outlined,
                  isSelected: activeTab == 2,
                  count: scheduledCount,
                  onTap: () => onTabChanged(2),
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
                              colors: [AppColor.lightTextTertiary, AppColor.lightTextTertiary],
                            ))
                      .createShader(bounds),
                  child: Icon(icon, size: 22),
                ),
                if (count != null && count > 0)
                  Positioned(
                    top: -4,
                    right: -10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColor.primaryBlue : AppColor.lightTextTertiary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      constraints: const BoxConstraints(minWidth: 14, minHeight: 14),
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
                color: isSelected ? AppColor.primaryBlue : AppColor.lightTextTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
