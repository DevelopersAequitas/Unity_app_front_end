import 'package:flutter/material.dart';
import '../../../../../core/theme/app_color.dart';
import '../../../../../core/theme/app_typography.dart';

class ReferralProspectInput extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const ReferralProspectInput({
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
          'Referral Of (Prospect / Company) *',
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
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(
            hintText: 'e.g. XYZ Tech Solutions or John Doe',
            hintStyle: AppTypography.bodySmall.copyWith(
              color: AppColor.lightTextTertiary,
              fontSize: 13,
            ),
            prefixIcon: const Icon(
              Icons.badge_outlined,
              size: 20,
              color: AppColor.lightTextTertiary,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
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
          ),
        ),
      ],
    );
  }
}
