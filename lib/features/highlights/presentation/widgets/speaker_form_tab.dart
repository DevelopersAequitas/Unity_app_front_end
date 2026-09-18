import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../bloc/speaker/speaker_state.dart';
import 'become_speaker_form_fields.dart';
import 'certification_info_banner.dart';

class SpeakerFormTab extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController cityController;
  final TextEditingController companyController;
  final TextEditingController designationController;
  final TextEditingController topicController;
  final TextEditingController linkedinController;
  final TextEditingController bioController;
  final SpeakerState state;
  final VoidCallback onSubmit;

  const SpeakerFormTab({
    super.key,
    required this.formKey,
    required this.firstNameController,
    required this.lastNameController,
    required this.emailController,
    required this.phoneController,
    required this.cityController,
    required this.companyController,
    required this.designationController,
    required this.topicController,
    required this.linkedinController,
    required this.bioController,
    required this.state,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final isSubmitting = state.status == SpeakerStatus.submitting;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const CertificationInfoBanner(
              title: 'Speaker Application',
              description: 'Share your story and insights on stage at Peers Unity conferences and meetups.',
              icon: Icons.mic_rounded,
            ),
            const SizedBox(height: 14),
            BecomeSpeakerFormFields(
              firstNameController: firstNameController,
              lastNameController: lastNameController,
              emailController: emailController,
              phoneController: phoneController,
              cityController: cityController,
              companyController: companyController,
              designationController: designationController,
              topicController: topicController,
              linkedinController: linkedinController,
              bioController: bioController,
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 46,
              child: ElevatedButton(
                onPressed: isSubmitting ? null : onSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primaryBlue,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: isSubmitting
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : Text('Submit Application', style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.w500, color: Colors.white)),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
