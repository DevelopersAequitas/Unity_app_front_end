import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../domain/entities/timeline_item_entity.dart';
import 'post_options_bottom_sheet.dart';
import 'timeline_author_row.dart';
import 'timeline_interaction_bar.dart';

class TimelineImpactCard extends StatelessWidget {
  final TimelineItemEntity item;
  final VoidCallback? onLikeTap;
  final VoidCallback? onLikesCountTap;
  final VoidCallback? onCommentTap;
  final VoidCallback? onSaveTap;
  final VoidCallback? onShareTap;
  final VoidCallback? onAuthorTap;

  const TimelineImpactCard({
    super.key,
    required this.item,
    this.onLikeTap,
    this.onLikesCountTap,
    this.onCommentTap,
    this.onSaveTap,
    this.onShareTap,
    this.onAuthorTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor = isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary;
    final secondaryTextColor = isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary;
    final impact = item.impact;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColor.darkSurface : Colors.white,
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppColor.darkBorder : AppColor.lightBorder,
            width: 0.8,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TimelineAuthorRow(
            author: item.author,
            createdAt: item.createdAt,
            onMoreTap: () => PostOptionsBottomSheet.show(context, item: item),
            onAuthorTap: onAuthorTap,
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
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
                      style: const TextStyle(
                        color: AppColor.success,
                        fontSize: 10.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (impact?.lifeImpacted != null && impact!.lifeImpacted > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColor.success.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${impact.lifeImpacted} Lives Impacted',
                          style: const TextStyle(
                            color: AppColor.success,
                            fontSize: 9.5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                  ],
                ),
                if (impact?.action.isNotEmpty == true) ...[
                  const SizedBox(height: 6),
                  Text(
                    impact!.action,
                    style: TextStyle(
                      color: primaryTextColor,
                      fontSize: 11.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
                if (impact?.impactedPeerDisplayName?.isNotEmpty == true) ...[
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        'Impacted Peer: ',
                        style: TextStyle(color: secondaryTextColor, fontSize: 10.5, fontWeight: FontWeight.w400),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (impact?.impactedPeerId?.isNotEmpty == true) {
                            Navigator.pushNamed(context, '/peer-profile', arguments: impact!.impactedPeerId);
                          }
                        },
                        child: ShaderMask(
                          blendMode: BlendMode.srcIn,
                          shaderCallback: (bounds) => AppColor.brandGradient.createShader(
                            Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                          ),
                          child: Text(
                            (impact?.impactedPeerDisplayName ?? '').toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 10),
          TimelineInteractionBar(
            likesCount: item.likesCount,
            commentsCount: item.commentsCount,
            savesCount: item.savesCount,
            isLiked: item.isLikedByMe,
            isSaved: item.isSaved,
            onLikeTap: onLikeTap,
            onLikesCountTap: onLikesCountTap,
            onCommentTap: onCommentTap,
            onSaveTap: onSaveTap,
            onShareTap: onShareTap,
          ),
        ],
      ),
    );
  }
}
