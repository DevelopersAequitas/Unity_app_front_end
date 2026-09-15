import 'package:flutter/material.dart';
import '../../../../../core/theme/app_color.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../domain/entities/circle_category_entity.dart';

class CircleJoinSpecializationCard extends StatelessWidget {
  final CircleCategoryEntity? selectedSubcategory;
  final bool isOtherSelected;
  final VoidCallback onTap;

  const CircleJoinSpecializationCard({
    super.key,
    required this.selectedSubcategory,
    required this.isOtherSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColor.darkSurface : AppColor.lightSurface;
    final borderColor = isDark ? AppColor.darkBorder : AppColor.lightBorder;
    final primaryText = isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary;
    final secondaryText = isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary;
    final hasSelection = selectedSubcategory != null || isOtherSelected;
    final activeBg = isDark
        ? AppColor.primaryBlue.withValues(alpha: 0.20)
        : AppColor.badgeBlueBg;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Specialization / Role',
          style: AppTypography.labelSmall.copyWith(color: secondaryText),
        ),
        const SizedBox(height: 8),
        Material(
          color: hasSelection ? activeBg : cardBg,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: hasSelection ? AppColor.primaryBlue : borderColor,
              width: hasSelection ? 1.5 : 1.0,
            ),
          ),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: hasSelection
                          ? AppColor.primaryBlue
                          : AppColor.primaryBlue.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.category_outlined,
                      size: 20,
                      color: hasSelection ? AppColor.white : AppColor.primaryBlue,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isOtherSelected
                              ? 'Other / Custom Specialization'
                              : (selectedSubcategory?.name ?? 'Tap to select specialization...'),
                          style: AppTypography.bodyMedium.copyWith(
                            fontWeight: hasSelection ? FontWeight.w500 : FontWeight.w400,
                            color: hasSelection ? AppColor.primaryBlue : primaryText,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          hasSelection
                              ? (isOtherSelected
                                  ? 'Custom role specified below'
                                  : 'Selected role for this circle')
                              : 'Choose from available specializations',
                          style: AppTypography.bodySmall.copyWith(
                            color: hasSelection ? AppColor.primaryBlue : secondaryText,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: hasSelection
                          ? AppColor.primaryBlue
                          : AppColor.primaryBlue.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      hasSelection ? 'Change' : 'Select',
                      style: AppTypography.labelSmall.copyWith(
                        color: hasSelection ? AppColor.white : AppColor.primaryBlue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
