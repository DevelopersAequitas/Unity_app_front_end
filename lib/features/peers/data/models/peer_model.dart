import '../../domain/entities/peer_entity.dart';

class PeerModel {
  final String id;
  final String displayName;
  final String? firstName;
  final String? lastName;
  final String? profilePhotoUrl;
  final String? companyName;
  final String? city;
  final String? designation;
  final String? category;
  final int? lifeImpactedCount;
  final bool isVerified;
  final bool isBookmarked;
  final bool isFollowing;
  final bool isOnline;
  final String connectionStatus;

  const PeerModel({
    required this.id,
    required this.displayName,
    this.firstName,
    this.lastName,
    this.profilePhotoUrl,
    this.companyName,
    this.city,
    this.designation,
    this.category,
    this.lifeImpactedCount,
    this.isVerified = false,
    this.isBookmarked = false,
    this.isFollowing = false,
    this.isOnline = false,
    this.connectionStatus = 'none',
  });

  factory PeerModel.fromJson(Map<String, dynamic> json) {
    final userMap = json['user'] is Map
        ? json['user'] as Map<String, dynamic>
        : (json['member'] is Map ? json['member'] as Map<String, dynamic> : json);

    final fName = userMap['first_name']?.toString() ?? '';
    final lName = userMap['last_name']?.toString() ?? '';
    String name = userMap['display_name']?.toString() ??
        userMap['name']?.toString() ??
        '$fName $lName'.trim();
    if (name.isEmpty) name = 'Peer';

    String? categoryStr;
    final cats = userMap['categories'] ?? json['categories'];
    if (cats is List && cats.isNotEmpty) {
      final first = cats.first;
      if (first is Map) {
        categoryStr = first['level2_category']?['name']?.toString() ??
            first['level1_category']?['name']?.toString();
      }
    }
    categoryStr ??= userMap['level4_category']?.toString() ??
        userMap['category']?.toString() ??
        userMap['business_sub_category']?.toString() ??
        userMap['business_type']?.toString();

    final rawCity = userMap['city'] ?? json['city'];
    String? cityName;
    if (rawCity is Map) {
      cityName = rawCity['name']?.toString() ?? rawCity['city_name']?.toString();
    } else if (rawCity != null) {
      cityName = rawCity.toString();
    }

    final rawImpact = userMap['life_impacted_count'] ??
        userMap['total_life_impact'] ??
        json['life_impacted_count'];
    final int? impact = rawImpact is num
        ? rawImpact.toInt()
        : int.tryParse(rawImpact?.toString() ?? '');

    final bool verified = userMap['is_verified'] == true ||
        userMap['is_verified_peer'] == true ||
        json['is_verified'] == true ||
        json['is_verified_peer'] == true;

    final bool bookmarked = userMap['is_bookmark'] == true ||
        userMap['is_bookmarked'] == true ||
        json['is_bookmark'] == true ||
        json['is_bookmarked'] == true;

    final bool following = userMap['is_following'] == true ||
        json['is_following'] == true;

    final bool online = userMap['is_online'] == true ||
        userMap['is_online'] == 1 ||
        userMap['is_online'] == '1' ||
        userMap['online_status'] == 'online' ||
        json['is_online'] == true ||
        json['is_online'] == 1 ||
        json['is_online'] == '1' ||
        json['online_status'] == 'online';

    String connStatus = 'none';
    if (json['is_connected'] == true ||
        userMap['is_connected'] == true ||
        json['is_approved'] == true ||
        userMap['is_approved'] == true ||
        json['connected_at'] != null) {
      connStatus = 'connected';
    } else if (json['connection_status'] != null &&
        json['connection_status'].toString().isNotEmpty &&
        json['connection_status'].toString() != 'null') {
      connStatus = json['connection_status'].toString();
    } else if (userMap['connection_status'] != null &&
        userMap['connection_status'].toString().isNotEmpty &&
        userMap['connection_status'].toString() != 'null') {
      connStatus = userMap['connection_status'].toString();
    } else if (json['is_requested'] == true || userMap['is_requested'] == true) {
      connStatus = 'pending_sent';
    }

    return PeerModel(
      id: userMap['id']?.toString() ?? json['id']?.toString() ?? '',
      displayName: name,
      firstName: fName.isNotEmpty ? fName : null,
      lastName: lName.isNotEmpty ? lName : null,
      profilePhotoUrl: userMap['profile_photo_url']?.toString() ??
          userMap['profile_photo_image']?.toString() ??
          userMap['avatar']?.toString() ??
          json['profile_photo_url']?.toString(),
      companyName: userMap['company_name']?.toString() ??
          userMap['company']?.toString() ??
          json['company_name']?.toString(),
      city: cityName,
      designation: userMap['designation']?.toString() ??
          userMap['position']?.toString() ??
          json['designation']?.toString(),
      category: categoryStr,
      lifeImpactedCount: impact,
      isVerified: verified,
      isBookmarked: bookmarked,
      isFollowing: following,
      isOnline: online,
      connectionStatus: connStatus,
    );
  }

  PeerModel copyWith({
    String? id,
    String? displayName,
    String? firstName,
    String? lastName,
    String? profilePhotoUrl,
    String? companyName,
    String? city,
    String? designation,
    String? category,
    int? lifeImpactedCount,
    bool? isVerified,
    bool? isBookmarked,
    bool? isFollowing,
    bool? isOnline,
    String? connectionStatus,
  }) {
    return PeerModel(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      profilePhotoUrl: profilePhotoUrl ?? this.profilePhotoUrl,
      companyName: companyName ?? this.companyName,
      city: city ?? this.city,
      designation: designation ?? this.designation,
      category: category ?? this.category,
      lifeImpactedCount: lifeImpactedCount ?? this.lifeImpactedCount,
      isVerified: isVerified ?? this.isVerified,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      isFollowing: isFollowing ?? this.isFollowing,
      isOnline: isOnline ?? this.isOnline,
      connectionStatus: connectionStatus ?? this.connectionStatus,
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
      'city': city,
      'designation': designation,
      'category': category,
      'life_impacted_count': lifeImpactedCount,
      'is_verified': isVerified,
      'is_bookmarked': isBookmarked,
      'is_following': isFollowing,
      'is_online': isOnline,
      'connection_status': connectionStatus,
    };
  }

  PeerEntity toEntity() {
    return PeerEntity(
      id: id,
      displayName: displayName,
      firstName: firstName,
      lastName: lastName,
      profilePhotoUrl: profilePhotoUrl,
      companyName: companyName,
      city: city,
      designation: designation,
      category: category,
      lifeImpactedCount: lifeImpactedCount,
      isVerified: isVerified,
      isBookmarked: isBookmarked,
      isFollowing: isFollowing,
      isOnline: isOnline,
      connectionStatus: connectionStatus,
    );
  }
}
