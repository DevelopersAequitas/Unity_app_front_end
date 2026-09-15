import 'package:flutter/material.dart';
import 'package:unity_app/core/theme/app_color.dart';
import 'package:unity_app/features/circles/domain/entities/circle_closed_category_entity.dart';
import 'package:unity_app/features/circles/domain/entities/circle_entity.dart';
import 'package:unity_app/features/circles/domain/entities/flat_open_category_item.dart';
import 'circle_open_category_card.dart';

class CircleOpenCategoriesTab extends StatelessWidget {
  final List<FlatOpenCategoryItem> openFiltered;
  final List<CircleClosedCategoryEntity> closedFiltered;
  final CircleEntity circle;
  final String query;
  final VoidCallback onRefresh;
  final VoidCallback onSwitchToClosed;

  const CircleOpenCategoriesTab({
    super.key,
    required this.openFiltered,
    required this.closedFiltered,
    required this.circle,
    required this.query,
    required this.onRefresh,
    required this.onSwitchToClosed,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final secondaryText =
        isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary;

    if (openFiltered.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.search_off_rounded,
                size: 32,
                color: secondaryText.withValues(alpha: 0.6),
              ),
              const SizedBox(height: 8),
              Text(
                query.isEmpty
                    ? 'No open categories available in this circle'
                    : 'No open categories match "$query"',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: secondaryText,
                ),
                textAlign: TextAlign.center,
              ),
              if (query.isNotEmpty && closedFiltered.isNotEmpty) ...[
                const SizedBox(height: 12),
                InkWell(
                  onTap: onSwitchToClosed,
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFFD97706).withValues(alpha: 0.15)
                          : const Color(0xFFFFFBEB),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isDark
                            ? const Color(0xFFD97706).withValues(alpha: 0.3)
                            : const Color(0xFFFDE68A),
                        width: 0.8,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Found ${closedFiltered.length} matching in Closed',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFFD97706),
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.arrow_forward_rounded,
                          size: 12,
                          color: Color(0xFFD97706),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      color: AppColor.primaryBlue,
      onRefresh: () async => onRefresh(),
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 2, bottom: 16),
        itemCount: openFiltered.length,
        itemBuilder: (context, index) {
          final item = openFiltered[index];
          return CircleOpenCategoryCard(
            item: item,
            circle: circle,
          );
        },
      ),
    );
  }
}

