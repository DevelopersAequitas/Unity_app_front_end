import '../../domain/entities/post_comment_entity.dart';

class PostCommentModel extends PostCommentEntity {
  const PostCommentModel({
    required super.id,
    required super.userId,
    required super.displayName,
    super.profilePhotoUrl,
    super.designation,
    super.companyName,
    super.category,
    super.city,
    required super.content,
    super.createdAt,
  });

  factory PostCommentModel.fromJson(Map<String, dynamic> json) {
    final userMap = json['user'] is Map<String, dynamic>
        ? json['user'] as Map<String, dynamic>
        : (json['member'] is Map<String, dynamic>
            ? json['member'] as Map<String, dynamic>
            : (json['author'] is Map<String, dynamic>
                ? json['author'] as Map<String, dynamic>
                : json));

    final userId = (userMap['id'] ??
            json['user_id'] ??
            json['userId'] ??
            json['member_id'] ??
            json['id'] ??
            '')
        .toString();

    final displayName = (userMap['display_name'] ??
            userMap['displayName'] ??
            userMap['name'] ??
            userMap['userName'] ??
            json['display_name'] ??
            json['userName'] ??
            'Peer Member')
        .toString();

    final profilePhoto = (userMap['profile_photo_url'] ??
            userMap['profilePhotoUrl'] ??
            userMap['avatar'] ??
            userMap['photo_url'] ??
            json['profile_photo_url'] ??
            json['avatar'])
        ?.toString();

    final designation = (userMap['designation'] ??
            userMap['designation_name'] ??
            userMap['role'] ??
            userMap['title'] ??
            json['designation'])
        ?.toString();

    final company = (userMap['company_name'] ??
            userMap['companyName'] ??
            userMap['company'] ??
            userMap['business_name'] ??
            json['company_name'])
        ?.toString();

    final category = (userMap['level4_category'] ??
            userMap['level_4_category'] ??
            userMap['category_level4'] ??
            userMap['category'] ??
            userMap['category_name'] ??
            userMap['business_category'] ??
            json['level4_category'] ??
            json['category'])
        ?.toString();

    final city = (userMap['city'] ??
            userMap['city_name'] ??
            userMap['location'] ??
            json['city'])
        ?.toString();

    final content = (json['content'] ??
            json['comment'] ??
            json['text'] ??
            json['message'] ??
            '')
        .toString();

    final createdAt = (json['created_at'] ??
            json['createdAt'] ??
            json['commented_at'] ??
            json['timestamp'] ??
            '')
        .toString();

    return PostCommentModel(
      id: (json['id'] ?? '').toString(),
      userId: userId,
      displayName: displayName,
      profilePhotoUrl: profilePhoto,
      designation: designation,
      companyName: company,
      category: category,
      city: city,
      content: content,
      createdAt: createdAt,
    );
  }

  PostCommentEntity toEntity() => this;
}
