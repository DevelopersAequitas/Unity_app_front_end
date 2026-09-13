import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/circle_category_entity.dart';
import 'category_tile.dart';

class CategoryGridSection extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final List<CircleCategoryEntity> categories;
  final ValueChanged<CircleCategoryEntity> onCategoryTap;
  final VoidCallback? onViewAllTap;

  const CategoryGridSection({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.categories,
    required this.onCategoryTap,
    this.onViewAllTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Icon(icon, size: 18, color: iconColor),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTypography.titleSmall.copyWith(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w500,
                        color: isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: AppTypography.labelSmall.copyWith(
                        fontSize: 10.5,
                        color: isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              if (onViewAllTap != null)
                TextButton(
                  onPressed: onViewAllTap,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    minimumSize: const Size(40, 30),
                  ),
                  child: Text(
                    'View All',
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColor.primaryBlue,
                      fontWeight: FontWeight.w500,
                      fontSize: 11,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 0.85,
            ),
            itemCount: categories.length > 9 ? 9 : categories.length,
            itemBuilder: (context, index) {
              final cat = categories[index];
              return CategoryTile(
                category: cat,
                onTap: () => onCategoryTap(cat),
              );
            },
          ),
        ],
      ),
    );
  }
}
