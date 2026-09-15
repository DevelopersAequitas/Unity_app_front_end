import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/circle_category_entity.dart';
import '../../domain/entities/circle_join_request_entity.dart';
import 'category_tile.dart';

class CategoryGridSection extends StatefulWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final List<CircleCategoryEntity> categories;
  final CircleJoinRequestEntity? Function(CircleCategoryEntity category)?
  joinRequestResolver;
  final ValueChanged<CircleCategoryEntity> onCategoryTap;
  final VoidCallback? onViewAllTap;

  const CategoryGridSection({
    super.key,
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.categories,
    this.joinRequestResolver,
    required this.onCategoryTap,
    this.onViewAllTap,
  });

  @override
  State<CategoryGridSection> createState() => _CategoryGridSectionState();
}

class _CategoryGridSectionState extends State<CategoryGridSection> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isTablet = MediaQuery.of(context).size.width >= 600;
    final crossAxisCount = isTablet ? 6 : 3;
    final cardAspectRatio = isTablet ? 0.95 : 0.82;

    final initialCount = isTablet ? 18 : 9;
    final hasMore = widget.categories.length > initialCount;
    final displayCategories = (_isExpanded || !hasMore)
        ? widget.categories
        : widget.categories.take(initialCount).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: widget.iconColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Icon(widget.icon, size: 16, color: widget.iconColor),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  widget.title,
                  style: AppTypography.titleSmall.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isDark
                        ? AppColor.darkTextPrimary
                        : AppColor.lightTextPrimary,
                  ),
                ),
              ),
              if (hasMore || widget.onViewAllTap != null)
                TextButton(
                  onPressed: () {
                    if (widget.onViewAllTap != null) {
                      widget.onViewAllTap!();
                    } else {
                      setState(() => _isExpanded = !_isExpanded);
                    }
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    minimumSize: const Size(40, 30),
                  ),
                  child: Text(
                    _isExpanded ? 'View Less' : 'View All',
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
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: 12,
              crossAxisSpacing: 8,
              childAspectRatio: cardAspectRatio,
            ),
            itemCount: displayCategories.length,
            itemBuilder: (context, index) {
              final cat = displayCategories[index];
              return CategoryTile(
                category: cat,
                joinRequest: widget.joinRequestResolver?.call(cat),
                onTap: () => widget.onCategoryTap(cat),
              );
            },
          ),
        ],
      ),
    );
  }
}
