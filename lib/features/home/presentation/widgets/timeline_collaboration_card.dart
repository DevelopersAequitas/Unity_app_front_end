import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../domain/entities/timeline_item_entity.dart';
import 'mention_text_view.dart';
import 'post_options_bottom_sheet.dart';
import 'timeline_author_row.dart';
import 'timeline_interaction_bar.dart';


class TimelineCollaborationCard extends StatelessWidget {
  final TimelineItemEntity item;
  final VoidCallback? onLikeTap;
  final VoidCallback? onLikesCountTap;
  final VoidCallback? onCommentTap;
  final VoidCallback? onSaveTap;
  final VoidCallback? onShareTap;
  final VoidCallback? onAuthorTap;

  const TimelineCollaborationCard({
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
    final collab = item.acceptedBy;

    final subInfo = [
      if (collab?.companyName?.isNotEmpty == true) collab!.companyName!,
      if (collab?.city?.isNotEmpty == true) collab!.city!,
    ].join(' • ');

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
          if (item.contentText.isNotEmpty) ...[
            const SizedBox(height: 10),
            MentionTextView(
              text: item.contentText,
              mentions: item.mentions,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w400,
                height: 1.45,
                color: primaryTextColor,
              ),
            ),
          ],
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColor.primaryBlue.withValues(alpha: isDark ? 0.12 : 0.06),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColor.primaryBlue.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Collaboration Completed',
                  style: const TextStyle(
                    color: AppColor.primaryBlue,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (collab != null) ...[
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.handshake_outlined, size: 16, color: AppColor.primaryBlue),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              collab.name,
                              style: TextStyle(
                                color: primaryTextColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            if (subInfo.isNotEmpty)
                              Text(
                                subInfo,
                                style: TextStyle(
                                  color: secondaryTextColor,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                          ],
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
