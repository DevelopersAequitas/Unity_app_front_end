import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../bloc/business_deals_event.dart';

class BusinessDealsBottomNav extends StatelessWidget {
  final BusinessDealTab activeTab;
  final ValueChanged<BusinessDealTab> onTabChanged;

  const BusinessDealsBottomNav({
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
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: _buildNavItem(
                  label: 'Leaderboard',
                  icon: Icons.leaderboard_outlined,
                  isSelected: activeTab == BusinessDealTab.leaderboard,
                  onTap: () => onTabChanged(BusinessDealTab.leaderboard),
                ),
              ),
              Expanded(
                child: _buildNavItem(
                  label: 'Received',
                  icon: Icons.call_received_rounded,
                  isSelected: activeTab == BusinessDealTab.received,
                  onTap: () => onTabChanged(BusinessDealTab.received),
                ),
              ),
              Expanded(
                child: _buildNavItem(
                  label: 'Given',
                  icon: Icons.call_made_rounded,
                  isSelected: activeTab == BusinessDealTab.given,
                  onTap: () => onTabChanged(BusinessDealTab.given),
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
