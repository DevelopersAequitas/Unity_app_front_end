import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../highlights/presentation/widgets/highlight_text_field.dart';
import 'collaborations_constants.dart';

class ScopeGeographySection extends StatelessWidget {
  final String? selectedScope;
  final String? selectedPreferredModel;
  final TextEditingController countriesController;
  final ValueChanged<String?> onScopeChanged;
  final ValueChanged<String?> onModelChanged;

  const ScopeGeographySection({
    super.key,
    this.selectedScope,
    this.selectedPreferredModel,
    required this.countriesController,
    required this.onScopeChanged,
    required this.onModelChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label('Scope *', isDark),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          isExpanded: true,
          initialValue: selectedScope,
          dropdownColor: isDark ? AppColor.darkSurface : AppColor.lightSurface,
          hint: Text('Select scope', style: _hintStyle(isDark)),
          decoration: _decoration(isDark),
          items: scopeOptions
              .map((opt) => DropdownMenuItem(value: opt.value, child: Text(opt.label)))
              .toList(),
          onChanged: onScopeChanged,
          validator: (val) => (val == null || val.isEmpty) ? 'Please select collaboration scope' : null,
        ),
        if (selectedScope == 'international') ...[
          const SizedBox(height: 14),
          HighlightTextField(
            controller: countriesController,
            label: 'Countries of Interest *',
            hint: 'e.g. IN, AE, US, UK',
            validator: (val) => (val == null || val.trim().isEmpty) ? 'Please specify countries' : null,
          ),
        ],
        const SizedBox(height: 14),
        _label('Preferred Model (Optional)', isDark),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          isExpanded: true,
          initialValue: selectedPreferredModel,
          dropdownColor: isDark ? AppColor.darkSurface : AppColor.lightSurface,
          hint: Text('Select preferred model', style: _hintStyle(isDark)),
          decoration: _decoration(isDark),
          items: preferredModelOptions
              .map((opt) => DropdownMenuItem(value: opt.value, child: Text(opt.label)))
              .toList(),
          onChanged: onModelChanged,
        ),
      ],
    );
  }

  Widget _label(String text, bool isDark) {
    return Text(
      text,
      style: AppTypography.bodySmall.copyWith(
        fontWeight: FontWeight.w500,
        color: isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary,
      ),
    );
  }

  TextStyle _hintStyle(bool isDark) {
    return AppTypography.bodyMedium.copyWith(
      color: (isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary).withValues(alpha: 0.6),
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
