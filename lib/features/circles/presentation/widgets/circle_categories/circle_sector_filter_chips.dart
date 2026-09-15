import 'package:flutter/material.dart';
import '../../../../../core/theme/app_color.dart';

class CircleSectorFilterChips extends StatelessWidget {
  final Set<String> sectors;
  final String selectedSector;
  final ValueChanged<String> onSectorSelected;

  const CircleSectorFilterChips({
    super.key,
    required this.sectors,
    required this.selectedSector,
    required this.onSectorSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 32,
      margin: const EdgeInsets.only(bottom: 4),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        physics: const BouncingScrollPhysics(),
        children: sectors.map((sec) {
          final isSelected = selectedSector == sec;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(
                sec,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                  color: isSelected
                      ? Colors.white
                      : (isDark
                          ? AppColor.darkTextPrimary
                          : const Color(0xFF374151)),
                ),
              ),
              selected: isSelected,
              selectedColor: AppColor.primaryBlue,
              backgroundColor:
                  isDark ? AppColor.darkSurface : const Color(0xFFF1F5F9),
              checkmarkColor: Colors.white,
              showCheckmark: false,
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: isSelected
                      ? AppColor.primaryBlue
                      : (isDark
                          ? AppColor.darkBorder
                          : const Color(0xFFE2E8F0)),
                  width: 0.8,
                ),
              ),
              onSelected: (_) => onSectorSelected(sec),
            ),
          );
        }).toList(),
      ),
    );
  }
}
