import 'package:flutter/material.dart';
import 'highlight_text_field.dart';

class BecomeMentorFormFields extends StatelessWidget {
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController cityController;
  final TextEditingController linkedinController;

  const BecomeMentorFormFields({
    super.key,
    required this.firstNameController,
    required this.lastNameController,
    required this.emailController,
    required this.phoneController,
    required this.cityController,
    required this.linkedinController,
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
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: HighlightTextField(
                controller: lastNameController,
                label: 'Last Name *',
                hint: 'e.g. Sharma',
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        HighlightTextField(
          controller: emailController,
          label: 'Email Address *',
          hint: 'e.g. mentor@example.com',
          keyboardType: TextInputType.emailAddress,
          validator: (v) {
            if (v == null || v.trim().isEmpty) return 'Email is required';
            if (!v.contains('@')) return 'Enter a valid email';
            return null;
          },
        ),
        const SizedBox(height: 12),
        HighlightTextField(
          controller: phoneController,
          label: 'Phone Number *',
          hint: 'e.g. 9876543210',
          keyboardType: TextInputType.phone,
          validator: (v) => (v == null || v.trim().isEmpty) ? 'Phone is required' : null,
        ),
        const SizedBox(height: 12),
        HighlightTextField(
          controller: cityController,
          label: 'City / Location *',
          hint: 'e.g. Mumbai, Maharashtra',
          validator: (v) => (v == null || v.trim().isEmpty) ? 'City is required' : null,
        ),
        const SizedBox(height: 12),
        HighlightTextField(
          controller: linkedinController,
          label: 'LinkedIn Profile URL *',
          hint: 'https://linkedin.com/in/...',
          keyboardType: TextInputType.url,
          validator: (v) => (v == null || v.trim().isEmpty) ? 'LinkedIn profile is required' : null,
        ),
      ],
    );
  }
}
