import '../../domain/entities/circle_member_entity.dart';

class CircleMemberModel extends CircleMemberEntity {
  const CircleMemberModel({
    required super.id,
    super.userId,
    required super.name,
    super.displayName,
    super.role,
    super.designation,
    super.companyName,
    super.avatarUrl,
    super.isLeader = false,
    super.city,
    super.businessCategory,
    super.businessSubCategory,
    super.level4Category,
    super.membershipStatus,
    super.lifeImpactedCount,
    super.isPro = false,
    super.isFollowing = false,
    super.isConnected = false,
    super.connectionStatus = 'none',
    super.isRequested = false,
    super.isBookmark = false,
  });

  factory CircleMemberModel.fromJson(Map<String, dynamic> json) {
    final userMap = json['user'] is Map<String, dynamic> ? json['user'] as Map<String, dynamic> : json;

    final rawName = userMap['name']?.toString() ??
        userMap['display_name']?.toString() ??
        userMap['full_name']?.toString() ??
        (userMap['first_name'] != null
            ? '${userMap['first_name']} ${userMap['last_name'] ?? ''}'.trim()
            : (json['name']?.toString() ?? 'Peer'));

    final roleStr = json['role']?.toString() ?? json['role_title']?.toString() ?? userMap['role']?.toString();
    final roleLower = (roleStr ?? '').toLowerCase();
    final bool isLeader = roleLower.contains('director') ||
        roleLower.contains('founder') ||
        roleLower.contains('chair') ||
        json['is_leader'] == true ||
        json['is_leader']?.toString() == '1';

    String? cityText;
    if (userMap['city'] is Map<String, dynamic>) {
      cityText = userMap['city']['name']?.toString();
    } else if (userMap['city'] != null && userMap['city'].toString().trim().isNotEmpty) {
      cityText = userMap['city']?.toString();
    } else if (userMap['city_name'] != null && userMap['city_name'].toString().trim().isNotEmpty) {
      cityText = userMap['city_name']?.toString();
    } else if (json['city'] != null) {
      cityText = json['city']?.toString();
    }

    String? lvl4;
    if (userMap['categories'] is List && (userMap['categories'] as List).isNotEmpty) {
      final firstCat = (userMap['categories'] as List).first;
      if (firstCat is Map<String, dynamic>) {
        if (firstCat['level4_category'] is Map<String, dynamic>) {
          lvl4 = firstCat['level4_category']['name']?.toString();
        } else if (firstCat['level3_category'] is Map<String, dynamic>) {
          lvl4 = firstCat['level3_category']['name']?.toString();
        }
      }
    }
    lvl4 ??= userMap['business_sub_category']?.toString() ??
        userMap['business_category_name']?.toString() ??
        userMap['business_category']?.toString() ??
        json['level4_category']?.toString();

    final photoUrl = userMap['profile_photo_url']?.toString() ??
        userMap['avatar_url']?.toString() ??
        userMap['photo_url']?.toString() ??
        userMap['profile_photo_image']?.toString() ??
        json['profile_photo_url']?.toString() ??
        json['profile_photo_image']?.toString() ??
        json['avatar_url']?.toString();

    final designation = userMap['designation']?.toString() ?? userMap['title']?.toString() ?? json['designation']?.toString();
    final companyName = userMap['company_name']?.toString() ?? userMap['company']?.toString() ?? json['company_name']?.toString();
    final businessCat = userMap['business_category_name']?.toString() ?? userMap['business_category']?.toString();
    final businessSubCat = userMap['business_sub_category']?.toString();
    final membershipStat = userMap['membership_status']?.toString();

    int? lifeImpact;
    if (userMap['life_impacted_count'] is num) {
      lifeImpact = (userMap['life_impacted_count'] as num).toInt();
    } else if (userMap['life_impacted_count'] != null) {
      lifeImpact = int.tryParse(userMap['life_impacted_count'].toString());
    }

    final bool isPro = json['is_pro'] == true ||
        json['is_pro'] == 1 ||
        json['is_pro']?.toString() == '1' ||
        userMap['is_pro'] == true ||
        userMap['is_pro'] == 1 ||
        userMap['is_pro']?.toString() == '1';

    final bool isFollowing = json['is_following'] == true ||
        json['is_following'] == 1 ||
        json['is_following']?.toString() == '1' ||
        userMap['is_following'] == true ||
        userMap['is_following'] == 1 ||
        userMap['is_following']?.toString() == '1';

    final bool isConnected = json['is_connected'] == true ||
        json['is_connected'] == 1 ||
        userMap['is_connected'] == true ||
        userMap['is_connected'] == 1;

    final String connectionStatus = json['connection_status']?.toString() ??
        userMap['connection_status']?.toString() ??
        (isConnected ? 'connected' : 'none');

    final bool isRequested = json['is_requested'] == true ||
        json['is_requested'] == 1 ||
        userMap['is_requested'] == true ||
        userMap['is_requested'] == 1;

    final bool isBookmark = json['is_bookmark'] == true ||
        json['is_bookmarked'] == true ||
        userMap['is_bookmark'] == true ||
        userMap['is_bookmarked'] == true;

    return CircleMemberModel(
      id: json['id']?.toString() ?? userMap['id']?.toString() ?? '',
      userId: userMap['id']?.toString() ?? json['user_id']?.toString(),
      name: rawName.isEmpty ? 'Peer' : rawName,
      displayName: userMap['display_name']?.toString() ?? json['display_name']?.toString(),
      role: roleStr,
      designation: designation,
      companyName: companyName,
      avatarUrl: photoUrl,
      isLeader: isLeader,
      city: cityText,
      businessCategory: businessCat,
      businessSubCategory: businessSubCat,
      level4Category: lvl4,
      membershipStatus: membershipStat,
      lifeImpactedCount: lifeImpact,
      isPro: isPro,
      isFollowing: isFollowing,
      isConnected: isConnected,
      connectionStatus: connectionStatus,
      isRequested: isRequested,
      isBookmark: isBookmark,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'display_name': displayName,
      'role': role,
      'designation': designation,
      'company_name': companyName,
      'profile_photo_url': avatarUrl,
      'is_leader': isLeader,
      'city': city,
      'business_category': businessCategory,
      'business_sub_category': businessSubCategory,
      'level4_category': level4Category,
      'membership_status': membershipStatus,
      'life_impacted_count': lifeImpactedCount,
      'is_pro': isPro,
      'is_following': isFollowing,
      'is_connected': isConnected,
      'connection_status': connectionStatus,
      'is_requested': isRequested,
      'is_bookmark': isBookmark,
    };
  }
}
