import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';

class RecommendPeerFormFields extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController mobileController;
  final TextEditingController emailController;
  final TextEditingController cityController;
  final TextEditingController businessController;
  final TextEditingController whyController;
  final TextEditingController noteController;
  final TextEditingController otherCategoryController;
  final String? mainCategoryName;
  final String? subCategoryName;
  final bool isOtherCategory;
  final bool isLoadingSubs;
  final String howWellKnown;
  final ValueChanged<String?> onHowWellKnownChanged;
  final VoidCallback onPickContact;
  final VoidCallback onPickCity;
  final VoidCallback onSelectMainCategory;
  final VoidCallback onSelectSubCategory;
  final String? initialCircleName;
  final String? initialCategory;

  const RecommendPeerFormFields({
    super.key,
    required this.nameController,
    required this.mobileController,
    required this.emailController,
    required this.cityController,
    required this.businessController,
    required this.whyController,
    required this.noteController,
    required this.otherCategoryController,
    this.mainCategoryName,
    this.subCategoryName,
    this.isOtherCategory = false,
    this.isLoadingSubs = false,
    required this.howWellKnown,
    required this.onHowWellKnownChanged,
    required this.onPickContact,
    required this.onPickCity,
    required this.onSelectMainCategory,
    required this.onSelectSubCategory,
    this.initialCircleName,
    this.initialCategory,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDark ? AppColor.darkSurface : AppColor.lightSurface;
    final borderColor = isDark ? AppColor.darkBorder : AppColor.lightBorder;
    final textSecondary =
        isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary;
    final textPrimary =
        isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (initialCircleName != null || initialCategory != null) ...[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: AppColor.primaryBlue.withValues(alpha: isDark ? 0.15 : 0.08),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: AppColor.primaryBlue.withValues(alpha: 0.25),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColor.primaryBlue.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.hub_outlined,
                    color: AppColor.primaryBlue,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (initialCircleName != null)
                        Text(
                          initialCircleName!,
                          style: AppTypography.titleMedium.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: textPrimary,
                          ),
                        ),
                      if (initialCategory != null)
                        Text(
                          'Open Category: $initialCategory',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColor.primaryBlue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
        ],
        InkWell(
          onTap: onPickContact,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
                const Icon(
                  Icons.contacts_rounded,
                  size: 18,
                  color: AppColor.primaryBlue,
                ),
                const SizedBox(width: 8),
                Text(
                  'Pick Peer from Contacts',
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColor.primaryBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        _field(
          label: 'Peer Full Name *',
          hint: 'Enter full name',
          controller: nameController,
          icon: Icons.person_outline_rounded,
          surfaceColor: surfaceColor,
          borderColor: borderColor,
          textSecondary: textSecondary,
          suffixIcon: IconButton(
            icon: const Icon(
              Icons.contact_phone_outlined,
              size: 20,
              color: AppColor.primaryBlue,
            ),
            onPressed: onPickContact,
            tooltip: 'Pick from contacts',
          ),
        ),
        const SizedBox(height: 14),
        _field(
          label: 'Peer Mobile Number *',
          hint: 'e.g. 9876543210 (WhatsApp preferred)',
          controller: mobileController,
          icon: Icons.phone_outlined,
          surfaceColor: surfaceColor,
          borderColor: borderColor,
          textSecondary: textSecondary,
          keyboardType: TextInputType.phone,
          suffixIcon: IconButton(
            icon: const Icon(
              Icons.contact_phone_outlined,
              size: 20,
              color: AppColor.primaryBlue,
            ),
            onPressed: onPickContact,
            tooltip: 'Pick from contacts',
          ),
        ),
        const SizedBox(height: 14),
        _field(
          label: 'Peer Email',
          hint: 'e.g. peer@company.com (Optional)',
          controller: emailController,
          icon: Icons.email_outlined,
          surfaceColor: surfaceColor,
          borderColor: borderColor,
          textSecondary: textSecondary,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 14),
        _selectorTile(
          label: 'City / Country',
          value: cityController.text.isNotEmpty ? cityController.text : null,
          placeholder: 'Select City & Country',
          icon: Icons.location_on_outlined,
          onTap: onPickCity,
          surfaceColor: surfaceColor,
          borderColor: borderColor,
          textSecondary: textSecondary,
          textPrimary: textPrimary,
        ),
        const SizedBox(height: 14),
        _field(
          label: 'Business / Profession Name',
          hint: 'e.g. Apex Tech Solutions / Architect',
          controller: businessController,
          icon: Icons.business_outlined,
          surfaceColor: surfaceColor,
          borderColor: borderColor,
          textSecondary: textSecondary,
        ),
        const SizedBox(height: 14),
        _selectorTile(
          label: 'Main Business Category',
          value: mainCategoryName,
          placeholder: 'Select Business Category',
          icon: Icons.apartment_outlined,
          onTap: onSelectMainCategory,
          surfaceColor: surfaceColor,
          borderColor: borderColor,
          textSecondary: textSecondary,
          textPrimary: textPrimary,
        ),
        const SizedBox(height: 14),
        _selectorTile(
          label: 'Business Subcategory',
          value: isLoadingSubs
              ? 'Loading Subcategories...'
              : (isOtherCategory ? 'Other' : subCategoryName),
          placeholder: 'Select Subcategory / Specialization',
          icon: Icons.local_offer_outlined,
          onTap: onSelectSubCategory,
          surfaceColor: surfaceColor,
          borderColor: borderColor,
          textSecondary: textSecondary,
          textPrimary: textPrimary,
          trailing: isLoadingSubs
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : null,
        ),
        if (isOtherCategory) ...[
          const SizedBox(height: 14),
          _field(
            label: 'Specify Custom Subcategory',
            hint: 'Enter category or specialization name',
            controller: otherCategoryController,
            icon: Icons.edit_note_outlined,
            surfaceColor: surfaceColor,
            borderColor: borderColor,
            textSecondary: textSecondary,
          ),
        ],
        const SizedBox(height: 14),
        DropdownButtonFormField<String>(
          initialValue: howWellKnown,
          style: AppTypography.bodyMedium.copyWith(
            color: textPrimary,
            fontWeight: FontWeight.w500,
          ),
          dropdownColor: surfaceColor,
          decoration: _decoration(
            'Relationship with Peer *',
            'How well you know this person',
            Icons.handshake_outlined,
            surfaceColor,
            borderColor,
            textSecondary,
          ),
          items: const [
            DropdownMenuItem(
              value: 'business_associate',
              child: Text('Business Associate'),
            ),
            DropdownMenuItem(
              value: 'close_friend',
              child: Text('Close Friend'),
            ),
            DropdownMenuItem(
              value: 'client',
              child: Text('Client / Customer'),
            ),
            DropdownMenuItem(
              value: 'community_contact',
              child: Text('Community Contact'),
            ),
          ],
          onChanged: onHowWellKnownChanged,
        ),
        const SizedBox(height: 14),
        _field(
          label: 'Why do you recommend this peer?',
          hint: 'Share why their skills or business will add value to the community (Optional)',
          controller: whyController,
          icon: Icons.rate_review_outlined,
          surfaceColor: surfaceColor,
          borderColor: borderColor,
          textSecondary: textSecondary,
          maxLines: 2,
        ),
        const SizedBox(height: 14),
        _field(
          label: 'Any Note for the Team?',
          hint: 'Any special note or context to share (Optional)',
          controller: noteController,
          icon: Icons.notes_outlined,
          surfaceColor: surfaceColor,
          borderColor: borderColor,
          textSecondary: textSecondary,
          maxLines: 2,
        ),
      ],
    );
  }

  Widget _field({
    required String label,
    required String hint,
    required TextEditingController controller,
    required IconData icon,
    required Color surfaceColor,
    required Color borderColor,
    required Color textSecondary,
    TextInputType? keyboardType,
    int maxLines = 1,
    Widget? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.labelMedium.copyWith(
            color: textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          style: AppTypography.bodyMedium,
          decoration: _decoration(
            label,
            hint,
            icon,
            surfaceColor,
            borderColor,
            textSecondary,
            suffixIcon: suffixIcon,
          ),
        ),
      ],
    );
  }

  Widget _selectorTile({
    required String label,
    required String? value,
    required String placeholder,
    required IconData icon,
    required VoidCallback onTap,
    required Color surfaceColor,
    required Color borderColor,
    required Color textSecondary,
    required Color textPrimary,
    Widget? trailing,
  }) {
    final hasVal = value != null && value.isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.labelMedium.copyWith(
            color: textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: borderColor),
            ),
            child: Row(
              children: [
                Icon(icon, size: 20, color: textSecondary),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    hasVal ? value : placeholder,
                    style: AppTypography.bodyMedium.copyWith(
                      color: hasVal ? textPrimary : textSecondary.withValues(alpha: 0.7),
                      fontWeight: hasVal ? FontWeight.w500 : FontWeight.w400,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                trailing ??
                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 20,
                      color: textSecondary,
                    ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  InputDecoration _decoration(
    String label,
    String hint,
    IconData icon,
    Color surfaceColor,
    Color borderColor,
    Color textSecondary, {
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: AppTypography.bodyMedium.copyWith(
        color: textSecondary.withValues(alpha: 0.6),
      ),
      prefixIcon: Icon(icon, size: 20, color: textSecondary),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: surfaceColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColor.primaryBlue, width: 1.5),
      ),
    );
  }
}
