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
    // The new API wraps social status inside a "peer" sub-object
    final peerObj = json['peer'] is Map<String, dynamic>
        ? json['peer'] as Map<String, dynamic>
        : null;

    // Legacy fields — referral activity style (given_by_user / received_by_user)
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
    // peerObj takes priority for social data; userObj is the metadata fallback
    userObj ??= peerObj ?? receivedBy ?? givenBy ?? (json['user'] is Map<String, dynamic> ? json['user'] as Map<String, dynamic> : null) ?? json;

    final socialSrc = peerObj ?? userObj; // always prefer peer obj for booleans

    final rawName = json['name']?.toString() ??
        peerObj?['display_name']?.toString() ??
        peerObj?['name']?.toString() ??
        userObj['name']?.toString() ??
        userObj['display_name']?.toString() ??
        json['title']?.toString() ??
        '';
    final fName = peerObj?['first_name']?.toString() ?? userObj['first_name']?.toString();
    final lName = peerObj?['last_name']?.toString() ?? userObj['last_name']?.toString();
    final computedName = rawName.isNotEmpty
        ? rawName
        : '${fName ?? ''} ${lName ?? ''}'.trim();

    final status = json['reward_status']?.toString() ??
        json['status']?.toString() ??
        socialSrc['membership_status']?.toString() ??
        'Granted';

    final referralCode = json['referral_code']?.toString() ?? '';
    final refTitle = referralCode.isNotEmpty
        ? 'Referral Code: $referralCode'
        : (json['title']?.toString() ?? 'Joined via Referral');

    final int coins = json['coins'] is num
        ? (json['coins'] as num).toInt()
        : (json['coins_earned'] is num
            ? (json['coins_earned'] as num).toInt()
            : int.tryParse(json['coins']?.toString() ?? '') ?? 0);

    bool parseBool(dynamic val) =>
        val == true || val == 1 || val?.toString() == 'true';

    return NetworkMemberModel(
      id: peerObj?['id']?.toString() ??
          peerObj?['user_id']?.toString() ??
          json['user_id']?.toString() ??
          json['id']?.toString() ??
          userObj['id']?.toString() ??
          userObj['user_id']?.toString() ??
          '',
      name: computedName.isNotEmpty ? computedName : 'Peer',
      firstName: fName,
      lastName: lName,
      businessName: json['business_name']?.toString() ??
          json['company_name']?.toString() ??
          peerObj?['company_name']?.toString() ??
          userObj['company_name']?.toString() ??
          userObj['business_name']?.toString() ??
          '',
      designation: json['position']?.toString() ??
          json['designation']?.toString() ??
          peerObj?['designation']?.toString() ??
          userObj['designation']?.toString() ??
          '',
      city: peerObj?['city']?.toString() ??
          userObj['city']?.toString() ??
          json['city']?.toString() ??
          '',
      category: peerObj?['level4_category']?.toString() ??
          userObj['level4_category']?.toString() ??
          userObj['category']?.toString() ??
          json['category']?.toString() ??
          '',
      avatarUrl: peerObj?['profile_photo_image']?.toString() ??
          peerObj?['profile_photo_url']?.toString() ??
          json['profile_photo_url']?.toString() ??
          userObj['profile_photo_url']?.toString() ??
          userObj['profile_photo_image']?.toString() ??
          userObj['profile_image']?.toString() ??
          userObj['avatar_url']?.toString() ??
          userObj['avatar']?.toString() ??
          '',
      joinedDate: json['registered_at']?.toString() ??
          json['created_at']?.toString() ??
          json['joined_at']?.toString() ??
          json['referral_date']?.toString() ??
          '',
      status: status,
      referralType: json['referral_type']?.toString() ?? 'referral',
      referralTitle: refTitle,
      coinsEarned: coins,
      isVerified: parseBool(socialSrc['is_verified']),
      isPro: parseBool(socialSrc['is_pro']),
      isBookmarked: parseBool(socialSrc['is_bookmark']) || parseBool(socialSrc['is_bookmarked']),
      isFollowing: parseBool(socialSrc['is_following']),
      isConnected: parseBool(socialSrc['is_connected']),
      connectionStatus: socialSrc['connection_status']?.toString() ?? 'none',
      lifeImpactedCount: socialSrc['life_impacted_count'] is int
          ? socialSrc['life_impacted_count'] as int
          : int.tryParse(socialSrc['life_impacted_count']?.toString() ?? ''),
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
