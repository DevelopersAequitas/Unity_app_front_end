import 'package:flutter/material.dart';
import '../../../../../core/theme/app_color.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../core/widgets/app_phone_field.dart';

class ReferralContactInputs extends StatelessWidget {
  final TextEditingController phoneController;
  final TextEditingController emailController;
  final TextEditingController addressController;
  final ValueChanged<String> onPhoneChanged;
  final ValueChanged<String> onEmailChanged;
  final ValueChanged<String> onAddressChanged;
  final VoidCallback? onPickContact;

  const ReferralContactInputs({
    super.key,
    required this.phoneController,
    required this.emailController,
    required this.addressController,
    required this.onPhoneChanged,
    required this.onEmailChanged,
    required this.onAddressChanged,
    this.onPickContact,
  });

  InputDecoration _buildDecoration({
    required String hintText,
    required IconData prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: AppTypography.bodySmall.copyWith(
        color: AppColor.lightTextTertiary,
        fontSize: 13,
      ),
      prefixIcon: Icon(prefixIcon, size: 20, color: AppColor.lightTextTertiary),
      suffixIcon: suffixIcon,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
        borderSide: const BorderSide(color: AppColor.primaryBlue, width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Phone Field with Country Code Picker & Leading Zero Prevention
        AppPhoneField(
          controller: phoneController,
          label: 'Phone Number',
          hintText: '98765 43210',
          onChanged: onPhoneChanged,
          suffixIcon: onPickContact != null
              ? IconButton(
                  icon: const Icon(
                    Icons.contacts_outlined,
                    size: 20,
                    color: AppColor.lightTextSecondary,
                  ),
                  tooltip: 'Pick from contacts',
                  onPressed: onPickContact,
                )
              : null,
        ),
        const SizedBox(height: 16),

        // Email Field
        Text(
          'Email Address',
          style: AppTypography.titleSmall.copyWith(
            fontWeight: FontWeight.w500,
            fontSize: 13,
            color: AppColor.lightTextPrimary,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: emailController,
          onChanged: onEmailChanged,
          keyboardType: TextInputType.emailAddress,
          decoration: _buildDecoration(
            hintText: 'e.g. client@xyztech.com',
            prefixIcon: Icons.mail_outline_rounded,
          ),
          style: AppTypography.bodyMedium.copyWith(
            fontSize: 13.5,
            color: AppColor.lightTextPrimary,
          ),
        ),
        const SizedBox(height: 16),

        // Address Field
        Text(
          'Address / Location',
          style: AppTypography.titleSmall.copyWith(
            fontWeight: FontWeight.w500,
            fontSize: 13,
            color: AppColor.lightTextPrimary,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: addressController,
          onChanged: onAddressChanged,
          textCapitalization: TextCapitalization.sentences,
          decoration: _buildDecoration(
            hintText: 'e.g. 123 Business Park, Suite 400, Mumbai',
            prefixIcon: Icons.location_on_outlined,
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
