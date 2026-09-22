import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../domain/entities/timeline_item_entity.dart';
import 'mention_text_view.dart';
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
  bool _showHeartAnimation = false;

  void _handleDoubleTapLike() {
    setState(() => _showHeartAnimation = true);
    if (!widget.item.isLikedByMe) {
      widget.onLikeTap?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor =
        isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary;
    final item = widget.item;
    final hasMedia = item.media.isNotEmpty;

    return Container(
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
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 8, 14, 0),
            child: TimelineAuthorRow(
              author: item.author,
              createdAt: item.createdAt,
              onMoreTap: () => PostOptionsBottomSheet.show(context, item: item),
              onAuthorTap: widget.onAuthorTap,
            ),
          ),
          // ── Double-tap anywhere on content area to like & trigger heart burst ──
          GestureDetector(
            onDoubleTap: _handleDoubleTapLike,
            behavior: HitTestBehavior.translucent,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (item.contentText.isNotEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(14, 10, 14, 0),
                        child: MentionTextView(
                          text: item.contentText,
                          mentions: item.mentions,
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w400,
                            height: 1.45,
                            color: primaryTextColor,
                          ),
                        ),
                      ),
                    ],
                    if (hasMedia) ...[
                      const SizedBox(height: 8),
                      TimelineMediaViewer(
                        media: item.media.first,
                        autoPlay: widget.autoPlay,
                        onDoubleTap: _handleDoubleTapLike,
                      ),
                    ],
                  ],
                ),
                if (_showHeartAnimation)
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: const Duration(milliseconds: 650),
                    curve: Curves.easeOutBack,
                    onEnd: () {
                      if (mounted) setState(() => _showHeartAnimation = false);
                    },
                    builder: (context, value, child) {
                      final scale = value <= 0.6
                          ? (value / 0.6) * 1.3
                          : 1.3 - ((value - 0.6) / 0.4) * 0.3;
                      final opacity = value >= 0.75
                          ? (1.0 - (value - 0.75) / 0.25).clamp(0.0, 1.0)
                          : 1.0;
                      return Opacity(
                        opacity: opacity,
                        child: Transform.scale(
                          scale: scale.clamp(0.0, 1.4),
                          child: const Icon(
                            Icons.favorite_rounded,
                            size: 90,
                            color: Color(0xFFFF2554),
                            shadows: [
                              Shadow(color: Color(0x77FF2554), blurRadius: 28),
                              Shadow(color: Colors.black45, blurRadius: 16),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
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
}

