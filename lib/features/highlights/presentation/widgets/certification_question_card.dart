import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/certification_question_entity.dart';

class CertificationQuestionCard extends StatelessWidget {
  final int questionIndex;
  final int totalQuestions;
  final CertificationQuestionEntity question;
  final String? selectedAnswer;
  final ValueChanged<String> onSelectAnswer;

  const CertificationQuestionCard({
    super.key,
    required this.questionIndex,
    required this.totalQuestions,
    required this.question,
    required this.selectedAnswer,
    required this.onSelectAnswer,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDark ? AppColor.darkSurface : AppColor.lightSurface;
    final borderColor = isDark ? AppColor.darkBorder : AppColor.lightBorder;
    final primaryTextColor = isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary;
    final secondaryTextColor = isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColor.primaryBlue.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Q$questionIndex of $totalQuestions',
                  style: AppTypography.labelSmall.copyWith(color: AppColor.primaryBlue, fontWeight: FontWeight.w500),
                ),
              ),
              const Spacer(),
              if (selectedAnswer != null)
                const Icon(Icons.check_circle_rounded, color: AppColor.success, size: 18),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            question.question,
            style: AppTypography.titleSmall.copyWith(
              fontWeight: FontWeight.w500,
              color: primaryTextColor,
            ),
          ),
          const SizedBox(height: 12),
          ...question.options.map((option) {
            final isSelected = selectedAnswer == option;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: InkWell(
                onTap: () => onSelectAnswer(option),
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColor.primaryBlue.withValues(alpha: isDark ? 0.15 : 0.08)
                        : (isDark ? AppColor.darkBackground : AppColor.lightBackground),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected ? AppColor.primaryBlue : borderColor,
                      width: isSelected ? 1.5 : 1.0,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                        color: isSelected ? AppColor.primaryBlue : secondaryTextColor,
                        size: 18,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          option,
                          style: AppTypography.bodySmall.copyWith(
                            color: isSelected ? AppColor.primaryBlue : primaryTextColor,
                            fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
