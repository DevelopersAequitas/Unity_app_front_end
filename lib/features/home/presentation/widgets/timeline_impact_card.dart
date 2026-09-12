import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/timeline_item_entity.dart';
import 'timeline_author_row.dart';
import 'timeline_interaction_bar.dart';

class TimelineImpactCard extends StatelessWidget {
  final TimelineItemEntity item;
  final VoidCallback? onLikeTap;
  final VoidCallback? onCommentTap;
  final VoidCallback? onSaveTap;
  final VoidCallback? onShareTap;

  const TimelineImpactCard({
    super.key,
    required this.item,
    this.onLikeTap,
    this.onCommentTap,
    this.onSaveTap,
    this.onShareTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor = isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary;
    final secondaryTextColor = isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary;
    final impact = item.impact;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColor.darkSurface : AppColor.lightSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColor.darkBorder : AppColor.lightBorder,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TimelineAuthorRow(
            author: item.author,
            createdAt: item.createdAt,
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColor.success.withValues(alpha: isDark ? 0.12 : 0.06),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColor.success.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Impact Created',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColor.success,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (impact?.lifeImpacted != null && impact!.lifeImpacted > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColor.success.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${impact.lifeImpacted} Lives Impacted',
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColor.success,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                  ],
                ),
                if (impact?.action.isNotEmpty == true) ...[
                  const SizedBox(height: 8),
                  Text(
                    impact!.action,
                    style: AppTypography.bodyMedium.copyWith(
                      color: primaryTextColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
                if (impact?.impactedPeerDisplayName?.isNotEmpty == true) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        'Impacted Peer: ',
                        style: AppTypography.bodySmall.copyWith(color: secondaryTextColor),
                      ),
                      Text(
                        impact!.impactedPeerDisplayName!,
                        style: AppTypography.bodySmall.copyWith(
                          color: primaryTextColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 12),
          TimelineInteractionBar(
            likesCount: item.likesCount,
            commentsCount: item.commentsCount,
            savesCount: item.savesCount,
            isLiked: item.isLikedByMe,
            isSaved: item.isSaved,
            onLikeTap: onLikeTap,
            onCommentTap: onCommentTap,
            onSaveTap: onSaveTap,
            onShareTap: onShareTap,
          ),
        ],
      ),
    );
  }
}
