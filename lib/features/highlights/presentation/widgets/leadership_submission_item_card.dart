import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/app_date_formatter.dart';
import '../../domain/entities/leadership_certification_result_entity.dart';
import 'certificate_share_helper.dart';

class LeadershipSubmissionItemCard extends StatelessWidget {
  final LeadershipCertificationResultEntity item;
  final ValueChanged<LeadershipCertificationResultEntity> onViewCertificate;
  final VoidCallback onRetake;
  final bool canRetake;

  const LeadershipSubmissionItemCard({
    super.key,
    required this.item,
    required this.onViewCertificate,
    required this.onRetake,
    this.canRetake = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor =
        isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary;
    final secondaryTextColor =
        isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary;

    final rawStatus = item.status.toLowerCase().replaceAll(' ', '_');
    final isApproved = rawStatus == 'approved' ||
        rawStatus == 'passed' ||
        rawStatus == 'success';
    final isRejected = rawStatus == 'rejected' ||
        rawStatus == 'reject' ||
        rawStatus == 'failed' ||
        rawStatus == 'declined';
    final isUnderReview = !isApproved && !isRejected;

    final score = item.totalScore ?? 0;
    final percentage = item.percentage ?? 0;

    final statusColor = isApproved
        ? AppColor.success
        : isRejected
        ? AppColor.error
        : AppColor.warning;

    final statusLabel = isApproved
        ? 'APPROVED'
        : isRejected
        ? 'REJECTED'
        : 'IN REVIEW';

    final dateStr = AppDateFormatter.format(item.createdAt);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [AppColor.darkSurface, AppColor.darkSurfaceSubtle]
              : [AppColor.lightSurface, const Color(0xFFF8FAFC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isApproved
              ? AppColor.success.withValues(alpha: 0.3)
              : isDark
              ? AppColor.darkBorder
              : AppColor.lightBorder,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 4,
                color: statusColor,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: statusColor.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              statusLabel,
                              style: AppTypography.labelSmall.copyWith(
                                color: statusColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 10,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              item.certificationLevel ?? 'Leadership Assessment',
                              style: AppTypography.titleSmall.copyWith(
                                color: primaryTextColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (dateStr.isNotEmpty) ...[
                            const SizedBox(width: 4),
                            Text(
                              dateStr,
                              style: AppTypography.labelSmall.copyWith(
                                color: secondaryTextColor,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppColor.darkBackground
                                  : const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'Score: $score/100 ($percentage%)',
                              style: AppTypography.bodySmall.copyWith(
                                color: primaryTextColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 11,
                              ),
                            ),
                          ),
                          _buildCompactActions(
                            context: context,
                            isApproved: isApproved,
                            isRejected: isRejected,
                            isUnderReview: isUnderReview,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompactActions({
    required BuildContext context,
    required bool isApproved,
    required bool isRejected,
    required bool isUnderReview,
  }) {
    if (isApproved) {
      final hasCert =
          item.certificateUrl != null && item.certificateUrl!.isNotEmpty;
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (hasCert)
            SizedBox(
              height: 28,
              child: TextButton.icon(
                onPressed: () => onViewCertificate(item),
                icon: const Icon(Icons.workspace_premium_outlined, size: 14),
                label: const Text('View'),
                style: TextButton.styleFrom(
                  foregroundColor: AppColor.primaryBlue,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          if (hasCert)
            SizedBox(
              width: 28,
              height: 28,
              child: IconButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  CertificateShareHelper.shareCertificate(
                    context: context,
                    title: 'Leadership Certification',
                    tier: item.certificationLevel ?? 'Established Leader',
                    certificateUrl: item.certificateUrl!,
                    score: item.totalScore,
                    percentage: item.percentage,
                  );
                },
                icon: const Icon(Icons.share_rounded, size: 14, color: AppColor.primaryBlue),
                tooltip: 'Share',
              ),
            ),
        ],
      );
    }

    if (isRejected) {
      if (!canRetake) {
        return const SizedBox.shrink();
      }
      return SizedBox(
        height: 28,
        child: OutlinedButton.icon(
          onPressed: onRetake,
          icon: const Icon(Icons.refresh_rounded, size: 14),
          label: const Text('Retake'),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColor.warning,
            side: const BorderSide(color: AppColor.warning, width: 1),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppColor.warning.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.schedule_rounded, size: 12, color: AppColor.warning),
          const SizedBox(width: 4),
          Text(
            'In Review',
            style: AppTypography.labelSmall.copyWith(
              color: AppColor.warning,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
