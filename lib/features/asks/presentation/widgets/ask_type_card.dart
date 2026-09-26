import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/ask_type_entity.dart';

class AskTypeCard extends StatelessWidget {
  final AskTypeEntity type;
  final int index;
  final bool isSelected;
  final VoidCallback onTap;

  const AskTypeCard({
    super.key,
    required this.type,
    required this.index,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgCard = isSelected
        ? (isDark
            ? AppColor.primaryBlue.withValues(alpha: 0.18)
            : const Color(0xFFEFF6FF))
        : (isDark ? AppColor.darkSurface : AppColor.lightSurface);
    final borderColor = isSelected
        ? AppColor.primaryBlue
        : (isDark ? AppColor.darkBorder : AppColor.lightBorder);
    final titleColor = isSelected
        ? (isDark ? Colors.white : AppColor.primaryBlue)
        : (isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary);

    return Material(
      color: bgCard,
      borderRadius: BorderRadius.circular(10),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        splashColor: AppColor.primaryBlue.withValues(alpha: 0.12),
        highlightColor: AppColor.primaryBlue.withValues(alpha: 0.06),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: borderColor,
              width: isSelected ? 1.5 : 0.8,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  gradient: isSelected ? AppColor.brandGradient : null,
                  color: isSelected
                      ? null
                      : (isDark
                          ? AppColor.darkSurfaceSubtle
                          : AppColor.badgeBlueBg),
                  borderRadius: BorderRadius.circular(6),
                ),
                alignment: Alignment.center,
                child: Text(
                  '${index + 1}',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: isSelected
                        ? Colors.white
                        : (isDark
                            ? AppColor.darkTextPrimary
                            : AppColor.primaryBlue),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  type.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.bodySmall.copyWith(
                    fontSize: 12.5,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                    height: 1.2,
                    color: titleColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
