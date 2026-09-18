import 'package:flutter/material.dart';
import '../../../../../core/theme/app_color.dart';
import '../../../../../core/theme/app_typography.dart';

class ReferralRemarksInput extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const ReferralRemarksInput({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Remarks / Requirements',
          style: AppTypography.titleSmall.copyWith(
            fontWeight: FontWeight.w500,
            fontSize: 13,
            color: AppColor.lightTextPrimary,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          onChanged: onChanged,
          textCapitalization: TextCapitalization.sentences,
          maxLines: 3,
          decoration: InputDecoration(
            hintText:
                'e.g. Looking for web development services within 2 months...',
            hintStyle: AppTypography.bodySmall.copyWith(
              color: AppColor.lightTextTertiary,
              fontSize: 13,
            ),
            contentPadding: const EdgeInsets.all(16),
            filled: true,
            fillColor: AppColor.lightSurface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColor.lightBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColor.lightBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColor.primaryBlue,
                width: 1.5,
              ),
            ),
          ),
          style: AppTypography.bodyMedium.copyWith(
            fontSize: 13.5,
            color: AppColor.lightTextPrimary,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}
