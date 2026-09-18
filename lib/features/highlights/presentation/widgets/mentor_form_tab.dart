import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../bloc/mentor/mentor_state.dart';
import 'become_mentor_form_fields.dart';
import 'certification_info_banner.dart';

class MentorFormTab extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController cityController;
  final TextEditingController linkedinController;
  final MentorState state;
  final VoidCallback onSubmit;

  const MentorFormTab({
    super.key,
    required this.formKey,
    required this.firstNameController,
    required this.lastNameController,
    required this.emailController,
    required this.phoneController,
    required this.cityController,
    required this.linkedinController,
    required this.state,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final isSubmitting = state.status == MentorStatus.submitting;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const CertificationInfoBanner(
              title: 'Mentor Application',
              description: 'Share your expertise and guide aspiring entrepreneurs within the Peers Unity ecosystem.',
              icon: Icons.workspace_premium_rounded,
            ),
            const SizedBox(height: 14),
            BecomeMentorFormFields(
              firstNameController: firstNameController,
              lastNameController: lastNameController,
              emailController: emailController,
              phoneController: phoneController,
              cityController: cityController,
              linkedinController: linkedinController,
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
