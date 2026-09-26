import 'package:equatable/equatable.dart';
import 'timeline_author_entity.dart';
import 'timeline_collaboration_entity.dart';
import 'timeline_impact_entity.dart';
import 'timeline_media_entity.dart';
import 'timeline_mention_entity.dart';

enum TimelineItemType { standardPost, lifeImpactRecognition, impactActivity, collaborationPost, askPost }

class TimelineItemEntity extends Equatable {
  final String id;
  final String type; // 'post' or 'impact'
  final String? postType; // 'standard', 'life_impact_recognition', 'ask', etc.
  final String contentText;
  final bool isVerified;
  final List<TimelineMediaEntity> media;
  final List<String> tags;
  final List<TimelineMentionEntity> mentions;
  final TimelineAuthorEntity? author;
  final int likesCount;
  final int commentsCount;
  final int savesCount;
  final bool isLikedByMe;
  final bool isSaved;
  final String createdAt;
  final TimelineCollaborationEntity? acceptedBy;
  final TimelineImpactEntity? impact;
  final Map<String, dynamic>? askData;

  const TimelineItemEntity({
    required this.id,
    required this.type,
    this.postType,
    required this.contentText,
    this.isVerified = false,
    this.media = const [],
    this.tags = const [],
    this.mentions = const [],
    this.author,
    this.likesCount = 0,
    this.commentsCount = 0,
    this.savesCount = 0,
    this.isLikedByMe = false,
    this.isSaved = false,
    required this.createdAt,
    this.acceptedBy,
    this.impact,
    this.askData,
  });

  TimelineItemType get resolvedType {
    if (postType == 'ask' || askData != null) {
      return TimelineItemType.askPost;
    }
    if (type == 'impact' || impact != null) {
      return TimelineItemType.impactActivity;
    }
    if (acceptedBy != null) {
      return TimelineItemType.collaborationPost;
    }
    if (postType == 'life_impact_recognition') {
      return TimelineItemType.lifeImpactRecognition;
    }
    return TimelineItemType.standardPost;
  }

  TimelineItemEntity copyWith({
    String? contentText,
    int? likesCount,
    int? commentsCount,
    int? savesCount,
    bool? isLikedByMe,
    bool? isSaved,
    List<TimelineMentionEntity>? mentions,
    TimelineAuthorEntity? author,
  }) {
    return TimelineItemEntity(
      id: id,
      type: type,
      postType: postType,
      contentText: contentText ?? this.contentText,
      isVerified: isVerified,
      media: media,
      tags: tags,
      mentions: mentions ?? this.mentions,
      author: author ?? this.author,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ?? this.commentsCount,
      savesCount: savesCount ?? this.savesCount,
      isLikedByMe: isLikedByMe ?? this.isLikedByMe,
      isSaved: isSaved ?? this.isSaved,
      createdAt: createdAt,
      acceptedBy: acceptedBy,
      impact: impact,
    );
  }

  @override
  List<Object?> get props => [
    id,
    type,
    postType,
    contentText,
    isVerified,
    media,
    tags,
    mentions,
    author,
    likesCount,
    commentsCount,
    savesCount,
    isLikedByMe,
    isSaved,
    createdAt,
    acceptedBy,
    impact,
  ];
}

