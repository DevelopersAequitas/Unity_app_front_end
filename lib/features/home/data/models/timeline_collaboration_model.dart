import '../../domain/entities/timeline_collaboration_entity.dart';

class TimelineCollaborationModel {
  final String id;
  final String name;
  final String? companyName;
  final String? city;
  final String? avatarUrl;
  final bool isVerified;

  const TimelineCollaborationModel({
    required this.id,
    required this.name,
    this.companyName,
    this.city,
    this.avatarUrl,
    this.isVerified = true,
  });

  factory TimelineCollaborationModel.fromJson(Map<String, dynamic> json) {
    return TimelineCollaborationModel(
      id: (json['id'] ?? '').toString(),
      name: (json['name'] ?? json['display_name'] ?? 'Peer Partner').toString(),
      companyName: json['company_name'] as String?,
      city: json['city'] as String?,
      avatarUrl: (json['avatar_url'] ?? json['profile_photo_url']) as String?,
      isVerified: json['is_verified'] as bool? ?? true,
    );
  }

  TimelineCollaborationEntity toEntity() {
    return TimelineCollaborationEntity(
      id: id,
      name: name,
      companyName: companyName,
      city: city,
      avatarUrl: avatarUrl,
      isVerified: isVerified,
    );
  }
}
