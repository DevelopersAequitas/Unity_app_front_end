import '../../../../core/constants/app_environment.dart';
import '../../domain/entities/timeline_item_entity.dart';
import '../../domain/entities/timeline_media_entity.dart';
import 'timeline_author_model.dart';
import 'timeline_collaboration_model.dart';
import 'timeline_impact_model.dart';
import 'timeline_media_model.dart';
import 'timeline_mention_model.dart';

class TimelineItemModel {
  final String id;
  final String type;
  final String? postType;
  final String contentText;
  final bool isVerified;
  final List<TimelineMediaModel> media;
  final List<String> tags;
  final List<TimelineMentionModel> mentions;
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
  });

  factory TimelineItemModel.fromJson(Map<String, dynamic> json) {
    final mediaList = (json['media'] ?? json['creative_media'] ?? json['creatives']) as List?;
    final tagsList = json['tags'] as List?;
    final rawMentions = (json['mentions'] ?? json['tagged_peers'] ?? json['tagged_users'] ?? json['mentioned_peers'] ?? json['peers']) as List?;
    final authorMap = (json['author'] ??
            json['user'] ??
            json['member'] ??
            json['creator'] ??
            json['peer'] ??
            json['owner'] ??
            (json['user_id'] != null || json['display_name'] != null || json['user_name'] != null
                ? json
                : null)) as Map<String, dynamic>?;
    final acceptedMap = json['accepted_by'] as Map<String, dynamic>?;
    final impactMap = json['impact'] as Map<String, dynamic>?;

    final actCreative = json['activity_creative'] as Map<String, dynamic>?;
    var directImageUrl = (json['image'] ?? json['image_url'] ?? json['imageUrl'] ?? json['file_url'])?.toString().trim();
    if (directImageUrl != null && directImageUrl.isNotEmpty && directImageUrl.startsWith('/')) {
      directImageUrl = '${AppEnvironment.baseUrl}$directImageUrl';
    }
    var directVideoUrl = (json['video_url'] ?? json['videoUrl'] ?? json['video'])?.toString().trim();
    if (directVideoUrl != null && directVideoUrl.isNotEmpty && directVideoUrl.startsWith('/')) {
      directVideoUrl = '${AppEnvironment.baseUrl}$directVideoUrl';
    }

    List<TimelineMediaModel> parsedMedia = [];
    if (mediaList != null) {
      parsedMedia = mediaList
          .whereType<Map<String, dynamic>>()
          .map((m) {
            final model = TimelineMediaModel.fromJson(m);
            if (directImageUrl != null &&
                directImageUrl.isNotEmpty &&
                model.type == MediaType.image &&
                (model.url.contains('/files/') || model.url.isEmpty)) {
              return TimelineMediaModel(
                url: directImageUrl,
                type: MediaType.image,
                mimeType: model.mimeType,
                fileId: model.fileId,
                width: model.width,
                height: model.height,
              );
            }
            return model;
          })
          .toList();
    }
    if (parsedMedia.isEmpty && actCreative != null) {
      var creativeUrl = actCreative['creative_url'] as String?;
      if (creativeUrl != null && creativeUrl.isNotEmpty) {
        if (creativeUrl.startsWith('/')) {
          creativeUrl = '${AppEnvironment.baseUrl}$creativeUrl';
        }
        parsedMedia.add(
          TimelineMediaModel(
            url: creativeUrl,
            fileId: actCreative['creative_file_id']?.toString(),
          ),
        );
      }
    }
    if (parsedMedia.isEmpty) {
      if (directImageUrl != null && directImageUrl.isNotEmpty) {
        parsedMedia.add(TimelineMediaModel(url: directImageUrl, type: MediaType.image));
      } else if (directVideoUrl != null && directVideoUrl.isNotEmpty) {
        parsedMedia.add(TimelineMediaModel(url: directVideoUrl, type: MediaType.video));
      }
    }

    List<TimelineMentionModel> parsedMentions = [];
    if (rawMentions != null) {
      parsedMentions = rawMentions
          .whereType<Map<String, dynamic>>()
          .map((m) => TimelineMentionModel.fromJson(m))
          .toList();
    }

    return TimelineItemModel(
      id: (json['id'] ?? '').toString(),
      type: (json['type'] ?? json['source_type'] ?? 'post').toString(),
      postType: json['post_type'] as String?,
      contentText: (json['content_text'] ?? json['content'] ?? json['caption'] ?? json['text'] ?? json['description'] ?? json['title'] ?? '').toString(),
      isVerified: json['is_verified'] as bool? ?? false,
      media: parsedMedia,
      tags: tagsList?.map((t) => t.toString()).toList() ?? const [],
      mentions: parsedMentions,
      author: authorMap != null
          ? TimelineAuthorModel.fromJson({
              'is_verified': json['is_verified'],
              ...authorMap,
            })
          : null,
      likesCount: (json['likes_count'] ?? json['like_count'] ?? json['likes'] ?? json['total_likes'] as num?)?.toInt() ?? 0,
      commentsCount: (json['comments_count'] ?? json['comment_count'] ?? json['comments'] ?? json['total_comments'] as num?)?.toInt() ?? 0,
      savesCount: (json['saves_count'] ?? json['save_count'] ?? json['saves'] ?? json['bookmarks_count'] as num?)?.toInt() ?? 0,
      isLikedByMe: (json['is_liked_by_me'] == true ||
          json['is_liked'] == true ||
          json['isLiked'] == true ||
          json['isLikedByMe'] == true ||
          json['is_like'] == true),
      isSaved: (json['is_saved'] == true ||
          json['is_saved_by_me'] == true ||
          json['isSaved'] == true ||
          json['is_bookmark'] == true),
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
      mentions: mentions.map((m) => m.toEntity()).toList(),
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

