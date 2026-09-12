import '../../domain/entities/timeline_author_entity.dart';

class TimelineAuthorModel {
  final String id;
  final String displayName;
  final String? firstName;
  final String? lastName;
  final String? profilePhotoUrl;
  final bool isVerified;

  const TimelineAuthorModel({
    required this.id,
    required this.displayName,
    this.firstName,
    this.lastName,
    this.profilePhotoUrl,
    this.isVerified = false,
  });

  factory TimelineAuthorModel.fromJson(Map<String, dynamic> json) {
    final first = json['first_name'] as String?;
    final last = json['last_name'] as String?;
    final rawDisplay = json['display_name'] as String?;
    final computedName = rawDisplay ??
        ('${first ?? ''} ${last ?? ''}'.trim().isNotEmpty
            ? '${first ?? ''} ${last ?? ''}'.trim()
            : 'Peer Member');

    return TimelineAuthorModel(
      id: (json['id'] ?? '').toString(),
      displayName: computedName,
      firstName: first,
      lastName: last,
      profilePhotoUrl: (json['profile_photo_url'] ?? json['avatar_url']) as String?,
      isVerified: json['is_verified'] as bool? ?? false,
    );
  }

  TimelineAuthorEntity toEntity() {
    return TimelineAuthorEntity(
      id: id,
      displayName: displayName,
      firstName: firstName,
      lastName: lastName,
      profilePhotoUrl: profilePhotoUrl,
      isVerified: isVerified,
    );
  }
}
