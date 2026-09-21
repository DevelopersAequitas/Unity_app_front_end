import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/certification_question_entity.dart';
import 'certification_question_card.dart';

class LeadershipQuestionnairePager extends StatelessWidget {
  final List<CertificationQuestionEntity> questions;
  final int currentStep;
  final Map<String, String> answers;
  final ValueChanged<int> onStepChanged;
  final ValueChanged<String> onSelectAnswer;
  final VoidCallback onSubmit;
  final bool isSubmitting;

  const LeadershipQuestionnairePager({
    super.key,
    required this.questions,
    required this.currentStep,
    required this.answers,
    required this.onStepChanged,
    required this.onSelectAnswer,
    required this.onSubmit,
    this.isSubmitting = false,
  });

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    final safeStep = currentStep.clamp(0, questions.length - 1);
    final currentQ = questions[safeStep];
    final progress = (safeStep + 1) / questions.length;
    final isLast = safeStep == questions.length - 1;
    final currentAnswer = answers[currentQ.field];
    final isAnswered = currentAnswer != null && currentAnswer.isNotEmpty;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Question ${safeStep + 1} of ${questions.length}',
                style: AppTypography.labelMedium.copyWith(
                  color: AppColor.primaryBlue,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '${(progress * 100).toInt()}% Completed',
                style: AppTypography.labelSmall.copyWith(
                  color: AppColor.lightTextSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: AppColor.primaryBlue.withValues(alpha: 0.12),
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColor.primaryBlue,
              ),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 14),
          CertificationQuestionCard(
            questionIndex: safeStep + 1,
            totalQuestions: questions.length,
            question: currentQ,
            selectedAnswer: currentAnswer,
            onSelectAnswer: (ans) {
              onSelectAnswer(ans);
              if (!isLast && safeStep < questions.length - 1) {
                Future.delayed(const Duration(milliseconds: 250), () {
                  onStepChanged(safeStep + 1);
                });
              }
            },
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              if (safeStep > 0)
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => onStepChanged(safeStep - 1),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Previous'),
                  ),
                ),
              if (safeStep > 0) const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: isSubmitting || !isAnswered
                      ? null
                      : isLast
                      ? onSubmit
                      : () => onStepChanged(safeStep + 1),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primaryBlue,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: AppColor.lightBorder,
                    disabledForegroundColor: AppColor.lightTextDisabled,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: isSubmitting
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(isLast ? 'Review & Submit' : 'Next Question'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
