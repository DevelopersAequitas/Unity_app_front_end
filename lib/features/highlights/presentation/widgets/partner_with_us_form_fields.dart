import 'package:flutter/material.dart';
import 'highlight_text_field.dart';

class PartnerWithUsFormFields extends StatelessWidget {
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

  const PartnerWithUsFormFields({
    super.key,
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
        const SizedBox(height: 16),
        HighlightTextField(
          controller: phoneController,
          label: 'Mobile Number *',
          hint: 'e.g. +91 98765 43210',
          keyboardType: TextInputType.phone,
          validator: (v) => (v == null || v.trim().isEmpty) ? 'Phone is required' : null,
        ),
        const SizedBox(height: 16),
        HighlightTextField(
          controller: emailController,
          label: 'Email ID *',
          hint: 'e.g. partner@example.com',
          keyboardType: TextInputType.emailAddress,
          validator: (v) => (v == null || v.trim().isEmpty) ? 'Email is required' : null,
        ),
        const SizedBox(height: 16),
        HighlightTextField(
          controller: cityController,
          label: 'City *',
          hint: 'e.g. Ahmedabad, Gujarat',
          validator: (v) => (v == null || v.trim().isEmpty) ? 'City is required' : null,
        ),
        const SizedBox(height: 16),
        HighlightTextField(
          controller: brandController,
          label: 'Brand / Company Name *',
          hint: 'e.g. Nexus Enterprises',
          validator: (v) => (v == null || v.trim().isEmpty) ? 'Company name is required' : null,
        ),
        const SizedBox(height: 16),
        HighlightTextField(
          controller: websiteController,
          label: 'Website / Social Media Link *',
          hint: 'https://nexus.com',
          keyboardType: TextInputType.url,
          validator: (v) => (v == null || v.trim().isEmpty) ? 'Link is required' : null,
        ),
        const SizedBox(height: 16),
        HighlightTextField(
          controller: industryController,
          label: 'Industry *',
          hint: 'e.g. Information Technology / Fintech',
          validator: (v) => (v == null || v.trim().isEmpty) ? 'Industry is required' : null,
        ),
        const SizedBox(height: 16),
        HighlightTextField(
          controller: aboutBusinessController,
          label: 'About Your Business *',
          hint: 'Overview of your products/services...',
          maxLines: 3,
          validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
        ),
        const SizedBox(height: 16),
        HighlightTextField(
          controller: partnershipGoalController,
          label: 'Partnership Goal *',
          hint: 'What do you aim to achieve together with Peers Global?',
          maxLines: 2,
          validator: (v) => (v == null || v.trim().isEmpty) ? 'Goal is required' : null,
        ),
        const SizedBox(height: 16),
        HighlightTextField(
          controller: whyPartnerController,
          label: 'Why Partner with Peers Global? *',
          hint: 'Share your vision for collaborating with our ecosystem...',
          maxLines: 2,
          validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
        ),
      ],
    );
  }
}
