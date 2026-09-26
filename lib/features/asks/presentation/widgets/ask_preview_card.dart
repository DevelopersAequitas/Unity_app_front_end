import 'package:flutter/material.dart';
import 'package:unity_app/core/theme/app_color.dart';
import '../../domain/entities/ask_submission_entity.dart';

class AskPreviewCard extends StatelessWidget {
  final AskSubmissionEntity submission;

  const AskPreviewCard({
    super.key,
    required this.submission,
  });

  String _formatList(List<String> list) {
    if (list.isEmpty) return 'None selected';
    return list
        .map((e) => e.replaceAll('_', ' ').split(' ').map((w) => w.isNotEmpty ? '${w[0].toUpperCase()}${w.substring(1)}' : '').join(' '))
        .join(', ');
  }

  String _capitalize(String? s) {
    if (s == null || s.isEmpty) return '';
    return s.replaceAll('_', ' ').split(' ').map((w) => w.isNotEmpty ? '${w[0].toUpperCase()}${w.substring(1)}' : '').join(' ');
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    final titleColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final bodyColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569);
    final isReferral = submission.flow.code.toLowerCase() == 'referral';
    final isHelp = submission.flow.code.toLowerCase() == 'help' || submission.flow.code.toLowerCase() == 'advice';
    final typeTag = submission.type.name.isNotEmpty ? submission.type.name : 'Category';
    final geoTag = submission.geography != null
        ? _capitalize(submission.geography)
        : (submission.customAnswers['referral_geography'] != null
            ? _capitalize(submission.customAnswers['referral_geography'].toString())
            : '');
    final stageTag = submission.businessStage != null ? '${_capitalize(submission.businessStage)} stage' : '';
    final timingTag = submission.timeline != null && submission.timeline!.isNotEmpty
        ? _capitalize(submission.timeline)
        : (submission.customAnswers['help_timing'] != null
            ? _capitalize(submission.customAnswers['help_timing'].toString())
            : '');

    final referralReason = (submission.customAnswers['referral_reason'] ?? '').toString().trim();
    final referralOffer = (submission.customAnswers['what_i_offer'] ?? '').toString().trim();

    final doneDefinition = (submission.customAnswers['done_definition'] ?? submission.expectedOutcome ?? '').toString().trim();
    final helpDuration = (submission.customAnswers['help_duration'] ?? '').toString().trim();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tags
          Wrap(
            spacing: 8,
            children: [
              _buildTag(typeTag),
              if (isHelp && timingTag.isNotEmpty) _buildAmberTag(timingTag),
              if (isReferral && geoTag.isNotEmpty) _buildTag(geoTag),
              if (!isReferral && !isHelp && stageTag.isNotEmpty) _buildTag(stageTag),
            ],
          ),
          const SizedBox(height: 14),
          // Heading / Goal
          Text(
            submission.effectiveGoal.isNotEmpty
                ? submission.effectiveGoal
                : 'Looking for ${submission.type.name} to collaborate with peers',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              letterSpacing: -0.3,
              color: titleColor,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 14),
          if (isHelp && (doneDefinition.isNotEmpty || helpDuration.isNotEmpty)) ...[
            Text(
              [
                if (doneDefinition.isNotEmpty)
                  (doneDefinition.toLowerCase().startsWith('done:') ? doneDefinition : 'Done: $doneDefinition'),
                if (helpDuration.isNotEmpty) helpDuration,
              ].join('. ') + (helpDuration.endsWith('.') ? '' : '.'),
              style: TextStyle(
                fontSize: 14.5,
                color: bodyColor,
                height: 1.45,
              ),
            ),
          ] else if (isReferral && (referralReason.isNotEmpty || referralOffer.isNotEmpty)) ...[
            Text(
              [
                if (referralReason.isNotEmpty) referralReason,
                if (referralOffer.isNotEmpty)
                  (referralOffer.toLowerCase().startsWith('happy to') ||
                          referralOffer.toLowerCase().startsWith('offer') ||
                          referralOffer.toLowerCase().startsWith('can give') ||
                          referralOffer.toLowerCase().startsWith('open to'))
                      ? referralOffer
                      : 'Happy to return the favour with $referralOffer',
              ].join('. '),
              style: TextStyle(
                fontSize: 14.5,
                color: bodyColor,
                height: 1.45,
              ),
            ),
          ] else ...[
            if (submission.whatIBring.isNotEmpty) ...[
              RichText(
                text: TextSpan(
                  style: TextStyle(fontSize: 14, color: bodyColor, height: 1.4),
                  children: [
                    TextSpan(
                      text: 'I bring: ',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: titleColor,
                      ),
                    ),
                    TextSpan(text: _formatList(submission.whatIBring)),
                  ],
                ),
              ),
              const SizedBox(height: 6),
            ],
            if (submission.whatINeed.isNotEmpty) ...[
              RichText(
                text: TextSpan(
                  style: TextStyle(fontSize: 14, color: bodyColor, height: 1.4),
                  children: [
                    TextSpan(
                      text: 'I need: ',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: titleColor,
                      ),
                    ),
                    TextSpan(text: _formatList(submission.whatINeed)),
                  ],
                ),
              ),
              const SizedBox(height: 6),
            ],
            // Custom dynamic answers (for Help, etc.)
            ...submission.customAnswers.entries
                .where((e) =>
                    e.key != 'referral_reason' &&
                    e.key != 'what_i_offer' &&
                    e.key != 'who_to_meet' &&
                    e.key != 'referral_geography' &&
                    e.key != 'referral_industry' &&
                    e.value != null &&
                    e.value.toString().trim().isNotEmpty)
                .map((e) {
              final label = _capitalize(e.key);
              final value = e.value is List ? _formatList(List<String>.from(e.value)) : e.value.toString();
              return Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(fontSize: 14, color: bodyColor, height: 1.4),
                    children: [
                      TextSpan(
                        text: '$label: ',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: titleColor,
                        ),
                      ),
                      TextSpan(text: value),
                    ],
                  ),
                ),
              );
            }),
          ],
        ],
      ),
    );
  }

  Widget _buildTag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4.5),
      decoration: BoxDecoration(
        color: AppColor.badgeBlueBg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColor.primaryBlue,
        ),
      ),
    );
  }

  Widget _buildAmberTag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4.5),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF3C7),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Color(0xFFB45309),
        ),
      ),
    );
  }
}
