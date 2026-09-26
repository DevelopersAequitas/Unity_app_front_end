import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';

class FeedFilterPills extends StatelessWidget {
  final List<Map<String, String>> filters;
  final String selectedValue;
  final ValueChanged<String> onSelected;

  const FeedFilterPills({
    super.key,
    required this.filters,
    required this.selectedValue,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      child: Row(
        children: filters.map((filter) {
          final isSelected = filter['value'] == selectedValue;
          return Padding(
            padding: const EdgeInsets.only(right: 6),
            child: InkWell(
              onTap: () => onSelected(filter['value']!),
              borderRadius: BorderRadius.circular(16),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  gradient: isSelected ? AppColor.brandGradient : null,
                  color: isSelected
                      ? null
                      : (isDark ? AppColor.darkSurface : AppColor.lightSurface),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected
                        ? Colors.transparent
                        : (isDark ? AppColor.darkBorder : AppColor.lightBorder),
                    width: 0.9,
                  ),
                ),
                child: Text(
                  filter['label']!,
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected
                        ? Colors.white
                        : (isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary),
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
