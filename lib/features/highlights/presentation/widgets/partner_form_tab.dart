import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../bloc/partner_with_us/partner_with_us_state.dart';
import 'certification_info_banner.dart';
import 'partner_with_us_form_fields.dart';

class PartnerFormTab extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController phoneController;
  final TextEditingController emailController;
  final TextEditingController cityController;
  final TextEditingController brandController;
  final TextEditingController websiteController;
  final TextEditingController industryController;
  final TextEditingController aboutBusinessController;
  final TextEditingController partnershipGoalController;
  final TextEditingController whyPartnerController;
  final PartnerWithUsState state;
  final VoidCallback onSubmit;

  const PartnerFormTab({
    super.key,
    required this.formKey,
    required this.firstNameController,
    required this.lastNameController,
    required this.phoneController,
    required this.emailController,
    required this.cityController,
    required this.brandController,
    required this.websiteController,
    required this.industryController,
    required this.aboutBusinessController,
    required this.partnershipGoalController,
    required this.whyPartnerController,
    required this.state,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final isSubmitting = state.status == PartnerWithUsStatus.submitting;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const CertificationInfoBanner(
              title: 'Strategic Partnership',
              description:
                  'Join forces with Peers Global to create mutual business growth, co-host events, and expand your community reach.',
              icon: Icons.handshake_rounded,
            ),
            const SizedBox(height: 16),
            PartnerWithUsFormFields(
              firstNameController: firstNameController,
              lastNameController: lastNameController,
              phoneController: phoneController,
              emailController: emailController,
              cityController: cityController,
              brandController: brandController,
              websiteController: websiteController,
              industryController: industryController,
              aboutBusinessController: aboutBusinessController,
              partnershipGoalController: partnershipGoalController,
              whyPartnerController: whyPartnerController,
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: isSubmitting ? null : onSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primaryBlue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: isSubmitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : Text(
                        'Submit Partnership Proposal',
                        style: AppTypography.labelLarge.copyWith(
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
