import '../../domain/entities/top_builder_entity.dart';

class TopBuilderModel {
  final String id;
  final String name;
  final String? firstName;
  final String? lastName;
  final String city;
  final String company;
  final int lifeImpactedCount;
  final int introducedCount;
  final String avatarUrl;
  final String membershipStatus;
  final String designation;
  final String category;
  final bool isBookmarked;
  final bool isFollowing;
  final bool isVerified;
  final bool isPro;
  final bool isConnected;
  final String connectionStatus;
  final bool isRequested;
  final bool canSendConnectionRequest;
  final int matchPercentage;
  final int rank;
  final int introducedMembersCount;

  const TopBuilderModel({
    required this.id,
    required this.name,
    this.firstName,
    this.lastName,
    this.city = '',
    this.company = '',
    this.lifeImpactedCount = 0,
    this.introducedCount = 0,
    this.avatarUrl = '',
    this.membershipStatus = '',
    this.designation = '',
    this.category = '',
    this.isBookmarked = false,
    this.isFollowing = false,
    this.isVerified = false,
    this.isPro = false,
    this.isConnected = false,
    this.connectionStatus = 'none',
    this.isRequested = false,
    this.canSendConnectionRequest = true,
    this.matchPercentage = 0,
    this.rank = 0,
    this.introducedMembersCount = 0,
  });

  factory TopBuilderModel.fromJson(Map<String, dynamic> json, {int rank = 0}) {
    final photoUrl = (json['profile_photo_url'] ??
            json['profile_photo_image'] ??
            json['profile_image'] ??
            json['avatar_url'] ??
            json['avatar'] ??
            '')
        .toString();

    final isConnectedVal =
        json['is_connected'] == true || json['is_connected'] == 1;
    final isRequestedVal =
        json['is_requested'] == true || json['is_requested'] == 1;
    String connStatus = json['connection_status']?.toString() ?? '';
    if (connStatus.isEmpty || connStatus == 'null') {
      if (isConnectedVal) {
        connStatus = 'connected';
      } else if (isRequestedVal) {
        connStatus = 'pending';
      } else {
        connStatus = 'none';
      }
    }

    final firstName = json['first_name']?.toString();
    final lastName = json['last_name']?.toString();
    String displayName = json['name']?.toString() ?? '';
    if (displayName.isEmpty && (firstName != null || lastName != null)) {
      displayName = '${firstName ?? ''} ${lastName ?? ''}'.trim();
    }
    if (displayName.isEmpty) {
      displayName = json['display_name']?.toString() ?? 'Community Builder';
    }

    return TopBuilderModel(
      id: json['id']?.toString() ?? json['user_id']?.toString() ?? '',
      name: displayName,
      firstName: firstName,
      lastName: lastName,
      city: json['city']?.toString() ?? '',
      company: json['company_name']?.toString() ??
          json['company']?.toString() ??
          '',
      lifeImpactedCount: (json['life_impacted_count'] as num?)?.toInt() ?? 0,
      introducedCount: (json['introduced_count'] ??
          json['introduced_members_count'] ??
          json['total_introduced'] ??
          json['count'] ??
          0) as int,
      avatarUrl: photoUrl,
      membershipStatus: json['membership_status']?.toString() ?? '',
      designation: json['designation']?.toString() ?? '',
      category: json['level4_category']?.toString() ??
          json['category']?.toString() ??
          '',
      isBookmarked: json['is_bookmark'] == true ||
          json['is_bookmarked'] == true ||
          json['is_bookmark'] == 1,
      isFollowing: json['is_following'] == true || json['is_following'] == 1,
      isVerified: json['is_verified'] == true || json['is_verified'] == 1,
      isPro: json['is_pro'] == true || json['is_pro'] == 1,
      isConnected: isConnectedVal,
      connectionStatus: connStatus,
      isRequested: isRequestedVal,
      canSendConnectionRequest: json['can_send_connection_request'] == true ||
          json['can_send_connection_request'] == 1,
      matchPercentage: (json['match_percentage'] as num?)?.toInt() ?? 0,
      rank: rank > 0 ? rank : ((json['rank'] as num?)?.toInt() ?? 0),
      introducedMembersCount: (json['introduced_members_count'] ??
          json['introduced_count'] ??
          0) as int,
    );
  }

  TopBuilderEntity toEntity() {
    return TopBuilderEntity(
      id: id,
      name: name,
      firstName: firstName,
      lastName: lastName,
      city: city,
      company: company,
      lifeImpactedCount: lifeImpactedCount,
      introducedCount: introducedCount,
      avatarUrl: avatarUrl,
      membershipStatus: membershipStatus,
      designation: designation,
      category: category,
      isBookmarked: isBookmarked,
      isFollowing: isFollowing,
      isVerified: isVerified,
      isPro: isPro,
      isConnected: isConnected,
      connectionStatus: connectionStatus,
      isRequested: isRequested,
      canSendConnectionRequest: canSendConnectionRequest,
      matchPercentage: matchPercentage,
      rank: rank,
      introducedMembersCount: introducedMembersCount,
    );
  }
}
