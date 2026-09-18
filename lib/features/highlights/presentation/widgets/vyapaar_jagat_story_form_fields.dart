import 'package:flutter/material.dart';
import 'highlight_text_field.dart';

class VyapaarJagatStoryFormFields extends StatelessWidget {
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

  const VyapaarJagatStoryFormFields({
    super.key,
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
                controller: fullNameController,
                label: 'Full Name *',
                hint: 'e.g. Rahul Sharma',
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: HighlightTextField(
                controller: designationController,
                label: 'Designation *',
                hint: 'e.g. Founder & CEO',
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: HighlightTextField(
                controller: companyNameController,
                label: 'Company Name *',
                hint: 'e.g. Acme Tech',
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: HighlightTextField(
                controller: websiteController,
                label: 'Website *',
                hint: 'https://acme.com',
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        HighlightTextField(
          controller: journeyController,
          label: 'Entrepreneurial Journey *',
          hint: 'How did your entrepreneurial journey start?',
          maxLines: 3,
          validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
        ),
        const SizedBox(height: 16),
        HighlightTextField(
          controller: businessDescController,
          label: 'Business Description *',
          hint: 'What does your business do and solve?',
          maxLines: 3,
          validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
        ),
        const SizedBox(height: 16),
        HighlightTextField(
          controller: challengeController,
          label: 'Biggest Challenge *',
          hint: 'Key challenge and how it was overcome',
          maxLines: 2,
          validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
        ),
        const SizedBox(height: 16),
        HighlightTextField(
          controller: achievementController,
          label: 'Biggest Achievement *',
          hint: 'Milestones, awards, or proud moments...',
          maxLines: 2,
          validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
        ),
        const SizedBox(height: 16),
        HighlightTextField(
          controller: impactController,
          label: 'Business Impact *',
          hint: 'Lives impacted or jobs created...',
          maxLines: 2,
          validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
        ),
        const SizedBox(height: 16),
        HighlightTextField(
          controller: goalsController,
          label: 'Future Goals *',
          hint: 'Vision for next 3-5 years...',
          maxLines: 2,
          validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
        ),
        const SizedBox(height: 16),
        HighlightTextField(
          controller: adviceController,
          label: 'Advice for Entrepreneurs *',
          hint: 'Key lessons for fellow founders...',
          maxLines: 2,
          validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
        ),
        const SizedBox(height: 16),
        HighlightTextField(
          controller: linkedinController,
          label: 'LinkedIn Profile URL *',
          hint: 'https://linkedin.com/in/...',
          keyboardType: TextInputType.url,
          validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
        ),
      ],
    );
  }
}
