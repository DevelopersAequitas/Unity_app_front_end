import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';

class GratitudeForm extends StatelessWidget {
  final TextEditingController progressController;
  final TextEditingController goalController;
  final TextEditingController storyController;
  final VoidCallback onSave;
  final bool isSaving;

  const GratitudeForm({
    super.key,
    required this.progressController,
    required this.goalController,
    required this.storyController,
    required this.onSave,
    this.isSaving = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColor.darkSurface : AppColor.lightSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColor.darkBorder : AppColor.lightBorder,
          width: 0.8,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.edit_note_rounded, size: 18, color: AppColor.primaryBlue),
              const SizedBox(width: 6),
              Text(
                'Customize Your Impact Script',
                style: AppTypography.titleSmall.copyWith(
                  fontWeight: FontWeight.w500,
                  color: isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildInput(
            label: 'Meaningful progress this month',
            hint: 'e.g. Launched new mobile product, onboarded 10 clients...',
            controller: progressController,
            isDark: isDark,
            maxLines: 2,
          ),
          const SizedBox(height: 10),
          _buildInput(
            label: 'My goal for next month',
            hint: 'e.g. Connect with 5 tech founders, close 2 partnership deals...',
            controller: goalController,
            isDark: isDark,
            maxLines: 2,
          ),
          const SizedBox(height: 10),
          _buildInput(
            label: 'Experience or story (optional)',
            hint: 'e.g. A memorable collaboration with fellow peers this month...',
            controller: storyController,
            isDark: isDark,
            maxLines: 2,
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 38,
            child: Container(
              decoration: BoxDecoration(
                gradient: AppColor.brandGradient,
                borderRadius: BorderRadius.circular(8),
              ),
              child: ElevatedButton(
                onPressed: isSaving ? null : onSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: isSaving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Text(
                        'Save & Update Script',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInput({
    required String label,
    required String hint,
    required TextEditingController controller,
    required bool isDark,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            color: isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          maxLines: maxLines,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              fontSize: 11.5,
              color: isDark ? AppColor.darkTextSecondary.withValues(alpha: 0.6) : AppColor.lightTextSecondary.withValues(alpha: 0.6),
            ),
            filled: true,
            fillColor: isDark ? AppColor.darkSurfaceSubtle : AppColor.lightSurfaceSubtle,
            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: isDark ? AppColor.darkBorder : AppColor.lightBorder, width: 0.8),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: isDark ? AppColor.darkBorder : AppColor.lightBorder, width: 0.8),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColor.primaryBlue, width: 1.0),
            ),
          ),
        ),
      ],
    );
  }
}

