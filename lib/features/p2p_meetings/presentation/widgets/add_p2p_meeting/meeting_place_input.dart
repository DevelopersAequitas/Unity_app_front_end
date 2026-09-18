import 'package:flutter/material.dart';
import 'package:unity_app/core/constants/app_colors.dart';

class MeetingPlaceInput extends StatelessWidget {
  final TextEditingController controller;

  const MeetingPlaceInput({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Meeting Place / Location',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'e.g. Starbucks Coffee, Ring Road',
            hintStyle: const TextStyle(
              fontSize: 14,
              color: AppColors.textTertiary,
            ),
            prefixIcon: const Icon(
              Icons.location_on_outlined,
              size: 20,
              color: AppColors.textSecondary,
            ),
            filled: true,
            fillColor: AppColors.backgroundCard,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.borderLight),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.borderLight),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.primary),
            ),
          ),
          validator: (val) {
            if (val == null || val.trim().isEmpty) {
              return 'Please enter meeting place';
            }
            return null;
          },
        ),
      ],
    );
  }
}
