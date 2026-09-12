import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/timeline_item_entity.dart';
import 'timeline_author_row.dart';
import 'timeline_interaction_bar.dart';
import 'timeline_media_viewer.dart';

class TimelineStandardCard extends StatefulWidget {
  final TimelineItemEntity item;
  final bool autoPlay;
  final VoidCallback? onLikeTap;
  final VoidCallback? onCommentTap;
  final VoidCallback? onSaveTap;
  final VoidCallback? onShareTap;

  const TimelineStandardCard({
    super.key,
    required this.item,
    this.autoPlay = true,
    this.onLikeTap,
    this.onCommentTap,
    this.onSaveTap,
    this.onShareTap,
  });

  @override
  State<TimelineStandardCard> createState() => _TimelineStandardCardState();
}

class _TimelineStandardCardState extends State<TimelineStandardCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor = isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary;
    final item = widget.item;
    final hasMedia = item.media.isNotEmpty;

    return Container(
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
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: TimelineAuthorRow(
              author: item.author,
              createdAt: item.createdAt,
            ),
          ),
          if (item.contentText.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: _buildContentText(primaryTextColor),
            ),
          ],
          if (hasMedia) ...[
            const SizedBox(height: 12),
            // Media fills full card width, no horizontal padding
            TimelineMediaViewer(
              media: item.media.first,
              autoPlay: widget.autoPlay,
            ),
          ],
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: TimelineInteractionBar(
              likesCount: item.likesCount,
              commentsCount: item.commentsCount,
              savesCount: item.savesCount,
              isLiked: item.isLikedByMe,
              isSaved: item.isSaved,
              onLikeTap: widget.onLikeTap,
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
          style: AppTypography.bodyLarge.copyWith(color: textColor),
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
                style: AppTypography.bodySmall.copyWith(
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
