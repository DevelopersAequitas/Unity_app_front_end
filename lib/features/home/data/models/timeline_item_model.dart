import '../../domain/entities/timeline_item_entity.dart';
import '../../domain/entities/timeline_media_entity.dart';
import 'timeline_author_model.dart';
import 'timeline_collaboration_model.dart';
import 'timeline_impact_model.dart';
import 'timeline_media_model.dart';

class TimelineItemModel {
  final String id;
  final String type;
  final String? postType;
  final String contentText;
  final bool isVerified;
  final List<TimelineMediaModel> media;
  final List<String> tags;
  final TimelineAuthorModel? author;
  final int likesCount;
  final int commentsCount;
  final int savesCount;
  final bool isLikedByMe;
  final bool isSaved;
  final String createdAt;
  final TimelineCollaborationModel? acceptedBy;
  final TimelineImpactModel? impact;

  const TimelineItemModel({
    required this.id,
    required this.type,
    this.postType,
    required this.contentText,
    this.isVerified = false,
    this.media = const [],
    this.tags = const [],
    this.author,
    this.likesCount = 0,
    this.commentsCount = 0,
    this.savesCount = 0,
    this.isLikedByMe = false,
    this.isSaved = false,
    required this.createdAt,
    this.acceptedBy,
    this.impact,
  });

  factory TimelineItemModel.fromJson(Map<String, dynamic> json) {
    final mediaList = (json['media'] ?? json['creative_media'] ?? json['creatives']) as List?;
    final tagsList = json['tags'] as List?;
    final authorMap = (json['author'] ?? json['user'] ?? json['member'] ?? json['creator']) as Map<String, dynamic>?;
    final acceptedMap = json['accepted_by'] as Map<String, dynamic>?;
    final impactMap = json['impact'] as Map<String, dynamic>?;

    final actCreative = json['activity_creative'] as Map<String, dynamic>?;
    List<TimelineMediaModel> parsedMedia = [];
    if (mediaList != null) {
      parsedMedia = mediaList
          .whereType<Map<String, dynamic>>()
          .map((m) => TimelineMediaModel.fromJson(m))
          .toList();
    }
    if (parsedMedia.isEmpty && actCreative != null) {
      final creativeUrl = actCreative['creative_url'] as String?;
      if (creativeUrl != null && creativeUrl.isNotEmpty) {
        parsedMedia.add(
          TimelineMediaModel(
            url: creativeUrl,
            fileId: actCreative['creative_file_id']?.toString(),
          ),
        );
      }
    }
    if (parsedMedia.isEmpty) {
      final directImageUrl = (json['image_url'] ?? json['imageUrl'] ?? json['image'] ?? json['file_url'])?.toString();
      final directVideoUrl = (json['video_url'] ?? json['videoUrl'] ?? json['video'])?.toString();
      if (directImageUrl != null && directImageUrl.isNotEmpty) {
        parsedMedia.add(TimelineMediaModel(url: directImageUrl, type: MediaType.image));
      } else if (directVideoUrl != null && directVideoUrl.isNotEmpty) {
        parsedMedia.add(TimelineMediaModel(url: directVideoUrl, type: MediaType.video));
      }
    }

    return TimelineItemModel(
      id: (json['id'] ?? '').toString(),
      type: (json['type'] ?? json['source_type'] ?? 'post').toString(),
      postType: json['post_type'] as String?,
      contentText: (json['content_text'] ?? json['content'] ?? json['caption'] ?? json['text'] ?? json['description'] ?? json['title'] ?? '').toString(),
      isVerified: json['is_verified'] as bool? ?? false,
      media: parsedMedia,
      tags: tagsList?.map((t) => t.toString()).toList() ?? const [],
      author: authorMap != null ? TimelineAuthorModel.fromJson(authorMap) : null,
      likesCount: (json['likes_count'] as num?)?.toInt() ?? 0,
      commentsCount: (json['comments_count'] as num?)?.toInt() ?? 0,
      savesCount: (json['saves_count'] as num?)?.toInt() ?? 0,
      isLikedByMe: json['is_liked_by_me'] as bool? ?? false,
      isSaved: (json['is_saved'] ?? json['is_saved_by_me']) as bool? ?? false,
      createdAt: (json['created_at'] ?? json['createdAt'] ?? json['date'] ?? json['posted_at'] ?? '').toString(),
      acceptedBy: acceptedMap != null ? TimelineCollaborationModel.fromJson(acceptedMap) : null,
      impact: impactMap != null ? TimelineImpactModel.fromJson(impactMap) : null,
    );
  }

  TimelineItemEntity toEntity() {
    return TimelineItemEntity(
      id: id,
      type: type,
      postType: postType,
      contentText: contentText,
      isVerified: isVerified,
      media: media.map((m) => m.toEntity()).toList(),
      tags: tags,
      author: author?.toEntity(),
      likesCount: likesCount,
      commentsCount: commentsCount,
      savesCount: savesCount,
      isLikedByMe: isLikedByMe,
      isSaved: isSaved,
      createdAt: createdAt,
      acceptedBy: acceptedBy?.toEntity(),
      impact: impact?.toEntity(),
    );
  }
}
