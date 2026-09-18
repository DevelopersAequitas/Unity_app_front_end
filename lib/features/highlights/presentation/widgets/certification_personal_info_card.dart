import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';

class CertificationPersonalInfoCard extends StatelessWidget {
  final TextEditingController fullNameController;
  final TextEditingController businessNameController;
  final TextEditingController emailController;
  final TextEditingController contactController;

  const CertificationPersonalInfoCard({
    super.key,
    required this.fullNameController,
    required this.businessNameController,
    required this.emailController,
    required this.contactController,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDark ? AppColor.darkSurface : AppColor.lightSurface;
    final borderColor = isDark ? AppColor.darkBorder : AppColor.lightBorder;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Personal & Business Details',
            style: AppTypography.titleSmall.copyWith(
              fontWeight: FontWeight.w500,
              color: isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 12),
          _buildField('Full Name *', fullNameController, Icons.person_outline_rounded, isDark),
          const SizedBox(height: 10),
          _buildField('Business / Organization *', businessNameController, Icons.business_outlined, isDark),
          const SizedBox(height: 10),
          _buildField('Email Address', emailController, Icons.email_outlined, isDark, keyboardType: TextInputType.emailAddress),
          const SizedBox(height: 10),
          _buildField('Phone Number', contactController, Icons.phone_outlined, isDark, keyboardType: TextInputType.phone),
        ],
      ),
    );
  }

  Widget _buildField(
    String label,
    TextEditingController controller,
    IconData icon,
    bool isDark, {
    TextInputType? keyboardType,
  }) {
    final bgColor = isDark ? AppColor.darkBackground : AppColor.lightBackground;
    final borderColor = isDark ? AppColor.darkBorder : AppColor.lightBorder;
    final textSecondary =
        isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary;

    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: AppTypography.bodyMedium,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppTypography.bodyMedium.copyWith(color: textSecondary),
        prefixIcon: Icon(icon, size: 20, color: textSecondary),
        filled: true,
        fillColor: bgColor,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: borderColor)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: borderColor)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColor.primaryBlue, width: 1.5)),
      ),
    );
  }
}
