import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../domain/entities/timeline_item_entity.dart';
import 'post_options_bottom_sheet.dart';
import 'timeline_author_row.dart';
import 'timeline_interaction_bar.dart';
import 'timeline_media_viewer.dart';

class TimelineStandardCard extends StatefulWidget {
  final TimelineItemEntity item;
  final bool autoPlay;
  final VoidCallback? onLikeTap;
  final VoidCallback? onLikesCountTap;
  final VoidCallback? onCommentTap;
  final VoidCallback? onSaveTap;
  final VoidCallback? onShareTap;
  final VoidCallback? onAuthorTap;

  const TimelineStandardCard({
    super.key,
    required this.item,
    this.autoPlay = true,
    this.onLikeTap,
    this.onLikesCountTap,
    this.onCommentTap,
    this.onSaveTap,
    this.onShareTap,
    this.onAuthorTap,
  });

  @override
  State<TimelineStandardCard> createState() => _TimelineStandardCardState();
}

class _TimelineStandardCardState extends State<TimelineStandardCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor = isDark
        ? AppColor.darkTextPrimary
        : AppColor.lightTextPrimary;
    final item = widget.item;
    final hasMedia = item.media.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColor.darkSurface : AppColor.lightSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColor.darkBorder : AppColor.lightBorder,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 8, 14, 0),
            child: TimelineAuthorRow(
              author: item.author,
              createdAt: item.createdAt,
              onMoreTap: () => PostOptionsBottomSheet.show(context, item: item),
              onAuthorTap: widget.onAuthorTap,
            ),
          ),
          // ── Double-tap anywhere on content area to like ──
          GestureDetector(
            onDoubleTap: widget.onLikeTap,
            behavior: HitTestBehavior.translucent,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (item.contentText.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(14, 10, 14, 0),
                    child: _buildContentText(primaryTextColor),
                  ),
                ],
                if (hasMedia) ...[
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: TimelineMediaViewer(
                      media: item.media.first,
                      autoPlay: widget.autoPlay,
                      onDoubleTap: widget.onLikeTap,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
            child: TimelineInteractionBar(
              likesCount: item.likesCount,
              commentsCount: item.commentsCount,
              savesCount: item.savesCount,
              isLiked: item.isLikedByMe,
              isSaved: item.isSaved,
              onLikeTap: widget.onLikeTap,
              onLikesCountTap: widget.onLikesCountTap,
              onCommentTap: widget.onCommentTap,
              onSaveTap: widget.onSaveTap,
              onShareTap: widget.onShareTap,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentText(Color textColor) {
    final text = widget.item.contentText;
    final isLong = text.length > 160;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w400,
            height: 1.45,
            color: textColor,
          ),
          maxLines: _isExpanded ? null : 3,
          overflow: _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
        ),
        if (isLong)
          GestureDetector(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                _isExpanded ? 'Read less' : 'Read more',
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColor.primaryBlue,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
