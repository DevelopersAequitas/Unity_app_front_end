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
                  label: 'Received',
                  icon: Icons.format_quote_outlined,
                  isSelected: activeTab == TestimonialTab.received,
                  onTap: () => onTabChanged(TestimonialTab.received),
                ),
              ),
              const SizedBox(width: 56), // Space for centered FAB
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
