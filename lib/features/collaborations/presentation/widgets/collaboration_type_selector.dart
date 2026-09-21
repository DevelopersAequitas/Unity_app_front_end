import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/collaboration_type.dart';

class CollaborationTypeSelector extends StatelessWidget {
  final List<CollaborationType> options;
  final CollaborationType? selectedType;
  final ValueChanged<CollaborationType?> onChanged;

  const CollaborationTypeSelector({
    super.key,
    required this.options,
    this.selectedType,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Collaboration Type *',
          style: AppTypography.bodySmall.copyWith(
            fontWeight: FontWeight.w500,
            color: isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary,
          ),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<CollaborationType>(
          isExpanded: true,
          initialValue: selectedType,
          dropdownColor: isDark ? AppColor.darkSurface : AppColor.lightSurface,
          hint: Text(
            'Select collaboration type',
            style: AppTypography.bodyMedium.copyWith(
              color: (isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary).withValues(alpha: 0.6),
            ),
          ),
          decoration: _decoration(isDark),
          items: options
              .map(
                (opt) => DropdownMenuItem(
                  value: opt,
                  child: Text(
                    opt.label,
                    style: AppTypography.bodyMedium.copyWith(
                      color: isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary,
                      fontWeight: FontWeight.w400,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              )
              .toList(),
          onChanged: onChanged,
          validator: (val) => val == null ? 'Please select a collaboration type' : null,
        ),
      ],
    );
  }

  InputDecoration _decoration(bool isDark) {
    return InputDecoration(
      filled: true,
      fillColor: isDark ? AppColor.darkSurface : AppColor.lightSurface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: isDark ? AppColor.darkBorder : AppColor.lightBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: isDark ? AppColor.darkBorder : AppColor.lightBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColor.primaryBlue, width: 1.5),
      ),
    );
  }
}
