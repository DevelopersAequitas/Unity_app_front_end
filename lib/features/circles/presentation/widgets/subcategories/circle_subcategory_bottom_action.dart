import 'package:flutter/material.dart';
import '../../../../../core/theme/app_color.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../domain/entities/circle_category_entity.dart';

class CircleSubcategoryBottomAction extends StatelessWidget {
  final CircleCategoryEntity? selectedSubcategory;
  final bool isOtherSelected;
  final VoidCallback onProceed;

  const CircleSubcategoryBottomAction({
    super.key,
    required this.selectedSubcategory,
    required this.isOtherSelected,
    required this.onProceed,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColor.darkSurface : AppColor.lightSurface;
    final borderColor = isDark ? AppColor.darkBorder : AppColor.lightBorder;
    final hasSelection = selectedSubcategory != null || isOtherSelected;

    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: cardBg,
          border: Border(top: BorderSide(color: borderColor, width: 1)),
        ),
        child: SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: hasSelection ? onProceed : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.primaryBlue,
              foregroundColor: AppColor.white,
              disabledBackgroundColor:
                  AppColor.primaryBlue.withValues(alpha: 0.35),
              disabledForegroundColor:
                  AppColor.white.withValues(alpha: 0.6),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            child: Text(
              selectedSubcategory != null
                  ? 'Continue with "${selectedSubcategory!.name}"'
                  : (isOtherSelected
                      ? 'Continue with Custom Role'
                      : 'Select a Specialization to Continue'),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.bodyMedium.copyWith(
                fontWeight: FontWeight.w500,
                color: AppColor.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
