import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';

class LifeImpactFilterBar extends StatelessWidget {
  final String selectedFilter;
  final ValueChanged<String> onFilterChanged;

  const LifeImpactFilterBar({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  static const List<({String key, String label})> _filters = [
    (key: 'all', label: 'All Activities'),
    (key: 'p2p_meeting', label: 'P2P Meetings'),
    (key: 'business_deal', label: 'Business Deals'),
    (key: 'referral', label: 'Referrals'),
    (key: 'testimonial', label: 'Testimonials'),
    (key: 'adjustment', label: 'Adjustments'),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _filters.map((filter) {
          final isSelected = selectedFilter == filter.key;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: InkWell(
              onTap: () => onFilterChanged(filter.key),
              borderRadius: BorderRadius.circular(999),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColor.primaryBlue
                      : (isDark ? AppColor.darkSurface : AppColor.lightSurface),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: isSelected
                        ? Colors.transparent
                        : (isDark ? AppColor.darkBorder : AppColor.lightBorder),
                    width: 0.5,
                  ),
                ),
                child: Text(
                  filter.label,
                  style: AppTypography.labelSmall.copyWith(
                    color: isSelected
                        ? Colors.white
                        : (isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
