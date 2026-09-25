import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../bloc/testimonials_event.dart';

class TestimonialsBottomNav extends StatelessWidget {
  final TestimonialTab activeTab;
  final ValueChanged<TestimonialTab> onTabChanged;

  const TestimonialsBottomNav({
    super.key,
    required this.activeTab,
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
                  isSelected: activeTab == TestimonialTab.leaderboard,
                  onTap: () => onTabChanged(TestimonialTab.leaderboard),
                ),
              ),
              Expanded(
                child: _buildNavItem(
                  label: 'Received',
                  icon: Icons.format_quote_outlined,
                  isSelected: activeTab == TestimonialTab.received,
                  onTap: () => onTabChanged(TestimonialTab.received),
                ),
              ),
              Expanded(
                child: _buildNavItem(
                  label: 'Given',
                  icon: Icons.send_outlined,
                  isSelected: activeTab == TestimonialTab.given,
                  onTap: () => onTabChanged(TestimonialTab.given),
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
