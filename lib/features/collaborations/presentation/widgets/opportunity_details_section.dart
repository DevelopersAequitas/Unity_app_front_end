import 'package:flutter/material.dart';
import '../../../highlights/presentation/widgets/highlight_text_field.dart';

class OpportunityDetailsSection extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController descriptionController;

  const OpportunityDetailsSection({
    super.key,
    required this.titleController,
    required this.descriptionController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HighlightTextField(
          controller: titleController,
          label: 'Opportunity Title *',
          hint: 'e.g. Looking for export partner required for UAE market',
          validator: (val) {
            final text = val?.trim() ?? '';
            if (text.isEmpty) return 'Please enter an opportunity title';
            if (text.length > 80) return 'Title must be 80 characters or less';
            return null;
          },
        ),
        const SizedBox(height: 14),
        HighlightTextField(
          controller: descriptionController,
          label: 'Describe Your Opportunity *',
          hint: 'Explain your business, current stage, and what you expect from collaborator.',
          maxLines: 4,
          validator: (val) => (val?.trim() ?? '').isEmpty ? 'Please describe your opportunity' : null,
        ),
      ],
    );
  }
}
