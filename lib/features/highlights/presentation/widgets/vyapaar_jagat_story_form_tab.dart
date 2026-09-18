import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../bloc/vyapaar_jagat/vyapaar_jagat_state.dart';
import 'certification_info_banner.dart';
import 'vyapaar_jagat_story_form_fields.dart';
import 'vyapaar_jagat_story_status_card.dart';

class VyapaarJagatStoryFormTab extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController fullNameController;
  final TextEditingController designationController;
  final TextEditingController companyNameController;
  final TextEditingController websiteController;
  final TextEditingController journeyController;
  final TextEditingController businessDescController;
  final TextEditingController challengeController;
  final TextEditingController achievementController;
  final TextEditingController impactController;
  final TextEditingController goalsController;
  final TextEditingController adviceController;
  final TextEditingController linkedinController;
  final VyapaarJagatState state;
  final VoidCallback onSubmit;

  const VyapaarJagatStoryFormTab({
    super.key,
    required this.formKey,
    required this.fullNameController,
    required this.designationController,
    required this.companyNameController,
    required this.websiteController,
    required this.journeyController,
    required this.businessDescController,
    required this.challengeController,
    required this.achievementController,
    required this.impactController,
    required this.goalsController,
    required this.adviceController,
    required this.linkedinController,
    required this.state,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final isSubmitting = state.status == VyapaarJagatStatus.submitting;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (state.storyStatus != null)
              VyapaarJagatStoryStatusCard(storyStatus: state.storyStatus!),
            const CertificationInfoBanner(
              title: 'Publish Your Entrepreneur Story',
              description:
                  'Share your inspiring business journey with the Vyapaar Jagat editorial team for a chance to be featured in global business publications.',
              icon: Icons.auto_stories_rounded,
            ),
            const SizedBox(height: 16),
            VyapaarJagatStoryFormFields(
              fullNameController: fullNameController,
              designationController: designationController,
              companyNameController: companyNameController,
              websiteController: websiteController,
              journeyController: journeyController,
              businessDescController: businessDescController,
              challengeController: challengeController,
              achievementController: achievementController,
              impactController: impactController,
              goalsController: goalsController,
              adviceController: adviceController,
              linkedinController: linkedinController,
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
                        'Submit Story for Publication',
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
