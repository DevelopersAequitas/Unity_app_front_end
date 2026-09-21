import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import 'collaborations_constants.dart';

class BusinessStatusSection extends StatelessWidget {
  final String? selectedBusinessStage;
  final String? selectedYearsInOperation;
  final String? selectedUrgency;
  final ValueChanged<String?> onStageChanged;
  final ValueChanged<String?> onYearsChanged;
  final ValueChanged<String?> onUrgencyChanged;

  const BusinessStatusSection({
    super.key,
    this.selectedBusinessStage,
    this.selectedYearsInOperation,
    this.selectedUrgency,
    required this.onStageChanged,
    required this.onYearsChanged,
    required this.onUrgencyChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _dropdownField('Business Stage *', selectedBusinessStage, businessStageOptions.map((o) => DropdownMenuItem(value: o.value, child: Text(o.label))).toList(), onStageChanged, isDark),
        const SizedBox(height: 14),
        _dropdownField('Years in Operation *', selectedYearsInOperation, yearsInOperationOptions.map((o) => DropdownMenuItem(value: o.value, child: Text(o.label))).toList(), onYearsChanged, isDark),
        const SizedBox(height: 14),
        _dropdownField('Urgency *', selectedUrgency, urgencyOptions.map((o) => DropdownMenuItem(value: o.value, child: Text(o.label))).toList(), onUrgencyChanged, isDark),
      ],
    );
  }

  Widget _dropdownField(String label, String? value, List<DropdownMenuItem<String>> items, ValueChanged<String?> onChanged, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.bodySmall.copyWith(
            fontWeight: FontWeight.w500,
            color: isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary,
          ),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          isExpanded: true,
          initialValue: value,
          dropdownColor: isDark ? AppColor.darkSurface : AppColor.lightSurface,
          hint: Text('Select option', style: AppTypography.bodyMedium.copyWith(color: (isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary).withValues(alpha: 0.6))),
          decoration: InputDecoration(
            filled: true,
            fillColor: isDark ? AppColor.darkSurface : AppColor.lightSurface,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: isDark ? AppColor.darkBorder : AppColor.lightBorder)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: isDark ? AppColor.darkBorder : AppColor.lightBorder)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColor.primaryBlue, width: 1.5)),
          ),
          items: items,
          onChanged: onChanged,
          validator: (val) => (val == null || val.isEmpty) ? 'Please select an option' : null,
        ),
      ],
    );
  }
}
