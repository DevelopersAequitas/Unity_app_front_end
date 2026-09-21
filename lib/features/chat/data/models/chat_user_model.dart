import '../../domain/entities/chat_user_entity.dart';

class ChatUserModel extends ChatUserEntity {
  const ChatUserModel({
    required super.id,
    required super.displayName,
    super.firstName,
    super.lastName,
    super.profilePhotoUrl,
    super.companyName,
    super.leaderRole,
    super.title,
    super.isOnline = false,
    super.isVerified = false,
    super.isPro = false,
    super.isTyping = false,
    super.category,
  });

  factory ChatUserModel.fromJson(Map<String, dynamic> json) {
    final id = (json['id'] ?? json['user_id'] ?? json['_id'] ?? '').toString();
    final displayName = (json['display_name'] ??
            json['name'] ??
            json['full_name'] ??
            '${json['first_name'] ?? ''} ${json['last_name'] ?? ''}'.trim())
        .toString();

    final isOnline = json['is_online'] == true ||
        json['online'] == true ||
        json['is_active'] == true;
    final isVerified = json['is_verified'] == true ||
        json['verified'] == true ||
        json['is_verified_member'] == true;
    final isPro = json['is_pro'] == true ||
        json['is_pro_member'] == true ||
        json['is_premium'] == true;
    final isTyping = json['is_typing'] == true ||
        json['typing'] == true ||
        json['is_typing_now'] == true;
    final category = json['category']?.toString() ??
        json['business_category']?.toString() ??
        json['company_name']?.toString();

    return ChatUserModel(
      id: id,
      displayName: displayName.isEmpty ? 'Peer' : displayName,
      firstName: json['first_name']?.toString(),
      lastName: json['last_name']?.toString(),
      profilePhotoUrl:
          json['profile_photo_url']?.toString() ?? json['avatar_url']?.toString() ?? json['avatar']?.toString(),
      companyName: json['company_name']?.toString() ?? json['company']?.toString(),
      leaderRole: json['leader_role']?.toString() ?? json['role']?.toString(),
      title: json['title']?.toString(),
      isOnline: isOnline,
      isVerified: isVerified,
      isPro: isPro,
      isTyping: isTyping,
      category: category,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'display_name': displayName,
      'first_name': firstName,
      'last_name': lastName,
      'profile_photo_url': profilePhotoUrl,
      'company_name': companyName,
      'leader_role': leaderRole,
      'title': title,
      'is_online': isOnline,
      'is_verified': isVerified,
      'is_pro': isPro,
      'is_typing': isTyping,
      'category': category,
    };
  }
}
