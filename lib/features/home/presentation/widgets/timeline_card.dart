import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/post_share_helper.dart';
import '../../../peers/presentation/bloc/peer_profile_bloc.dart';
import '../../../peers/presentation/bloc/peer_profile_event.dart';
import '../../../profile/presentation/bloc/profile_posts_bloc.dart';
import '../../../profile/presentation/bloc/profile_posts_event.dart';
import '../../domain/entities/timeline_item_entity.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import 'post_comments_bottom_sheet.dart';
import 'post_likes_bottom_sheet.dart';
import 'timeline_collaboration_card.dart';
import 'timeline_impact_card.dart';
import 'timeline_standard_card.dart';

class TimelineCard extends StatelessWidget {
  final TimelineItemEntity item;
  final bool autoPlay;
  final VoidCallback? onLikeTap;
  final VoidCallback? onLikesCountTap;
  final VoidCallback? onCommentTap;
  final VoidCallback? onSaveTap;
  final VoidCallback? onShareTap;
  final VoidCallback? onAuthorTap;

  const TimelineCard({
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

  void _handleDefaultCommentTap(BuildContext context) {
    PostCommentsBottomSheet.show(
      context,
      postId: item.id,
      totalComments: item.commentsCount,
      onCommentAdded: () {
        try {
          context.read<HomeBloc>().add(HomePostCommentCountIncremented(item.id));
        } catch (_) {}
        try {
          context.read<ProfilePostsBloc>().add(ProfilePostCommentCountIncremented(item.id));
        } catch (_) {}
        try {
          context.read<PeerProfileBloc>().add(PeerProfilePostCommentCountIncremented(item.id));
        } catch (_) {}
      },
    );
  }

  void _handleDefaultLikesTap(BuildContext context) {
    PostLikesBottomSheet.show(
      context,
      postId: item.id,
      totalLikes: item.likesCount,
    );
  }

  void _handleDefaultShareTap() {
    PostShareHelper.sharePost(item);
  }

  @override
  Widget build(BuildContext context) {
    final commentHandler = onCommentTap ?? () => _handleDefaultCommentTap(context);
    final likesHandler = onLikesCountTap ?? (item.likesCount > 0 ? () => _handleDefaultLikesTap(context) : null);
    final shareHandler = onShareTap ?? _handleDefaultShareTap;

    Widget cardWidget;
    switch (item.resolvedType) {
      case TimelineItemType.impactActivity:
        cardWidget = TimelineImpactCard(
          item: item,
          onLikeTap: onLikeTap,
          onLikesCountTap: likesHandler,
          onCommentTap: commentHandler,
          onSaveTap: onSaveTap,
          onShareTap: shareHandler,
          onAuthorTap: onAuthorTap,
        );
        break;
      case TimelineItemType.collaborationPost:
        cardWidget = TimelineCollaborationCard(
          item: item,
          onLikeTap: onLikeTap,
          onLikesCountTap: likesHandler,
          onCommentTap: commentHandler,
          onSaveTap: onSaveTap,
          onShareTap: shareHandler,
          onAuthorTap: onAuthorTap,
        );
        break;
      case TimelineItemType.lifeImpactRecognition:
      case TimelineItemType.standardPost:
        // TimelineStandardCard handles double-tap internally
        return TimelineStandardCard(
          item: item,
          autoPlay: autoPlay,
          onLikeTap: onLikeTap,
          onLikesCountTap: likesHandler,
          onCommentTap: commentHandler,
          onSaveTap: onSaveTap,
          onShareTap: shareHandler,
          onAuthorTap: onAuthorTap,
        );
    }

    // For impact/collaboration cards: wrap with double-tap gesture
    if (onLikeTap != null) {
      return GestureDetector(
        onDoubleTap: () {
          if (!item.isLikedByMe) {
            onLikeTap!();
          }
        },
        behavior: HitTestBehavior.deferToChild,
        child: cardWidget,
      );
    }

    return cardWidget;
  }
}
