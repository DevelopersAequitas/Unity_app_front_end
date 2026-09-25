import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';

class TopBuildersBottomNav extends StatelessWidget {
  final int activeIndex;
  final ValueChanged<int> onIndexChanged;

  const TopBuildersBottomNav({
    super.key,
    required this.activeIndex,
    required this.onIndexChanged,
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
                  icon: Icons.emoji_events_outlined,
                  isSelected: activeIndex == 0,
                  onTap: () => onIndexChanged(0),
                ),
              ),
              Expanded(
                child: _buildNavItem(
                  label: 'My Invites',
                  icon: Icons.people_outline_rounded,
                  isSelected: activeIndex == 1,
                  onTap: () => onIndexChanged(1),
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
            const SizedBox(height: 3),
            isSelected
                ? ShaderMask(
                    blendMode: BlendMode.srcIn,
                    shaderCallback: (bounds) =>
                        AppColor.brandGradient.createShader(bounds),
                    child: Text(
                      label,
                      style: AppTypography.labelSmall.copyWith(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  )
                : Text(
                    label,
                    style: AppTypography.labelSmall.copyWith(
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: AppColor.lightTextTertiary,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
