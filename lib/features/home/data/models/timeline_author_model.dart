import '../../domain/entities/timeline_author_entity.dart';

class TimelineAuthorModel {
  final String id;
  final String displayName;
  final String? firstName;
  final String? lastName;
  final String? profilePhotoUrl;
  final bool isVerified;
  final String? designation;
  final String? companyName;
  final String? level4Category;

  const TimelineAuthorModel({
    required this.id,
    required this.displayName,
    this.firstName,
    this.lastName,
    this.profilePhotoUrl,
    this.isVerified = false,
    this.designation,
    this.companyName,
    this.level4Category,
  });

  factory TimelineAuthorModel.fromJson(Map<String, dynamic> json) {
    final first = (json['first_name'] ?? json['firstname']) as String?;
    final last = (json['last_name'] ?? json['lastname']) as String?;
    final rawDisplay = (json['display_name'] ??
            json['name'] ??
            json['full_name'] ??
            json['username'] ??
            json['user_name'] ??
            json['contact_name'])
        ?.toString();
    final computedName = (rawDisplay != null && rawDisplay.trim().isNotEmpty)
        ? rawDisplay.trim()
        : ('${first ?? ''} ${last ?? ''}'.trim().isNotEmpty
            ? '${first ?? ''} ${last ?? ''}'.trim()
            : 'Peers Member');

    return TimelineAuthorModel(
      id: (json['id'] ?? json['user_id'] ?? json['member_id'] ?? '').toString(),
      displayName: computedName,
      firstName: first,
      lastName: last,
      profilePhotoUrl: (json['profile_photo_url'] ??
              json['avatar_url'] ??
              json['avatar'] ??
              json['photo_url'] ??
              json['user_avatar'] ??
              json['profile_photo'] ??
              json['photo'])
          ?.toString(),
      isVerified: json['is_verified'] as bool? ?? false,
      designation: (json['designation'] ?? json['headline'] ?? json['role'] ?? json['profession'])?.toString(),
      companyName: (json['company_name'] ?? json['company'] ?? json['business_name'])?.toString(),
      level4Category: (json['level4_category'] ?? json['business_sub_category'])?.toString(),
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
      designation: designation,
      companyName: companyName,
      level4Category: level4Category,
    );
  }
}
