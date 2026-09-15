import 'package:flutter/material.dart';
import '../../../../../core/router/app_router.dart';
import '../../../../../core/theme/app_color.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../domain/entities/circle_entity.dart';
import '../../../domain/entities/flat_open_category_item.dart';

class CircleOpenCategoryCard extends StatelessWidget {
  final FlatOpenCategoryItem item;
  final CircleEntity circle;

  const CircleOpenCategoryCard({
    super.key,
    required this.item,
    required this.circle,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColor.darkSurface : Colors.white;
    final borderColor =
        isDark ? AppColor.darkBorder : const Color(0xFFE5E7EB);
    final secondaryText =
        isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary;

    final breadcrumb = [
      item.sectorName,
      if (item.subcategoryName != null && item.subcategoryName!.isNotEmpty)
        item.subcategoryName!,
    ].join(' • ');

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 2.5),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor, width: 0.8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.02),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(
              context,
              AppRoutes.circleJoin,
              arguments: {
                'circle': circle,
                'defaultCategoryName': item.name,
                'defaultSectorId': item.id,
              },
            );
          },
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        item.name,
                        style: AppTypography.titleSmall.copyWith(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w500,
                          color: isDark
                              ? AppColor.darkTextPrimary
                              : AppColor.lightTextPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (breadcrumb.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          breadcrumb,
                          style: TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w400,
                            color: secondaryText,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 3.5),
                  decoration: BoxDecoration(
                    gradient: AppColor.brandGradient,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Refer',
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 3),
                      Icon(
                        Icons.arrow_forward_rounded,
                        size: 11,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
