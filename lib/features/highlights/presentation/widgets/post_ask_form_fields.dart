import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import 'highlight_text_field.dart';

class PostAskFormFields extends StatelessWidget {
  final TextEditingController subjectController;
  final TextEditingController descriptionController;
  final TextEditingController cityController;
  final String? selectedCategory;
  final String selectedRegion;
  final ValueChanged<String?> onCategoryChanged;
  final ValueChanged<String?> onRegionChanged;

  static const categories = [
    'Business Leads',
    'Partnership Opportunities',
    'Job Opportunities',
    'Service Providers',
    'Investment Opportunities',
    'Technical Support',
    'General Inquiry',
    'Circle Collaboration',
    'Feedback',
    'Other',
  ];

  static const regions = [
    'All India',
    'North India',
    'South India',
    'East India',
    'West India',
    'Central India',
    'Northeast India',
    'Global',
  ];

  const PostAskFormFields({
    super.key,
    required this.subjectController,
    required this.descriptionController,
    required this.cityController,
    required this.selectedCategory,
    required this.selectedRegion,
    required this.onCategoryChanged,
    required this.onRegionChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HighlightTextField(
          controller: subjectController,
          label: 'Subject / Title *',
          hint: 'e.g. Looking for React Native developers',
          validator: (v) => (v == null || v.trim().isEmpty) ? 'Subject is required' : null,
        ),
        const SizedBox(height: 14),
        Text(
          'Category *',
          style: AppTypography.bodySmall.copyWith(
            fontWeight: FontWeight.w500,
            color: isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary,
          ),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          initialValue: selectedCategory,
          dropdownColor: isDark ? AppColor.darkSurface : AppColor.lightSurface,
          style: AppTypography.bodyMedium.copyWith(
            color: isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary,
            fontWeight: FontWeight.w500,
          ),
          decoration: _dropdownDecoration('Select category', isDark),
          items: categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
          onChanged: onCategoryChanged,
          validator: (v) => (v == null || v.isEmpty) ? 'Please select a category' : null,
        ),
        const SizedBox(height: 14),
        HighlightTextField(
          controller: descriptionController,
          label: 'Detailed Description *',
          hint: 'Explain what you need in detail...',
          maxLines: 4,
          validator: (v) => (v == null || v.trim().isEmpty) ? 'Description is required' : null,
        ),
        const SizedBox(height: 14),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Region',
                    style: AppTypography.bodySmall.copyWith(
                      fontWeight: FontWeight.w500,
                      color: isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    initialValue: selectedRegion,
                    dropdownColor: isDark ? AppColor.darkSurface : AppColor.lightSurface,
                    style: AppTypography.bodyMedium.copyWith(
                      color: isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: _dropdownDecoration('Region', isDark),
                    items: regions.map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
                    onChanged: onRegionChanged,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: HighlightTextField(
                controller: cityController,
                label: 'City',
                hint: 'City name',
              ),
            ),
          ],
        ),
      ],
    );
  }

  InputDecoration _dropdownDecoration(String hint, bool isDark) {
    return InputDecoration(
      hintText: hint,
      hintStyle: AppTypography.bodyMedium.copyWith(
        color: (isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary)
            .withValues(alpha: 0.6),
      ),
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
