import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';

enum AskTab {
  openAsks,
  myAsks,
}

class AsksBottomNav extends StatelessWidget {
  final AskTab activeTab;
  final ValueChanged<AskTab> onTabChanged;

  const AsksBottomNav({
    super.key,
    required this.activeTab,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDark ? AppColor.darkSurface : AppColor.lightSurface;
    final borderColor = isDark ? AppColor.darkBorder : AppColor.lightBorder;

    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        border: Border(
          top: BorderSide(color: borderColor, width: 0.8),
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
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: _buildNavItem(
                  label: 'Open Asks',
                  icon: Icons.explore_outlined,
                  isSelected: activeTab == AskTab.openAsks,
                  isDark: isDark,
                  onTap: () => onTabChanged(AskTab.openAsks),
                ),
              ),
              const SizedBox(width: 56), // Space for centered FAB
              Expanded(
                child: _buildNavItem(
                  label: 'My Asks',
                  icon: Icons.history_rounded,
                  isSelected: activeTab == AskTab.myAsks,
                  isDark: isDark,
                  onTap: () => onTabChanged(AskTab.myAsks),
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
    required bool isDark,
    required VoidCallback onTap,
  }) {
    final unselectedColor =
        isDark ? AppColor.darkTextTertiary : AppColor.lightTextTertiary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ShaderMask(
              blendMode: BlendMode.srcIn,
              shaderCallback: (bounds) => (isSelected
                      ? AppColor.brandGradient
                      : LinearGradient(
                          colors: [unselectedColor, unselectedColor],
                        ))
                  .createShader(bounds),
              child: Icon(icon, size: 22),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: AppTypography.labelSmall.copyWith(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                color: isSelected ? AppColor.primaryBlue : unselectedColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
