import 'package:flutter/material.dart';
import '../../../../../core/theme/app_color.dart';
import '../../../../../core/theme/app_typography.dart';

class CircleSubcategoryOtherTile extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onTap;

  const CircleSubcategoryOtherTile({
    super.key,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColor.darkSurface : AppColor.lightSurface;
    final borderColor = isDark ? AppColor.darkBorder : AppColor.lightBorder;
    final primaryText = isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary;
    final secondaryText = isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary;
    final activeBg = isDark
        ? AppColor.primaryBlue.withValues(alpha: 0.20)
        : AppColor.badgeBlueBg;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 4),
      child: Material(
        color: isSelected ? activeBg : cardBg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isSelected ? AppColor.primaryBlue : borderColor,
            width: isSelected ? 1.5 : 1.0,
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
                    color: isSelected
                        ? AppColor.primaryBlue
                        : AppColor.primaryBlue.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.add_rounded,
                    size: 20,
                    color: isSelected ? AppColor.white : AppColor.primaryBlue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Other Specialization / Role',
                        style: AppTypography.bodyMedium.copyWith(
                          fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                          color: isSelected ? AppColor.primaryBlue : primaryText,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isSelected
                            ? 'Custom role specified in next step'
                            : 'Specify custom role in next step',
                        style: AppTypography.bodySmall.copyWith(
                          color: isSelected ? AppColor.primaryBlue : secondaryText,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isSelected)
                  Container(
                    width: 20,
                    height: 20,
                    decoration: const BoxDecoration(
                      color: AppColor.primaryBlue,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      size: 14,
                      color: AppColor.white,
                    ),
                  )
                else
                  const Icon(
                    Icons.radio_button_unchecked_rounded,
                    size: 20,
                    color: AppColor.lightTextDisabled,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
