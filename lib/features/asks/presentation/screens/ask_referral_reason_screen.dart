import 'package:flutter/material.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/app_common_bar.dart';
import '../../domain/entities/ask_submission_entity.dart';
import '../widgets/ask_bottom_button.dart';
import '../widgets/ask_step_header.dart';
import '../widgets/ask_text_input_group.dart';

class AskReferralReasonScreen extends StatefulWidget {
  final AskSubmissionEntity submission;

  const AskReferralReasonScreen({
    super.key,
    required this.submission,
  });

  @override
  State<AskReferralReasonScreen> createState() =>
      _AskReferralReasonScreenState();
}

class _AskReferralReasonScreenState extends State<AskReferralReasonScreen> {
  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _offerController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final reason =
        widget.submission.customAnswers['referral_reason']?.toString() ?? '';
    final offer =
        widget.submission.customAnswers['what_i_offer']?.toString() ?? '';
    _reasonController.text = reason;
    _offerController.text = offer;
  }

  @override
  void dispose() {
    _reasonController.dispose();
    _offerController.dispose();
    super.dispose();
  }

  void _onPreview() {
    final customAnswers =
        Map<String, dynamic>.from(widget.submission.customAnswers);
    if (_reasonController.text.trim().isNotEmpty) {
      customAnswers['referral_reason'] = _reasonController.text.trim();
    }
    if (_offerController.text.trim().isNotEmpty) {
      customAnswers['what_i_offer'] = _offerController.text.trim();
    }

    final updatedSubmission = widget.submission.copyWith(
      customAnswers: customAnswers,
    );

    Navigator.of(context).pushNamed(
      AppRoutes.askPreview,
      arguments: updatedSubmission,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      appBar: AppCommonBar(
        title: widget.submission.flow.name,
        showBack: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            AskStepHeader(
              title: 'Why this introduction, and what\'s in it for them?',
              subtitle: 'A short reason helps a Peer decide fast',
            ),
            const SizedBox(height: 4),
            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AskTextInputGroup(
                      label: 'Why do you want this introduction?',
                      hintText: 'One line',
                      controller: _reasonController,
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 10),
                    AskTextInputGroup(
                      label: 'What do you offer in return? (optional)',
                      hintText:
                          'Optional — reciprocity is invited, never require',
                      controller: _offerController,
                      onChanged: (_) => setState(() {}),
                    ),
                  ],
                ),
              ),
            ),
            AskBottomButton(
              label: 'Preview my Ask',
              onPressed: _reasonController.text.trim().isNotEmpty
                  ? _onPreview
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
