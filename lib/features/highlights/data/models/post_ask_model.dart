import '../../domain/entities/post_ask_entity.dart';

class PostAskModel extends PostAskEntity {
  const PostAskModel({
    super.id,
    required super.subject,
    required super.description,
    required super.category,
    super.regionLabel,
    super.cityName,
    super.mediaId,
    super.mediaUrl,
    super.status,
    super.createdAt,
    super.authorName,
    super.authorAvatar,
  });

  factory PostAskModel.fromJson(Map<String, dynamic> json) {
    DateTime? parsedDate;
    if (json['created_at'] != null) {
      parsedDate = DateTime.tryParse(json['created_at'].toString());
    } else if (json['createdAt'] != null) {
      parsedDate = DateTime.tryParse(json['createdAt'].toString());
    }

    String? mediaId;
    String? mediaUrl;
    if (json['media'] is Map) {
      mediaId = json['media']['id']?.toString();
      mediaUrl = json['media']['url']?.toString() ?? json['media']['file_url']?.toString();
    } else if (json['media_id'] != null) {
      mediaId = json['media_id'].toString();
    } else if (json['media'] is String) {
      mediaUrl = json['media'].toString();
    }

    String? authorName;
    String? authorAvatar;
    if (json['user'] is Map) {
      final user = json['user'] as Map<String, dynamic>;
      authorName = user['name']?.toString() ??
          '${user['first_name'] ?? ''} ${user['last_name'] ?? ''}'.trim();
      authorAvatar = user['profile_picture']?.toString() ?? user['avatar']?.toString();
    } else if (json['author'] is Map) {
      final author = json['author'] as Map<String, dynamic>;
      authorName = author['name']?.toString();
      authorAvatar = author['avatar']?.toString();
    }

    return PostAskModel(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      subject: json['subject']?.toString() ?? json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? json['content']?.toString() ?? '',
      category: json['category']?.toString() ?? 'General Inquiry',
      regionLabel: json['region_label']?.toString() ?? json['region']?.toString() ?? 'All India',
      cityName: json['city_name']?.toString() ?? json['city']?.toString() ?? '',
      mediaId: mediaId,
      mediaUrl: mediaUrl,
      status: json['status']?.toString() ?? 'open',
      createdAt: parsedDate,
      authorName: authorName,
      authorAvatar: authorAvatar,
    );
  }

  factory PostAskModel.fromEntity(PostAskEntity entity) {
    return PostAskModel(
      id: entity.id,
      subject: entity.subject,
      description: entity.description,
      category: entity.category,
      regionLabel: entity.regionLabel,
      cityName: entity.cityName,
      mediaId: entity.mediaId,
      mediaUrl: entity.mediaUrl,
      status: entity.status,
      createdAt: entity.createdAt,
      authorName: entity.authorName,
      authorAvatar: entity.authorAvatar,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subject': subject,
      'description': description,
      'category': category,
      'region_label': regionLabel,
      'city_name': cityName,
      if (mediaId != null && mediaId!.isNotEmpty) 'media_id': mediaId,
      'status': status,
    };
  }
}
