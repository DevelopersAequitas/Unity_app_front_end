import '../../domain/entities/timeline_mention_entity.dart';

class TimelineMentionModel {
  final String id;
  final String name;
  final String? username;
  final String? profilePhotoUrl;

  const TimelineMentionModel({
    required this.id,
    required this.name,
    this.username,
    this.profilePhotoUrl,
  });

  factory TimelineMentionModel.fromJson(Map<String, dynamic> json) {
    return TimelineMentionModel(
      id: (json['id'] ?? json['peer_id'] ?? json['user_id'] ?? json['member_id'] ?? '').toString(),
      name: (json['name'] ?? json['display_name'] ?? json['peer_name'] ?? json['username'] ?? '').toString(),
      username: json['username'] as String?,
      profilePhotoUrl: (json['profile_photo_url'] ?? json['photo_url'] ?? json['avatar'] ?? json['image']) as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      if (username != null) 'username': username,
      if (profilePhotoUrl != null) 'profile_photo_url': profilePhotoUrl,
    };
  }

  TimelineMentionEntity toEntity() {
    return TimelineMentionEntity(
      id: id,
      name: name,
      username: username,
      profilePhotoUrl: profilePhotoUrl,
    );
  }
}
