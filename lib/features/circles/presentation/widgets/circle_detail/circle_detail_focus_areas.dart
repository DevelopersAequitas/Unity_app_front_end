import 'package:flutter/material.dart';
import '../../../../../core/theme/app_color.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../domain/entities/circle_entity.dart';
import '../circle_icon_helper.dart';

class CircleDetailFocusAreas extends StatelessWidget {
  final CircleEntity circle;

  const CircleDetailFocusAreas({super.key, required this.circle});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final config = CircleIconHelper.getCategoryConfig(circle.category, circle.circleKey);
    final cardBg = isDark ? AppColor.darkSurface : Colors.white;
    final borderColor = isDark
        ? AppColor.darkBorder
        : config.tintColor.withValues(alpha: 0.18);

    final tags = circle.focusAreas.isNotEmpty
        ? circle.focusAreas
        : const [
            'Healthcare',
            'Wellness',
            'Life Sciences',
            'Hospitals',
            'Clinics',
            'Medical Technology',
          ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    gradient: AppColor.brandGradient,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Icon(Icons.hub_outlined, size: 16, color: Colors.white),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Focus Areas & Industry Tags',
                  style: AppTypography.titleSmall.copyWith(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w500,
                    color: isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: tags.map((tag) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        config.bgTint,
                        isDark ? AppColor.darkSurfaceSubtle : const Color(0xFFEFF6FF),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isDark
                          ? AppColor.darkBorder
                          : config.tintColor.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    tag,
                    style: AppTypography.labelSmall.copyWith(
                      fontSize: 11,
                      color: isDark ? AppColor.darkTextSecondary : config.tintColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

