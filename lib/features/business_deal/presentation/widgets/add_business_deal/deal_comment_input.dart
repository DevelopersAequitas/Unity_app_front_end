import 'package:flutter/material.dart';
import '../../../../../core/theme/app_color.dart';
import '../../../../../core/theme/app_typography.dart';

class DealCommentInput extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;

  const DealCommentInput({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Remarks / Notes',
              style: AppTypography.titleSmall.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 13,
                color: AppColor.lightTextPrimary,
              ),
            ),
            Text(
              'Optional',
              style: AppTypography.labelSmall.copyWith(
                fontSize: 11,
                color: AppColor.lightTextTertiary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppColor.lightSurface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColor.lightBorder),
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextFormField(
                initialValue: value,
                onChanged: onChanged,
                maxLines: 4,
                maxLength: 500,
                buildCounter: (_,
                        {required currentLength,
                        required isFocused,
                        maxLength}) =>
                    null,
                style: AppTypography.bodyMedium.copyWith(
                  fontSize: 13.5,
                  color: AppColor.lightTextPrimary,
                ),
                decoration: InputDecoration(
                  hintText:
                      'e.g. Closed deal via referral for software implementation...',
                  hintStyle: AppTypography.bodySmall.copyWith(
                    color: AppColor.lightTextTertiary,
                    fontSize: 13,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                  isDense: true,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${value.length}/500',
                style: AppTypography.labelSmall.copyWith(
                  fontSize: 11,
                  color: AppColor.lightTextTertiary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
