import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/app_date_formatter.dart';
import '../../domain/entities/leadership_certification_result_entity.dart';

class LeadershipUnderReviewCard extends StatelessWidget {
  final LeadershipCertificationResultEntity? submission;
  final VoidCallback? onViewHistory;
  final Future<void> Function()? onRefresh;

  const LeadershipUnderReviewCard({
    super.key,
    this.submission,
    this.onViewHistory,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDark ? AppColor.darkSurface : AppColor.lightSurface;
    final borderColor = isDark ? AppColor.darkBorder : AppColor.lightBorder;
    final primaryTextColor =
        isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary;
    final secondaryTextColor =
        isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary;

    Widget content = SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColor.warning.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.hourglass_top_rounded,
                size: 44,
                color: AppColor.warning,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Assessment Under Review',
              style: AppTypography.titleMedium.copyWith(
                fontWeight: FontWeight.w500,
                color: primaryTextColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your leadership certification submission is currently being evaluated. You will be notified once the review is completed.',
              textAlign: TextAlign.center,
              style: AppTypography.bodySmall.copyWith(
                color: secondaryTextColor,
                height: 1.4,
              ),
            ),
            if (submission != null) ...[
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColor.darkBackground
                      : AppColor.lightBackground,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildRow(
                      'Applicant',
                      submission!.fullName,
                      primaryTextColor,
                      secondaryTextColor,
                    ),
                    const SizedBox(height: 6),
                    _buildRow(
                      'Business',
                      submission!.businessName,
                      primaryTextColor,
                      secondaryTextColor,
                    ),
                    if (submission!.createdAt != null) ...[
                      const SizedBox(height: 6),
                      _buildRow(
                        'Submitted',
                        AppDateFormatter.format(submission!.createdAt),
                        primaryTextColor,
                        secondaryTextColor,
                      ),
                    ],
                  ],
                ),
              ),
            ],
            const SizedBox(height: 16),
            if (onRefresh != null)
              SizedBox(
                width: double.infinity,
                height: 44,
                child: ElevatedButton.icon(
                  onPressed: () => onRefresh!(),
                  icon: const Icon(Icons.refresh_rounded, size: 18),
                  label: const Text('Check Status'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primaryBlue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            if (onRefresh != null) const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: OutlinedButton(
                onPressed: onViewHistory,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColor.primaryBlue,
                  side: const BorderSide(color: AppColor.primaryBlue),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('View Submissions History'),
              ),
            ),
          ],
        ),
      ),
    );

    if (onRefresh != null) {
      return RefreshIndicator(onRefresh: onRefresh!, child: content);
    }
    return content;
  }

  Widget _buildRow(
    String label,
    String val,
    Color primaryColor,
    Color secondaryColor,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTypography.labelSmall.copyWith(color: secondaryColor),
        ),
        Text(
          val,
          style: AppTypography.bodySmall.copyWith(
            color: primaryColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
