import '../../domain/entities/introduced_peer_entity.dart';

class IntroducedPeerModel {
  final String id;
  final String name;
  final String? firstName;
  final String? lastName;
  final String businessName;
  final String designation;
  final String city;
  final String category;
  final String avatarUrl;
  final String status;
  final String introducedDate;
  final bool isVerified;
  final bool isPro;
  final bool isBookmarked;
  final bool isFollowing;
  final bool isConnected;
  final String connectionStatus;
  final int? lifeImpactedCount;

  const IntroducedPeerModel({
    required this.id,
    required this.name,
    this.firstName,
    this.lastName,
    this.businessName = '',
    this.designation = '',
    this.city = '',
    this.category = '',
    this.avatarUrl = '',
    this.status = 'active',
    this.introducedDate = '',
    this.isVerified = false,
    this.isPro = false,
    this.isBookmarked = false,
    this.isFollowing = false,
    this.isConnected = false,
    this.connectionStatus = 'none',
    this.lifeImpactedCount,
  });

  factory IntroducedPeerModel.fromJson(Map<String, dynamic> json) {
    final rawName = json['name']?.toString() ?? json['display_name']?.toString() ?? '';
    final fName = json['first_name']?.toString();
    final lName = json['last_name']?.toString();
    final computedName = rawName.isNotEmpty
        ? rawName
        : '${fName ?? ''} ${lName ?? ''}'.trim();

    return IntroducedPeerModel(
      id: json['id']?.toString() ?? json['user_id']?.toString() ?? '',
      name: computedName.isNotEmpty ? computedName : 'Peer',
      firstName: fName,
      lastName: lName,
      businessName: json['company_name']?.toString() ??
          json['business_name']?.toString() ??
          json['company']?.toString() ??
          '',
      designation: json['designation']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      category: json['level4_category']?.toString() ??
          json['category']?.toString() ??
          '',
      avatarUrl: json['profile_photo_image']?.toString() ??
          json['profile_image']?.toString() ??
          json['profile_photo_url']?.toString() ??
          json['avatar_url']?.toString() ??
          '',
      status: json['status']?.toString() ?? 'Active',
      introducedDate: json['introduced_at']?.toString() ??
          json['created_at']?.toString() ??
          '',
      isVerified: json['is_verified'] == true || json['is_verified'] == 1,
      isPro: json['is_pro'] == true || json['is_pro'] == 1,
      isBookmarked: json['is_bookmark'] == true ||
          json['is_bookmarked'] == true ||
          json['is_bookmark'] == 1,
      isFollowing: json['is_following'] == true || json['is_following'] == 1,
      isConnected: json['is_connected'] == true || json['is_connected'] == 1,
      connectionStatus: json['connection_status']?.toString() ?? 'none',
      lifeImpactedCount: json['life_impacted_count'] is int
          ? json['life_impacted_count'] as int
          : int.tryParse(json['life_impacted_count']?.toString() ?? ''),
    );
  }

  IntroducedPeerEntity toEntity() {
    return IntroducedPeerEntity(
      id: id,
      name: name,
      firstName: firstName,
      lastName: lastName,
      businessName: businessName,
      designation: designation,
      city: city,
      category: category,
      avatarUrl: avatarUrl,
      status: status,
      introducedDate: introducedDate,
      isVerified: isVerified,
      isPro: isPro,
      isBookmarked: isBookmarked,
      isFollowing: isFollowing,
      isConnected: isConnected,
      connectionStatus: connectionStatus,
      lifeImpactedCount: lifeImpactedCount,
    );
  }
}
