import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';

class EntrepreneurCertificationBottomNav extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;
  final bool hasCertificate;
  final bool isUnderReview;

  const EntrepreneurCertificationBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
    this.hasCertificate = false,
    this.isUnderReview = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryLabel = hasCertificate
        ? 'Certificate'
        : isUnderReview
        ? 'Status'
        : 'Assessment';

    final primaryIcon = hasCertificate
        ? Icons.workspace_premium_outlined
        : isUnderReview
        ? Icons.hourglass_top_rounded
        : Icons.quiz_outlined;

    final primaryActiveIcon = hasCertificate
        ? Icons.workspace_premium_rounded
        : isUnderReview
        ? Icons.hourglass_full_rounded
        : Icons.quiz_rounded;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColor.darkSurface : AppColor.lightSurface,
        border: Border(
          top: BorderSide(
            color: isDark ? AppColor.darkBorder : AppColor.lightBorder,
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            children: [
              Expanded(
                child: _buildNavItem(
                  context,
                  index: 0,
                  icon: primaryIcon,
                  activeIcon: primaryActiveIcon,
                  label: primaryLabel,
                ),
              ),
              Expanded(
                child: _buildNavItem(
                  context,
                  index: 1,
                  icon: Icons.history_rounded,
                  activeIcon: Icons.history_rounded,
                  label: 'Submissions',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
  }) {
    final isSelected = selectedIndex == index;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeColor = AppColor.primaryBlue;
    final inactiveColor =
        isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary;

    return InkWell(
      onTap: () => onTabSelected(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isSelected ? activeIcon : icon,
            color: isSelected ? activeColor : inactiveColor,
            size: 22,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTypography.labelSmall.copyWith(
              color: isSelected ? activeColor : inactiveColor,
              fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
