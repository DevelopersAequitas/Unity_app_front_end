import '../../domain/entities/circle_closed_category_entity.dart';
import 'circle_model.dart';

class CircleClosedCategoryModel extends CircleClosedCategoryEntity {
  const CircleClosedCategoryModel({
    required super.id,
    super.categoryId,
    required super.name,
    super.level2Name,
    super.level3Name,
    super.occupantUserId,
    super.occupantName,
    super.occupantAvatarUrl,
    super.occupantCompany,
    super.occupantDesignation,
    super.occupantCity,
    super.occupantImpactCount,
    super.occupantIsBookmarked,
    super.occupantIsFollowing,
    super.occupantIsPro,
    super.occupantIsConnected,
    super.occupantIsRequested,
    super.occupantConnectionStatus,
  });

  factory CircleClosedCategoryModel.fromJson(Map<String, dynamic> json) {
    // Occupant user object may be inside 'occupied_by', 'user', 'peer', 'member', 'occupant', or at root
    Map<String, dynamic>? userObj;
    if (json['occupied_by'] is List && (json['occupied_by'] as List).isNotEmpty) {
      final first = (json['occupied_by'] as List).first;
      if (first is Map<String, dynamic>) {
        userObj = first;
      }
    } else if (json['occupied_by'] is Map<String, dynamic>) {
      userObj = json['occupied_by'] as Map<String, dynamic>;
    } else if (json['user'] is Map<String, dynamic>) {
      userObj = json['user'] as Map<String, dynamic>;
    } else if (json['peer'] is Map<String, dynamic>) {
      userObj = json['peer'] as Map<String, dynamic>;
    } else if (json['member'] is Map<String, dynamic>) {
      userObj = json['member'] as Map<String, dynamic>;
    } else if (json['occupant'] is Map<String, dynamic>) {
      userObj = json['occupant'] as Map<String, dynamic>;
    }

    String? occupantName;
    if (userObj != null) {
      final name = userObj['name'] ?? userObj['user_name'] ?? userObj['full_name'] ?? userObj['display_name'];
      if (name != null && name.toString().trim().isNotEmpty) {
        occupantName = name.toString().trim();
      } else {
        final f = userObj['first_name']?.toString().trim() ?? '';
        final l = userObj['last_name']?.toString().trim() ?? '';
        if (f.isNotEmpty || l.isNotEmpty) {
          occupantName = '$f $l'.trim();
        }
      }
    } else {
      occupantName = json['occupant_name']?.toString() ?? json['user_name']?.toString() ?? json['peer_name']?.toString();
    }

    final rawAvatar = userObj?['profile_photo_url'] ??
        userObj?['avatar_url'] ??
        userObj?['profile_picture'] ??
        json['occupant_avatar_url'] ??
        json['profile_photo_url'];

    final rawAvatarFileId = userObj?['profile_photo_file_id'] ??
        userObj?['avatar_file_id'] ??
        json['profile_photo_file_id'];

    final avatarUrl = CircleModel.parseImageUrl(rawAvatar) ??
        CircleModel.parseImageUrl(rawAvatarFileId);

    final company = userObj?['company_name'] ??
        userObj?['company'] ??
        json['company_name'] ??
        json['company'];

    final designation = userObj?['designation'] ??
        userObj?['role'] ??
        json['designation'];

    String? cityText;
    final rawCity = userObj?['city'] ??
        userObj?['city_name'] ??
        userObj?['cityName'] ??
        userObj?['region'] ??
        userObj?['state'] ??
        json['city'] ??
        json['city_name'] ??
        json['region'];

    if (rawCity is Map<String, dynamic>) {
      cityText = (rawCity['name'] ?? rawCity['formatted_location'] ?? rawCity['label'] ?? rawCity['city'])?.toString();
    } else if (rawCity != null && rawCity.toString().trim().isNotEmpty) {
      cityText = rawCity.toString().trim();
    }

    final userId = userObj?['user_id'] ??
        userObj?['id'] ??
        json['user_id'] ??
        json['occupant_user_id'];

    final impactCountRaw = userObj?['impact_count'] ??
        userObj?['life_impacted_count'] ??
        json['impact_count'] ??
        json['life_impacted_count'];
    final impactCount = impactCountRaw is int
        ? impactCountRaw
        : int.tryParse(impactCountRaw?.toString() ?? '');

    final isBookmarked = userObj?['is_bookmarked'] == true ||
        userObj?['is_bookmark'] == true ||
        json['is_bookmarked'] == true ||
        json['is_bookmark'] == true;
    final isFollowing = userObj?['is_following'] == true ||
        userObj?['is_following'] == 1 ||
        userObj?['is_following'] == '1' ||
        json['is_following'] == true ||
        json['is_following'] == 1 ||
        json['is_following'] == '1';
    final isPro = userObj?['is_pro'] == true ||
        userObj?['is_pro'] == 1 ||
        userObj?['is_pro'] == '1' ||
        json['is_pro'] == true ||
        json['is_pro'] == 1 ||
        json['is_pro'] == '1';
    final isConnected = userObj?['is_connected'] == true || json['is_connected'] == true;
    final isRequested = userObj?['is_requested'] == true || json['is_requested'] == true;
    final connectionStatus = userObj?['connection_status']?.toString() ??
        json['connection_status']?.toString() ??
        (isConnected ? 'connected' : (isRequested ? 'pending' : 'none'));

    String catName = '';
    String? categoryId = (json['category_id'] ?? json['level4_category_id'] ?? json['id'])?.toString();
    String? level2Name = (json['level2_name'] ?? json['sector'] ?? json['industry'] ?? json['business_category'])?.toString();
    String? level3Name = (json['level3_name'] ?? json['sub_category'] ?? json['business_sub_category'])?.toString();

    if (json['level4_category'] is Map<String, dynamic>) {
      final l4 = json['level4_category'] as Map<String, dynamic>;
      catName = (l4['name'] ?? l4['category_name'] ?? l4['title'] ?? '').toString();
      categoryId ??= l4['id']?.toString();
    } else if (json['category'] is Map<String, dynamic>) {
      final c = json['category'] as Map<String, dynamic>;
      catName = (c['name'] ?? c['category_name'] ?? c['title'] ?? '').toString();
      categoryId ??= c['id']?.toString();
    } else {
      catName = (json['category_name'] ?? json['name'] ?? json['level4_category'] ?? json['title'] ?? '').toString();
    }

    if (catName.isEmpty && userObj != null) {
      catName = (userObj['level4_category'] ?? userObj['category_name'] ?? userObj['category'] ?? userObj['business_sub_category'] ?? '').toString();
    }

    return CircleClosedCategoryModel(
      id: (json['id'] ?? categoryId ?? '').toString(),
      categoryId: categoryId,
      name: catName.isNotEmpty ? catName : 'Category',
      level2Name: level2Name,
      level3Name: level3Name,
      occupantUserId: userId?.toString(),
      occupantName: occupantName,
      occupantAvatarUrl: avatarUrl,
      occupantCompany: company?.toString(),
      occupantDesignation: designation?.toString(),
      occupantCity: cityText,
      occupantImpactCount: impactCount,
      occupantIsBookmarked: isBookmarked,
      occupantIsFollowing: isFollowing,
      occupantIsPro: isPro,
      occupantIsConnected: isConnected,
      occupantIsRequested: isRequested,
      occupantConnectionStatus: connectionStatus,
    );
  }
}
