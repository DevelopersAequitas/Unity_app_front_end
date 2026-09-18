import '../../domain/entities/network_member_entity.dart';

class NetworkMemberModel {
  final String id;
  final String name;
  final String? firstName;
  final String? lastName;
  final String businessName;
  final String designation;
  final String city;
  final String category;
  final String avatarUrl;
  final String joinedDate;
  final String status;
  final String referralType;
  final String referralTitle;
  final int coinsEarned;
  final bool isVerified;
  final bool isPro;
  final bool isBookmarked;
  final bool isFollowing;
  final bool isConnected;
  final String connectionStatus;
  final int? lifeImpactedCount;

  const NetworkMemberModel({
    required this.id,
    required this.name,
    this.firstName,
    this.lastName,
    this.businessName = '',
    this.designation = '',
    this.city = '',
    this.category = '',
    this.avatarUrl = '',
    this.joinedDate = '',
    this.status = 'active',
    this.referralType = '',
    this.referralTitle = '',
    this.coinsEarned = 0,
    this.isVerified = false,
    this.isPro = false,
    this.isBookmarked = false,
    this.isFollowing = false,
    this.isConnected = false,
    this.connectionStatus = 'none',
    this.lifeImpactedCount,
  });

  factory NetworkMemberModel.fromJson(Map<String, dynamic> json, {String? currentUserId}) {
    Map<String, dynamic>? userObj;
    final givenBy = json['given_by_user'] is Map<String, dynamic>
        ? json['given_by_user'] as Map<String, dynamic>
        : (json['given_by'] is Map<String, dynamic> ? json['given_by'] as Map<String, dynamic> : null);
    final receivedBy = json['received_by_user'] is Map<String, dynamic>
        ? json['received_by_user'] as Map<String, dynamic>
        : (json['given_to'] is Map<String, dynamic> ? json['given_to'] as Map<String, dynamic> : null);

    if (json['is_given'] == true) {
      userObj = receivedBy ?? givenBy;
    } else if (json['is_received'] == true) {
      userObj = givenBy ?? receivedBy;
    } else if (currentUserId != null && currentUserId.isNotEmpty) {
      if (givenBy != null && (givenBy['id']?.toString() == currentUserId || givenBy['user_id']?.toString() == currentUserId)) {
        userObj = receivedBy ?? givenBy;
      } else if (receivedBy != null && (receivedBy['id']?.toString() == currentUserId || receivedBy['user_id']?.toString() == currentUserId)) {
        userObj = givenBy ?? receivedBy;
      }
    }
    userObj ??= receivedBy ?? givenBy ?? (json['user'] is Map<String, dynamic> ? json['user'] as Map<String, dynamic> : json);

    final rawName = userObj['name']?.toString() ??
        userObj['display_name']?.toString() ??
        json['name']?.toString() ??
        json['title']?.toString() ??
        '';
    final fName = userObj['first_name']?.toString();
    final lName = userObj['last_name']?.toString();
    final computedName = rawName.isNotEmpty
        ? rawName
        : '${fName ?? ''} ${lName ?? ''}'.trim();

    final status = json['status']?.toString() ??
        json['reward_status']?.toString() ??
        userObj['membership_status']?.toString() ??
        'Active';

    return NetworkMemberModel(
      id: userObj['id']?.toString() ??
          userObj['user_id']?.toString() ??
          json['id']?.toString() ??
          '',
      name: computedName.isNotEmpty ? computedName : 'Peer',
      firstName: fName,
      lastName: lName,
      businessName: userObj['company_name']?.toString() ??
          userObj['business_name']?.toString() ??
          json['company_name']?.toString() ??
          json['business_name']?.toString() ??
          '',
      designation: userObj['designation']?.toString() ??
          json['designation']?.toString() ??
          '',
      city: userObj['city']?.toString() ?? json['city']?.toString() ?? '',
      category: userObj['level4_category']?.toString() ??
          userObj['category']?.toString() ??
          json['category']?.toString() ??
          '',
      avatarUrl: userObj['profile_photo_url']?.toString() ??
          userObj['profile_photo_image']?.toString() ??
          userObj['profile_image']?.toString() ??
          userObj['avatar_url']?.toString() ??
          userObj['avatar']?.toString() ??
          '',
      joinedDate: json['referral_date']?.toString() ??
          json['created_at']?.toString() ??
          json['joined_at']?.toString() ??
          '',
      status: status,
      referralType: json['referral_type']?.toString() ??
          json['source_module']?.toString() ??
          '',
      referralTitle: json['title']?.toString() ?? json['referral_of']?.toString() ?? '',
      coinsEarned: (json['coins'] ?? json['coins_earned'] ?? 0) as int,
      isVerified: userObj['is_verified'] == true || userObj['is_verified'] == 1,
      isPro: userObj['is_pro'] == true || userObj['is_pro'] == 1,
      isBookmarked: userObj['is_bookmark'] == true || userObj['is_bookmark'] == 1,
      isFollowing: userObj['is_following'] == true || userObj['is_following'] == 1,
      isConnected: userObj['is_connected'] == true || userObj['is_connected'] == 1,
      connectionStatus: userObj['connection_status']?.toString() ?? 'none',
      lifeImpactedCount: userObj['life_impacted_count'] is int
          ? userObj['life_impacted_count'] as int
          : int.tryParse(userObj['life_impacted_count']?.toString() ?? ''),
    );
  }

  NetworkMemberEntity toEntity() {
    return NetworkMemberEntity(
      id: id,
      name: name,
      firstName: firstName,
      lastName: lastName,
      businessName: businessName,
      designation: designation,
      city: city,
      category: category,
      avatarUrl: avatarUrl,
      joinedDate: joinedDate,
      status: status,
      referralType: referralType,
      referralTitle: referralTitle,
      coinsEarned: coinsEarned,
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
