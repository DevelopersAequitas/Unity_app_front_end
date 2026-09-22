import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';

class NearMeRadiusSelector extends StatelessWidget {
  final double? selectedRadius;
  final ValueChanged<double?> onRadiusChanged;

  const NearMeRadiusSelector({
    super.key,
    required this.selectedRadius,
    required this.onRadiusChanged,
  });

  static const List<double?> _radiusOptions = [
    null,
    5.0,
    10.0,
    25.0,
    50.0,
    100.0,
    500.0,
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: _radiusOptions.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final radius = _radiusOptions[index];
          final isSelected = radius == selectedRadius;

          return GestureDetector(
            onTap: () => onRadiusChanged(radius),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                gradient: isSelected ? AppColor.brandGradient : null,
                color: isSelected ? null : AppColor.lightSurface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? Colors.transparent : AppColor.lightBorder,
                ),
              ),
              child: Center(
                child: Text(
                  radius == null ? 'All' : '${radius.toInt()} km',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                    color: isSelected ? Colors.white : AppColor.lightTextPrimary,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
