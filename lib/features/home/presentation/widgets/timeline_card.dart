import 'package:flutter/material.dart';
import '../../domain/entities/timeline_item_entity.dart';
import 'timeline_collaboration_card.dart';
import 'timeline_impact_card.dart';
import 'timeline_standard_card.dart';

class TimelineCard extends StatelessWidget {
  final TimelineItemEntity item;
  final bool autoPlay;
  final VoidCallback? onLikeTap;
  final VoidCallback? onCommentTap;
  final VoidCallback? onSaveTap;
  final VoidCallback? onShareTap;

  const TimelineCard({
    super.key,
    required this.item,
    this.autoPlay = true,
    this.onLikeTap,
    this.onCommentTap,
    this.onSaveTap,
    this.onShareTap,
  });

  @override
  Widget build(BuildContext context) {
    switch (item.resolvedType) {
      case TimelineItemType.impactActivity:
        return TimelineImpactCard(
          item: item,
          onLikeTap: onLikeTap,
          onCommentTap: onCommentTap,
          onSaveTap: onSaveTap,
          onShareTap: onShareTap,
        );
      case TimelineItemType.collaborationPost:
        return TimelineCollaborationCard(
          item: item,
          onLikeTap: onLikeTap,
          onCommentTap: onCommentTap,
          onSaveTap: onSaveTap,
          onShareTap: onShareTap,
        );
      case TimelineItemType.lifeImpactRecognition:
      case TimelineItemType.standardPost:
        return TimelineStandardCard(
          item: item,
          autoPlay: autoPlay,
          onLikeTap: onLikeTap,
          onCommentTap: onCommentTap,
          onSaveTap: onSaveTap,
          onShareTap: onShareTap,
        );
    }
  }
}
