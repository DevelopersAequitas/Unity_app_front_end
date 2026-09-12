import 'package:flutter/material.dart';
import '../bloc/register_state.dart';
import 'register_step1_view.dart';
import 'register_step2_view.dart';

class RegisterStepSwitcher extends StatelessWidget {
  final PageController pageController;
  final RegisterState state;
  final bool isLoading;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final String countryCode;
  final ValueChanged<String> onCountryCodeChanged;
  final TextEditingController companyNameController;
  final TextEditingController companyAddressController;
  final TextEditingController otherCategoryController;
  final TextEditingController referralController;
  final String? mainCategoryName;
  final String? categoryName;
  final bool isOtherCategory;
  final String? city;
  final String? dob;
  final String? profilePhotoPath;
  final double? latitude;
  final double? longitude;
  final VoidCallback onSelectMainCategory;
  final VoidCallback onSelectCategory;
  final VoidCallback onSelectCity;
  final VoidCallback onSelectDob;
  final VoidCallback onSelectPhoto;
  final VoidCallback onPickLocation;
  final VoidCallback onContinueStep1;
  final VoidCallback onCreateAccount;

  const RegisterStepSwitcher({
    super.key,
    required this.pageController,
    required this.state,
    required this.isLoading,
    required this.firstNameController,
    required this.lastNameController,
    required this.emailController,
    required this.phoneController,
    required this.countryCode,
    required this.onCountryCodeChanged,
    required this.companyNameController,
    required this.companyAddressController,
    required this.otherCategoryController,
    required this.referralController,
    this.mainCategoryName,
    this.categoryName,
    this.isOtherCategory = false,
    this.city,
    this.dob,
    this.profilePhotoPath,
    this.latitude,
    this.longitude,
    required this.onSelectMainCategory,
    required this.onSelectCategory,
    required this.onSelectCity,
    required this.onSelectDob,
    required this.onSelectPhoto,
    required this.onPickLocation,
    required this.onContinueStep1,
    required this.onCreateAccount,
  });

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: pageController,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        RegisterStep1View(
          firstNameController: firstNameController,
          lastNameController: lastNameController,
          emailController: emailController,
          phoneController: phoneController,
          countryCode: countryCode,
          dob: dob,
          city: city,
          profilePhotoPath: profilePhotoPath,
          onCountryCodeChanged: onCountryCodeChanged,
          onSelectDob: onSelectDob,
          onSelectCity: onSelectCity,
          onSelectPhoto: onSelectPhoto,
          onContinue: onContinueStep1,
        ),
        RegisterStep2View(
          companyNameController: companyNameController,
          companyAddressController: companyAddressController,
          otherCategoryController: otherCategoryController,
          referralController: referralController,
          mainCategoryName: mainCategoryName,
          categoryName: categoryName,
          isOtherCategory: isOtherCategory,
          latitude: latitude,
          longitude: longitude,
          isLoading: isLoading,
          onSelectMainCategory: onSelectMainCategory,
          onSelectCategory: onSelectCategory,
          onPickLocation: onPickLocation,
          onCreateAccount: onCreateAccount,
        ),
      ],
    );
  }
}
