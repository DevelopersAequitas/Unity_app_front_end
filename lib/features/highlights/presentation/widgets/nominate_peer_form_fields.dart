import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/contact_picker_sheet.dart';

class NominatePeerFormFields extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController mobileController;

  const NominatePeerFormFields({
    super.key,
    required this.nameController,
    required this.mobileController,
  });

  Future<void> _pickFromContacts(BuildContext context) async {
    final result = await ContactPickerSheet.pickContact(context);
    if (result != null) {
      nameController.text = result.name;
      mobileController.text = result.phone;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDark ? AppColor.darkSurface : AppColor.lightSurface;
    final borderColor = isDark ? AppColor.darkBorder : AppColor.lightBorder;
    final textSecondary =
        isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => _pickFromContacts(context),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: AppColor.primaryBlue.withValues(alpha: isDark ? 0.12 : 0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColor.primaryBlue.withValues(alpha: 0.25),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.contacts_rounded, size: 18, color: AppColor.primaryBlue),
                const SizedBox(width: 8),
                Text(
                  'Pick from Contacts',
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColor.primaryBlue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),
        TextField(
          controller: nameController,
          style: AppTypography.bodyMedium,
          decoration: _decoration('Nominee Full Name *', Icons.person_outline_rounded, surfaceColor, borderColor, textSecondary),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: mobileController,
          keyboardType: TextInputType.phone,
          style: AppTypography.bodyMedium,
          decoration: _decoration(
            'Nominee Mobile Number *',
            Icons.phone_outlined,
            surfaceColor,
            borderColor,
            textSecondary,
            suffixIcon: IconButton(
              icon: const Icon(Icons.contact_phone_outlined, size: 20, color: AppColor.primaryBlue),
              onPressed: () => _pickFromContacts(context),
              tooltip: 'Select from contacts',
            ),
          ),
        ),
      ],
    );
  }

  InputDecoration _decoration(
    String label,
    IconData icon,
    Color surfaceColor,
    Color borderColor,
    Color textSecondary, {
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: AppTypography.bodyMedium.copyWith(color: textSecondary),
      prefixIcon: Icon(icon, size: 20, color: textSecondary),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: surfaceColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: borderColor)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: borderColor)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColor.primaryBlue, width: 1.5)),
    );
  }
}
