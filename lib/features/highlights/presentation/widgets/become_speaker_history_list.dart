import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/speaker_submission_entity.dart';

class BecomeSpeakerHistoryList extends StatelessWidget {
  final List<SpeakerSubmissionEntity> submissions;
  final bool isLoading;

  const BecomeSpeakerHistoryList({
    super.key,
    required this.submissions,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (isLoading) {
      return const Center(child: CircularProgressIndicator(strokeWidth: 2));
    }

    if (submissions.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.record_voice_over_outlined,
              size: 44,
              color: isDark
                  ? AppColor.darkTextSecondary
                  : AppColor.lightTextSecondary,
            ),
            const SizedBox(height: 10),
            Text(
              'No Speaker Submissions Yet',
              style: AppTypography.titleMedium.copyWith(
                fontWeight: FontWeight.w500,
                color: isDark
                    ? AppColor.darkTextPrimary
                    : AppColor.lightTextPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Your submitted speaker applications will appear here.',
              style: AppTypography.bodySmall.copyWith(
                fontWeight: FontWeight.w500,
                color: isDark
                    ? AppColor.darkTextSecondary
                    : AppColor.lightTextSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      itemCount: submissions.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final item = submissions[index];
        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isDark ? AppColor.darkSurface : AppColor.lightSurface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark ? AppColor.darkBorder : AppColor.lightBorder,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item.fullName.isNotEmpty
                        ? item.fullName
                        : 'Speaker Application',
                    style: AppTypography.titleSmall.copyWith(
                      fontWeight: FontWeight.w500,
                      color: isDark
                          ? AppColor.darkTextPrimary
                          : AppColor.lightTextPrimary,
                    ),
                  ),
                  // Container(
                  //   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  //   decoration: BoxDecoration(color: AppColor.primaryBlue.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(6)),
                  //   child: Text(item.status ?? 'Pending', style: AppTypography.labelSmall.copyWith(fontWeight: FontWeight.w500, color: AppColor.primaryBlue)),
                  // ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                '${item.designation} at ${item.company}',
                style: AppTypography.bodySmall.copyWith(
                  fontWeight: FontWeight.w500,
                  color: isDark
                      ? AppColor.darkTextPrimary
                      : AppColor.lightTextPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Topics: ${item.topicExpertise}',
                style: AppTypography.bodySmall.copyWith(
                  fontWeight: FontWeight.w500,
                  color: isDark
                      ? AppColor.darkTextSecondary
                      : AppColor.lightTextSecondary,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
