import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/vyapaar_jagat_story_status_entity.dart';

class VyapaarJagatStoryStatusCard extends StatelessWidget {
  final VyapaarJagatStoryStatusEntity storyStatus;

  const VyapaarJagatStoryStatusCard({
    super.key,
    required this.storyStatus,
  });

  @override
  Widget build(BuildContext context) {
    if (!storyStatus.isSubmitted && storyStatus.status == null) {
      return const SizedBox.shrink();
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isPublished = (storyStatus.status ?? '').toLowerCase() == 'published';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColor.darkSurface : AppColor.lightSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isPublished
              ? AppColor.success.withValues(alpha: 0.3)
              : AppColor.primaryBlue.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isPublished ? Icons.check_circle_rounded : Icons.hourglass_top_rounded,
                size: 20,
                color: isPublished ? AppColor.success : AppColor.primaryBlue,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  isPublished ? 'Story Published!' : 'Story Under Editorial Review',
                  style: AppTypography.titleSmall.copyWith(
                    fontWeight: FontWeight.w500,
                    color: isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: (isPublished ? AppColor.success : AppColor.primaryBlue)
                      .withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  storyStatus.status ?? 'Submitted',
                  style: AppTypography.labelSmall.copyWith(
                    fontWeight: FontWeight.w500,
                    color: isPublished ? AppColor.success : AppColor.primaryBlue,
                  ),
                ),
              ),
            ],
          ),
          if (storyStatus.storyLink != null && storyStatus.storyLink!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              'Link: ${storyStatus.storyLink}',
              style: AppTypography.bodySmall.copyWith(
                fontWeight: FontWeight.w500,
                color: AppColor.primaryBlue,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
