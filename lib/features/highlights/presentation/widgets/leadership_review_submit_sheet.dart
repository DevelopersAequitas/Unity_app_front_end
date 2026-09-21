import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import 'certification_personal_info_card.dart';

class LeadershipReviewSubmitSheet extends StatelessWidget {
  final TextEditingController fullNameController;
  final TextEditingController businessNameController;
  final TextEditingController emailController;
  final TextEditingController contactController;
  final int answeredCount;
  final int totalQuestions;
  final bool isSubmitting;
  final VoidCallback onConfirmSubmit;

  const LeadershipReviewSubmitSheet({
    super.key,
    required this.fullNameController,
    required this.businessNameController,
    required this.emailController,
    required this.contactController,
    required this.answeredCount,
    required this.totalQuestions,
    required this.isSubmitting,
    required this.onConfirmSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDark ? AppColor.darkSurface : AppColor.lightSurface;

    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColor.lightBorder,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Confirm & Submit',
                  style: AppTypography.titleMedium.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: answeredCount == totalQuestions
                        ? AppColor.success.withValues(alpha: 0.12)
                        : AppColor.warning.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '$answeredCount / $totalQuestions Answered',
                    style: AppTypography.labelSmall.copyWith(
                      color: answeredCount == totalQuestions
                          ? AppColor.success
                          : AppColor.warning,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            CertificationPersonalInfoCard(
              fullNameController: fullNameController,
              businessNameController: businessNameController,
              emailController: emailController,
              contactController: contactController,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 46,
              child: ElevatedButton(
                onPressed: isSubmitting ? null : onConfirmSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primaryBlue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: isSubmitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Confirm & Submit Assessment'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
