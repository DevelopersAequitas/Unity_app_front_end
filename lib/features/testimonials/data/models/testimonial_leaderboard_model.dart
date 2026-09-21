import '../../domain/entities/testimonial_leaderboard_entity.dart';

class TestimonialLeaderboardModel {
  final int rank;
  final String id;
  final String displayName;
  final String? firstName;
  final String? lastName;
  final String? companyName;
  final String? designation;
  final String? category;
  final String? city;
  final String? profilePhotoUrl;
  final bool isConnected;
  final String connectionStatus;
  final bool isRequested;
  final bool canSendConnectionRequest;
  final bool isFollowing;
  final bool isBookmark;
  final bool isPro;
  final bool isVerified;
  final num score;
  final int testimonialsCount;
  final num avgRating;

  const TestimonialLeaderboardModel({
    required this.rank,
    required this.id,
    required this.displayName,
    this.firstName,
    this.lastName,
    this.companyName,
    this.designation,
    this.category,
    this.city,
    this.profilePhotoUrl,
    this.isConnected = false,
    this.connectionStatus = 'none',
    this.isRequested = false,
    this.canSendConnectionRequest = true,
    this.isFollowing = false,
    this.isBookmark = false,
    this.isPro = false,
    this.isVerified = false,
    this.score = 0,
    this.testimonialsCount = 0,
    this.avgRating = 0,
  });

  factory TestimonialLeaderboardModel.fromJson(
    Map<String, dynamic> json, {
    int fallbackRank = 0,
  }) {
    final photoUrl = (json['profile_photo_url'] ??
            (json['profile_photo'] is Map
                ? json['profile_photo']['url']
                : null) ??
            json['profile_image'] ??
            json['avatar_url'] ??
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
        connStatus = 'pending_sent';
      } else {
        connStatus = 'none';
      }
    }

    final firstName = json['first_name']?.toString();
    final lastName = json['last_name']?.toString();
    String displayName = json['display_name']?.toString() ??
        json['name']?.toString() ??
        '';
    if (displayName.isEmpty && (firstName != null || lastName != null)) {
      displayName = '${firstName ?? ''} ${lastName ?? ''}'.trim();
    }
    if (displayName.isEmpty) displayName = 'Peer';

    return TestimonialLeaderboardModel(
      rank: (json['rank'] as num?)?.toInt() ?? fallbackRank,
      id: json['id']?.toString() ?? json['user_id']?.toString() ?? '',
      displayName: displayName,
      firstName: firstName,
      lastName: lastName,
      companyName: json['company_name']?.toString() ?? json['company']?.toString(),
      designation: json['designation']?.toString(),
      category: json['category']?.toString() ?? json['level4_category']?.toString(),
      city: json['city']?.toString(),
      profilePhotoUrl: photoUrl.isNotEmpty ? photoUrl : null,
      isConnected: isConnectedVal,
      connectionStatus: connStatus,
      isRequested: isRequestedVal,
      canSendConnectionRequest: json['can_send_connection_request'] != false,
      isFollowing: json['is_following'] == true || json['is_following'] == 1,
      isBookmark: json['is_bookmark'] == true ||
          json['is_bookmarked'] == true ||
          json['is_bookmark'] == 1,
      isPro: json['is_pro'] == true || json['is_pro'] == 1,
      isVerified: json['is_verified'] == true || json['is_verified'] == 1,
      score: (json['score'] as num?) ?? 0,
      testimonialsCount: (json['testimonials_count'] as num?)?.toInt() ??
          (json['testimonials'] as num?)?.toInt() ??
          (json['count'] as num?)?.toInt() ??
          0,
      avgRating: (json['avg_rating'] as num?) ?? (json['rating'] as num?) ?? 0,
    );
  }

  TestimonialLeaderboardEntity toEntity() {
    return TestimonialLeaderboardEntity(
      rank: rank,
      id: id,
      displayName: displayName,
      firstName: firstName,
      lastName: lastName,
      companyName: companyName,
      designation: designation,
      category: category,
      city: city,
      profilePhotoUrl: profilePhotoUrl,
      isConnected: isConnected,
      connectionStatus: connectionStatus,
      isRequested: isRequested,
      canSendConnectionRequest: canSendConnectionRequest,
      isFollowing: isFollowing,
      isBookmark: isBookmark,
      isPro: isPro,
      isVerified: isVerified,
      score: score,
      testimonialsCount: testimonialsCount,
      avgRating: avgRating,
    );
  }
}
