import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/contact_picker_sheet.dart';

class RecommendPeerFormFields extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController mobileController;
  final TextEditingController emailController;
  final TextEditingController cityController;
  final TextEditingController businessController;
  final TextEditingController whyController;
  final String howWellKnown;
  final ValueChanged<String?> onHowWellKnownChanged;
  final bool isAware;
  final ValueChanged<bool> onIsAwareChanged;

  const RecommendPeerFormFields({
    super.key,
    required this.nameController,
    required this.mobileController,
    required this.emailController,
    required this.cityController,
    required this.businessController,
    required this.whyController,
    required this.howWellKnown,
    required this.onHowWellKnownChanged,
    required this.isAware,
    required this.onIsAwareChanged,
  });

  Future<void> _pickFromContacts(BuildContext context) async {
    final result = await ContactPickerSheet.pickContact(context);
    if (result != null) {
      nameController.text = result.name;
      mobileController.text = result.phone;
      if (result.email != null && result.email!.isNotEmpty) {
        emailController.text = result.email!;
      }
      if (result.company != null && result.company!.isNotEmpty) {
        businessController.text = result.company!;
      }
      if (result.address != null && result.address!.isNotEmpty) {
        cityController.text = result.address!;
      }
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
        _field('Peer Full Name *', nameController, Icons.person_outline_rounded, surfaceColor, borderColor, textSecondary),
        const SizedBox(height: 12),
        _field(
          'Peer Mobile Number *',
          mobileController,
          Icons.phone_outlined,
          surfaceColor,
          borderColor,
          textSecondary,
          keyboardType: TextInputType.phone,
          suffixIcon: IconButton(
            icon: const Icon(Icons.contact_phone_outlined, size: 20, color: AppColor.primaryBlue),
            onPressed: () => _pickFromContacts(context),
            tooltip: 'Select from contacts',
          ),
        ),
        const SizedBox(height: 12),
        _field('Peer Email', emailController, Icons.email_outlined, surfaceColor, borderColor, textSecondary, keyboardType: TextInputType.emailAddress),
        const SizedBox(height: 12),
        _field('City / Country', cityController, Icons.location_on_outlined, surfaceColor, borderColor, textSecondary),
        const SizedBox(height: 12),
        _field('Business / Brand Name', businessController, Icons.business_outlined, surfaceColor, borderColor, textSecondary),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          initialValue: howWellKnown,
          style: AppTypography.bodyMedium.copyWith(
            color: isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary,
            fontWeight: FontWeight.w500,
          ),
          decoration: _decoration('Relationship with Peer *', Icons.handshake_outlined, surfaceColor, borderColor, textSecondary),
          items: const [
            DropdownMenuItem(value: 'business_associate', child: Text('Business Associate')),
            DropdownMenuItem(value: 'close_friend', child: Text('Close Friend')),
            DropdownMenuItem(value: 'client', child: Text('Client / Customer')),
            DropdownMenuItem(value: 'community_contact', child: Text('Community Contact')),
          ],
          onChanged: onHowWellKnownChanged,
        ),
        const SizedBox(height: 8),
        SwitchListTile.adaptive(
          value: isAware,
          onChanged: onIsAwareChanged,
          title: Text(
            'Are they aware of this recommendation?',
            style: AppTypography.bodySmall.copyWith(
              color: isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary,
            ),
          ),
          contentPadding: EdgeInsets.zero,
          activeTrackColor: AppColor.primaryBlue,
        ),
        const SizedBox(height: 8),
        _field('Why do you recommend this peer?', whyController, Icons.rate_review_outlined, surfaceColor, borderColor, textSecondary, maxLines: 2),
      ],
    );
  }

  Widget _field(
    String label,
    TextEditingController controller,
    IconData icon,
    Color surfaceColor,
    Color borderColor,
    Color textSecondary, {
    TextInputType? keyboardType,
    int maxLines = 1,
    Widget? suffixIcon,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: AppTypography.bodyMedium,
      decoration: _decoration(label, icon, surfaceColor, borderColor, textSecondary, suffixIcon: suffixIcon),
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
