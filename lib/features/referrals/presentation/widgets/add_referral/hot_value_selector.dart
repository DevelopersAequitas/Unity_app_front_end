import 'package:flutter/material.dart';
import '../../../../../core/theme/app_color.dart';
import '../../../../../core/theme/app_typography.dart';

class HotValueSelector extends StatelessWidget {
  final int hotValue;
  final ValueChanged<int> onHotValueChanged;

  const HotValueSelector({
    super.key,
    required this.hotValue,
    required this.onHotValueChanged,
  });

  static const List<String> _labels = [
    'Cold',
    'Warm',
    'Active',
    'Hot',
    'Urgent',
  ];

  String _getLabelText() {
    final idx = (hotValue - 1).clamp(0, 4);
    return '${_labels[idx]} ($hotValue of 5)';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Lead Priority / Temperature *',
              style: AppTypography.titleSmall.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 13,
                color: AppColor.lightTextPrimary,
              ),
            ),
            Text(
              _getLabelText(),
              style: AppTypography.labelMedium.copyWith(
                color: AppColor.primaryBlue,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: List.generate(5, (index) {
            final level = index + 1;
            final isSelected = level == hotValue;
            final isFilled = level <= hotValue;

            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: index < 4 ? 8 : 0),
                child: Material(
                  color: isSelected
                      ? AppColor.primaryBlue.withValues(alpha: 0.08)
                      : isFilled
                          ? AppColor.primaryBlue.withValues(alpha: 0.04)
                          : AppColor.lightSurface,
                  borderRadius: BorderRadius.circular(10),
                  child: InkWell(
                    onTap: () => onHotValueChanged(level),
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isSelected
                              ? AppColor.primaryBlue
                              : isFilled
                                  ? AppColor.primaryBlue.withValues(alpha: 0.3)
                                  : AppColor.lightBorder,
                          width: isSelected ? 1.5 : 1.0,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '$level',
                            style: AppTypography.bodyMedium.copyWith(
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                              color: isFilled
                                  ? AppColor.primaryBlue
                                  : AppColor.lightTextSecondary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _labels[index],
                            style: AppTypography.labelSmall.copyWith(
                              fontSize: 10,
                              fontWeight: isSelected
                                  ? FontWeight.w500
                                  : FontWeight.w400,
                              color: isFilled
                                  ? AppColor.primaryBlue
                                  : AppColor.lightTextTertiary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
