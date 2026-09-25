import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/primary_pill_button.dart';
import '../../domain/entities/referral_validation_entity.dart';
import 'register_dropdown_field.dart';
import 'register_geo_location_card.dart';
import 'register_referral_section.dart';
import 'register_step2_header.dart';
import 'register_terms_notice.dart';

class RegisterStep2View extends StatelessWidget {
  final TextEditingController companyNameController;
  final TextEditingController companyAddressController;
  final TextEditingController otherCategoryController;
  final TextEditingController referralController;
  final String? mainCategoryName;
  final String? categoryName;
  final bool isOtherCategory;
  final double? latitude;
  final double? longitude;
  final bool isLoading;
  final bool isValidatingReferral;
  final ReferralValidationEntity? referralValidation;
  final VoidCallback onSelectMainCategory;
  final VoidCallback onSelectCategory;
  final VoidCallback onPickLocation;
  final VoidCallback onValidateReferral;
  final VoidCallback onClearReferral;
  final VoidCallback onCreateAccount;

  const RegisterStep2View({
    super.key,
    required this.companyNameController,
    required this.companyAddressController,
    required this.otherCategoryController,
    required this.referralController,
    this.mainCategoryName,
    this.categoryName,
    this.isOtherCategory = false,
    this.latitude,
    this.longitude,
    required this.isLoading,
    this.isValidatingReferral = false,
    this.referralValidation,
    required this.onSelectMainCategory,
    required this.onSelectCategory,
    required this.onPickLocation,
    required this.onValidateReferral,
    required this.onClearReferral,
    required this.onCreateAccount,
  });

  @override
  Widget build(BuildContext context) {
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
                  const RegisterStep2Header(),
                  const SizedBox(height: 20),
                  AppTextField(
                    controller: companyNameController,
                    hintText: 'Company name',
                    prefixIcon: const Icon(Icons.business_center_outlined, size: 20),
                  ),
                  const SizedBox(height: 14),
                  RegisterDropdownField(
                    hintText: 'Main business category',
                    value: mainCategoryName,
                    prefixIcon: const Icon(Icons.apartment_outlined, size: 20),
                    onTap: onSelectMainCategory,
                  ),
                  const SizedBox(height: 14),
                  RegisterDropdownField(
                    hintText: 'Business category',
                    value: isOtherCategory ? 'Other' : categoryName,
                    prefixIcon: const Icon(Icons.local_offer_outlined, size: 20),
                    onTap: onSelectCategory,
                  ),
                  if (isOtherCategory) ...[
                    const SizedBox(height: 14),
                    AppTextField(
                      controller: otherCategoryController,
                      hintText: 'Specify other category name',
                      prefixIcon: const Icon(Icons.edit_note_outlined, size: 20),
                    ),
                  ],
                  const SizedBox(height: 14),
                  AppTextField(
                    controller: companyAddressController,
                    hintText: 'Company address',
                    prefixIcon: const Icon(Icons.location_on_outlined, size: 20),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.map_outlined, color: AppColor.primaryBlue, size: 22),
                      tooltip: 'Pick location on Map',
                      onPressed: onPickLocation,
                    ),
                  ),
                  RegisterGeoLocationCard(
                    latitude: latitude,
                    longitude: longitude,
                    onPickLocation: onPickLocation,
                  ),
                  const SizedBox(height: 14),
                  RegisterReferralSection(
                    controller: referralController,
                    isValidating: isValidatingReferral,
                    validation: referralValidation,
                    onValidate: onValidateReferral,
                    onClear: onClearReferral,
                  ),
                  const Spacer(),
                  const SizedBox(height: 20),
                  PrimaryPillButton(
                    label: 'Create account',
                    isLoading: isLoading,
                    onPressed: onCreateAccount,
                    showArrow: true,
                  ),
                  const SizedBox(height: 14),
                  const RegisterTermsNotice(),
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
