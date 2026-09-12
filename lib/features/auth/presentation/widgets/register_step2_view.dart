import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/primary_pill_button.dart';
import 'register_dropdown_field.dart';
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
  final VoidCallback onSelectMainCategory;
  final VoidCallback onSelectCategory;
  final VoidCallback onPickLocation;
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
    required this.onSelectMainCategory,
    required this.onSelectCategory,
    required this.onPickLocation,
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
                    prefixIcon: const Icon(
                      Icons.business_center_outlined,
                      size: 20,
                    ),
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
                    prefixIcon: const Icon(
                      Icons.local_offer_outlined,
                      size: 20,
                    ),
                    onTap: onSelectCategory,
                  ),
                  if (isOtherCategory) ...[
                    const SizedBox(height: 14),
                    AppTextField(
                      controller: otherCategoryController,
                      hintText: 'Specify other category name',
                      prefixIcon: const Icon(
                        Icons.edit_note_outlined,
                        size: 20,
                      ),
                    ),
                  ],
                  const SizedBox(height: 14),
                  AppTextField(
                    controller: companyAddressController,
                    hintText: 'Company address',
                    prefixIcon: const Icon(
                      Icons.location_on_outlined,
                      size: 20,
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(
                        Icons.map_outlined,
                        color: AppColor.primaryBlue,
                        size: 22,
                      ),
                      tooltip: 'Pick location on Map',
                      onPressed: onPickLocation,
                    ),
                  ),
                  if (latitude != null && longitude != null) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: AppColor.primaryBlue.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: AppColor.primaryBlue.withValues(alpha: 0.25),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.my_location,
                            size: 14,
                            color: AppColor.primaryBlue,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Pin: ${latitude!.toStringAsFixed(4)}, ${longitude!.toStringAsFixed(4)} (Geo-Tagged)',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColor.primaryBlue,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          GestureDetector(
                            onTap: onPickLocation,
                            child: const Text(
                              'Change',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColor.primaryBlue,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ] else ...[
                    const SizedBox(height: 6),
                    GestureDetector(
                      onTap: onPickLocation,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4),
                        child: Row(
                          children: [
                            Icon(
                              Icons.touch_app_outlined,
                              size: 14,
                              color: AppColor.primaryBlue,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Pick company pin on map for Near Me Peers',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColor.primaryBlue,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 14),
                  AppTextField(
                    controller: referralController,
                    hintText: 'Referral code (optional)',
                    prefixIcon: const Icon(
                      Icons.card_giftcard_outlined,
                      size: 20,
                    ),
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
