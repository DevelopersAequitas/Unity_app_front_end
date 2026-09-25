import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/app_date_formatter.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/primary_pill_button.dart';
import 'register_dropdown_field.dart';
import 'register_phone_field.dart';
import 'register_photo_card.dart';

class RegisterStep1View extends StatelessWidget {
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final String countryCode;
  final String? dob;
  final String? city;
  final String? profilePhotoPath;
  final ValueChanged<String> onCountryCodeChanged;
  final VoidCallback onSelectDob;
  final VoidCallback onSelectCity;
  final VoidCallback onSelectPhoto;
  final VoidCallback onContinue;

  const RegisterStep1View({
    super.key,
    required this.firstNameController,
    required this.lastNameController,
    required this.emailController,
    required this.phoneController,
    required this.countryCode,
    this.dob,
    this.city,
    this.profilePhotoPath,
    required this.onCountryCodeChanged,
    required this.onSelectDob,
    required this.onSelectCity,
    required this.onSelectPhoto,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor = isDark
        ? AppColor.darkTextPrimary
        : AppColor.lightTextPrimary;
    final secondaryTextColor = isDark
        ? AppColor.darkTextSecondary
        : AppColor.lightTextSecondary;

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  Text(
                    "Let's get started",
                    style: AppTypography.titleLarge.copyWith(
                      color: primaryTextColor,
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Welcome to new world of collaborations',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColor.primaryBlue,
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Tell us a few basic details to create your account.',
                    style: AppTypography.bodyMedium.copyWith(
                      color: secondaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: AppTextField(
                          controller: firstNameController,
                          hintText: 'First name',
                          prefixIcon: const Icon(
                            Icons.person_outline_rounded,
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: AppTextField(
                          controller: lastNameController,
                          hintText: 'Last name',
                          prefixIcon: const Icon(
                            Icons.person_outline_rounded,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  AppTextField(
                    controller: emailController,
                    hintText: 'Email address',
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: const Icon(
                      Icons.mail_outline_rounded,
                      size: 20,
                    ),
                  ),
                  const SizedBox(height: 14),
                  RegisterPhoneField(
                    controller: phoneController,
                    countryCode: countryCode,
                    onCountryCodeChanged: onCountryCodeChanged,
                  ),
                  const SizedBox(height: 14),
                  RegisterDropdownField(
                    hintText: 'Date of birth',
                    value: dob != null && dob!.isNotEmpty ? AppDateFormatter.format(dob) : null,
                    prefixIcon: const Icon(
                      Icons.calendar_today_outlined,
                      size: 20,
                    ),
                    onTap: onSelectDob,
                  ),
                  const SizedBox(height: 14),
                  RegisterDropdownField(
                    hintText: 'City',
                    value: city,
                    prefixIcon: const Icon(
                      Icons.location_on_outlined,
                      size: 20,
                    ),
                    onTap: onSelectCity,
                  ),
                  const SizedBox(height: 14),
                  RegisterPhotoCard(
                    photoPath: profilePhotoPath,
                    onTap: onSelectPhoto,
                  ),
                  const Spacer(),
                  const SizedBox(height: 24),
                  PrimaryPillButton(
                    label: 'Continue',
                    onPressed: onContinue,
                    showArrow: true,
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Text(
                      'CONNECT   •   COLLABORATE   •   IMPACT',
                      style: AppTypography.labelSmall.copyWith(
                        color: secondaryTextColor.withValues(alpha: 0.6),
                        letterSpacing: 1.5,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
