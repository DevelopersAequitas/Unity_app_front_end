import 'package:flutter/material.dart';
import 'highlight_text_field.dart';

class BecomeSpeakerFormFields extends StatelessWidget {
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

  const BecomeSpeakerFormFields({
    super.key,
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
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: HighlightTextField(
                controller: firstNameController,
                label: 'First Name *',
                hint: 'e.g. Rahul',
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: HighlightTextField(
                controller: lastNameController,
                label: 'Last Name *',
                hint: 'e.g. Sharma',
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        HighlightTextField(
          controller: emailController,
          label: 'Email Address *',
          hint: 'e.g. speaker@example.com',
          keyboardType: TextInputType.emailAddress,
          validator: (v) =>
              (v == null || !v.contains('@')) ? 'Valid email required' : null,
        ),
        const SizedBox(height: 12),
        HighlightTextField(
          controller: phoneController,
          label: 'Phone Number *',
          hint: 'e.g. 9876543210',
          keyboardType: TextInputType.phone,
          validator: (v) =>
              (v == null || v.trim().isEmpty) ? 'Phone is required' : null,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: HighlightTextField(
                controller: cityController,
                label: 'City *',
                hint: 'e.g. Bengaluru',
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: HighlightTextField(
                controller: companyController,
                label: 'Company *',
                hint: 'e.g. TechCorp',
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        HighlightTextField(
          controller: designationController,
          label: 'Designation / Role *',
          hint: 'e.g. Founder & CEO',
          validator: (v) => (v == null || v.trim().isEmpty)
              ? 'Designation is required'
              : null,
        ),
        const SizedBox(height: 12),
        HighlightTextField(
          controller: topicController,
          label: 'Topics to Speak On *',
          hint: 'e.g. AI Innovation, Growth Hacking',
          maxLines: 2,
          validator: (v) =>
              (v == null || v.trim().isEmpty) ? 'Topics are required' : null,
        ),
        const SizedBox(height: 12),
        HighlightTextField(
          controller: linkedinController,
          label: 'LinkedIn Profile URL *',
          hint: 'https://linkedin.com/in/...',
          keyboardType: TextInputType.url,
          validator: (v) =>
              (v == null || v.trim().isEmpty) ? 'LinkedIn is required' : null,
        ),
        const SizedBox(height: 12),
        HighlightTextField(
          controller: bioController,
          label: 'Brief Bio',
          hint: 'Tell us about your background...',
          maxLines: 2,
        ),
      ],
    );
  }
}
