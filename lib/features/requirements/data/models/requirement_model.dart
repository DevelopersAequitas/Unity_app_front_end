import '../../domain/entities/requirement.dart';

class RequirementModel extends Requirement {
  const RequirementModel({
    required super.id,
    super.postId,
    required super.subject,
    required super.description,
    required super.media,
    super.cityName,
    super.regionLabel,
    super.category,
    required super.status,
    required super.submittedAt,
    super.user,
  });

  factory RequirementModel.fromJson(Map<String, dynamic> json) {
    List<RequirementMedia> mediaList = [];
    final rawMedia = json['media'] ?? json['attachments'];
    if (rawMedia is List) {
      mediaList = rawMedia.map((m) {
        if (m is Map<String, dynamic>) {
          return RequirementMedia(
            id: m['file_id']?.toString() ?? m['id']?.toString() ?? '',
            url: m['url']?.toString() ?? m['path']?.toString(),
          );
        }
        return RequirementMedia(id: m.toString());
      }).toList();
    }

    final regionFilter = json['region_filter'] is Map<String, dynamic>
        ? json['region_filter'] as Map<String, dynamic>
        : null;
    final categoryFilter = json['category_filter'] is Map<String, dynamic>
        ? json['category_filter'] as Map<String, dynamic>
        : null;

    final cityName = regionFilter?['city_name']?.toString() ??
        json['city_name']?.toString() ??
        json['city']?.toString();
    final regionLabel = regionFilter?['region_label']?.toString() ??
        json['region_label']?.toString() ??
        json['region']?.toString();
    final category = categoryFilter?['category']?.toString() ??
        json['category']?.toString();

    RequirementUser? user;
    final rawUser = json['user'] is Map<String, dynamic>
        ? json['user'] as Map<String, dynamic>
        : (json['member'] is Map<String, dynamic> ? json['member'] as Map<String, dynamic> : null);

    final authorName = json['user_name']?.toString() ??
        rawUser?['full_name']?.toString() ??
        rawUser?['name']?.toString() ??
        json['name']?.toString();

    if (authorName != null && authorName.isNotEmpty || rawUser != null) {
      user = RequirementUser(
        id: rawUser?['id']?.toString() ?? json['user_id']?.toString() ?? '',
        fullName: authorName ?? 'Peer Member',
        avatar: json['profile_photo_url']?.toString() ??
            json['avatar']?.toString() ??
            rawUser?['profile_photo_url']?.toString() ??
            rawUser?['avatar']?.toString(),
        company: json['company']?.toString() ??
            rawUser?['company']?.toString() ??
            rawUser?['company_name']?.toString(),
        city: json['city']?.toString() ?? rawUser?['city']?.toString(),
      );
    }

    return RequirementModel(
      id: json['id']?.toString() ?? '',
      postId: json['post_id']?.toString(),
      subject: json['subject']?.toString() ?? json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      media: mediaList,
      cityName: cityName,
      regionLabel: regionLabel,
      category: category,
      status: json['status']?.toString() ?? 'open',
      submittedAt: json['created_at']?.toString() ??
          json['submitted_at']?.toString() ??
          DateTime.now().toIso8601String(),
      user: user,
    );
  }
}
