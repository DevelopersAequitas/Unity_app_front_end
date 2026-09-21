import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';

class EventSearchFilterBar extends StatelessWidget {
  final String activeFilter;
  final ValueChanged<String> onFilterChanged;

  const EventSearchFilterBar({
    super.key,
    required this.activeFilter,
    required this.onFilterChanged,
  });

  static const _filters = [
    {'id': 'all', 'label': 'All Events'},
    {'id': 'today', 'label': 'Today'},
    {'id': 'upcoming', 'label': 'Upcoming'},
    {'id': 'past', 'label': 'Past'},
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? AppColor.primaryBlue : AppColor.primaryBlue;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: _filters.map((f) {
          final isSelected = activeFilter == f['id'];
          return Padding(
            padding: const EdgeInsets.only(right: 6),
            child: InkWell(
              onTap: () => onFilterChanged(f['id']!),
              borderRadius: BorderRadius.circular(16),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 6),
                decoration: BoxDecoration(
                  color: isSelected
                      ? primary
                      : (isDark ? AppColor.darkSurface : AppColor.lightSurface),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected
                        ? primary
                        : (isDark ? AppColor.darkBorder : AppColor.lightBorder),
                    width: 1.0,
                  ),
                ),
                child: Text(
                  f['label']!,
                  style: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : (isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary),
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    fontSize: 12,
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

