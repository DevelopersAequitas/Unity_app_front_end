import 'package:flutter/material.dart';
import '../../../../../core/theme/app_color.dart';
import '../../../../../core/theme/app_typography.dart';

class TestimonialMessageInput extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;

  const TestimonialMessageInput({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Message',
          style: AppTypography.titleSmall.copyWith(
            fontWeight: FontWeight.w500,
            fontSize: 13,
            color: AppColor.lightTextPrimary,
          ),
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
                maxLines: 5,
                maxLength: 500,
                buildCounter: (_, {required currentLength, required isFocused, maxLength}) => null,
                style: AppTypography.bodyMedium.copyWith(
                  fontSize: 13.5,
                  color: AppColor.lightTextPrimary,
                ),
                decoration: InputDecoration(
                  hintText: 'Share your experience, appreciation or feedback...',
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
