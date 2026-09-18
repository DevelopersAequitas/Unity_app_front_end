import '../../../../core/constants/app_environment.dart';
import '../../domain/entities/leaderboard_entry_entity.dart';

class LeaderboardEntryModel extends LeaderboardEntryEntity {
  const LeaderboardEntryModel({
    required super.id,
    required super.userId,
    required super.name,
    super.firstName,
    super.lastName,
    super.profilePhotoUrl,
    super.designation,
    super.companyName,
    super.city,
    super.category,
    super.coins = 0,
    super.impactCount,
    super.rank = 0,
    super.isCurrentUser = false,
    super.isVerified = false,
    super.isPro = false,
    super.isBookmark = false,
    super.isFollowing = false,
    super.isConnected = false,
    super.connectionStatus,
    super.isRequested = false,
    super.canSendConnectionRequest = true,
    super.coinMedalRank,
    super.coinMilestoneTitle,
    super.coinMilestoneMeaning,
    super.contributionAwardName,
    super.contributionAwardRecognition,
    super.recognitionCaption,
  });

  factory LeaderboardEntryModel.fromJson(Map<String, dynamic> json, {int? fallbackRank}) {
    Map<String, dynamic>? userMap;
    if (json['user'] is Map<String, dynamic>) {
      userMap = json['user'] as Map<String, dynamic>;
    } else if (json['member'] is Map<String, dynamic>) {
      userMap = json['member'] as Map<String, dynamic>;
    }

    final id = (json['id'] ?? userMap?['id'] ?? json['user_id'] ?? '').toString();
    final userId = (json['user_id'] ?? userMap?['id'] ?? id).toString();

    final firstName = (json['first_name'] ?? userMap?['first_name'])?.toString();
    final lastName = (json['last_name'] ?? userMap?['last_name'])?.toString();

    final name = (json['display_name'] ??
            json['name'] ??
            json['full_name'] ??
            userMap?['display_name'] ??
            userMap?['name'] ??
            userMap?['full_name'] ??
            (firstName != null && lastName != null ? '$firstName $lastName' : null) ??
            'Peers Member')
        .toString();

    String? photoUrl;
    final rawPhoto = json['profile_photo'] ??
        json['profile_photo_url'] ??
        json['avatar'] ??
        json['image'] ??
        userMap?['profile_photo'] ??
        userMap?['profile_photo_url'] ??
        userMap?['avatar'];

    if (rawPhoto is Map<String, dynamic>) {
      photoUrl = (rawPhoto['url'] ??
              rawPhoto['file_url'] ??
              rawPhoto['file_id'] ??
              rawPhoto['id'])
          ?.toString();
    } else if (rawPhoto != null) {
      photoUrl = rawPhoto.toString();
    }

    if (photoUrl != null &&
        photoUrl.isNotEmpty &&
        !photoUrl.startsWith('http') &&
        !photoUrl.startsWith('blob:')) {
      photoUrl = '${AppEnvironment.baseUrl}/files/$photoUrl';
    }

    final designation = (json['designation'] ??
            json['job_title'] ??
            json['title'] ??
            json['category'] ??
            json['coin_milestone_title'] ??
            json['coin_medal_rank'] ??
            userMap?['designation'] ??
            userMap?['job_title'] ??
            userMap?['category'])
        ?.toString();

    final companyName = (json['company_name'] ??
            json['company'] ??
            userMap?['company_name'] ??
            userMap?['company'])
        ?.toString();

    final city = (json['city'] ??
            json['location'] ??
            userMap?['city'] ??
            userMap?['location'])
        ?.toString();

    int coins = 0;
    if (json['coins_balance'] != null) {
      coins = int.tryParse(json['coins_balance'].toString()) ?? 0;
    } else if (json['coins'] != null) {
      coins = int.tryParse(json['coins'].toString()) ?? 0;
    } else if (json['total_coins'] != null) {
      coins = int.tryParse(json['total_coins'].toString()) ?? 0;
    } else if (json['points'] != null) {
      coins = int.tryParse(json['points'].toString()) ?? 0;
    } else if (userMap?['coins_balance'] != null) {
      coins = int.tryParse(userMap!['coins_balance'].toString()) ?? 0;
    }

    int? impactCount;
    if (json['life_impacted_count'] != null) {
      impactCount = int.tryParse(json['life_impacted_count'].toString());
    } else if (json['impact_count'] != null) {
      impactCount = int.tryParse(json['impact_count'].toString());
    } else if (userMap?['life_impacted_count'] != null) {
      impactCount = int.tryParse(userMap!['life_impacted_count'].toString());
    }

    int rank = 0;
    if (json['rank'] != null) {
      rank = int.tryParse(json['rank'].toString()) ?? 0;
    } else if (json['position'] != null) {
      rank = int.tryParse(json['position'].toString()) ?? 0;
    } else if (fallbackRank != null) {
      rank = fallbackRank;
    }

    final connectionStatus = (json['connection_status'] ?? userMap?['connection_status'])?.toString();

    final isCurrentUser = connectionStatus == 'self' ||
        json['is_current_user'] == true ||
        json['is_me'] == true ||
        json['is_self'] == true;

    final coinMedalRank = (json['coin_medal_rank'] ?? userMap?['coin_medal_rank'])?.toString();
    final coinMilestoneTitle = (json['coin_milestone_title'] ?? userMap?['coin_milestone_title'])?.toString();
    final coinMilestoneMeaning = (json['coin_milestone_meaning'] ?? userMap?['coin_milestone_meaning'])?.toString();
    final contributionAwardName = (json['contribution_award_name'] ?? userMap?['contribution_award_name'])?.toString();
    final contributionAwardRecognition = (json['contribution_award_recognition'] ?? userMap?['contribution_award_recognition'])?.toString();

    final recognitionCaption = coinMilestoneMeaning ??
        coinMilestoneTitle ??
        json['recognition_caption']?.toString() ??
        json['caption']?.toString() ??
        json['tagline']?.toString() ??
        contributionAwardRecognition ??
        contributionAwardName ??
        userMap?['coin_milestone_meaning']?.toString();

    final category = (json['category'] ??
            json['level4_category'] ??
            json['level3_category'] ??
            userMap?['category'] ??
            userMap?['level4_category'])
        ?.toString();

    final isVerified = json['is_verified'] == true ||
        userMap?['is_verified'] == true;

    final isPro = json['is_pro'] == true ||
        userMap?['is_pro'] == true;

    final isBookmark = json['is_bookmark'] == true ||
        userMap?['is_bookmark'] == true;

    final isFollowing = json['is_following'] == true ||
        userMap?['is_following'] == true;

    final isConnected = json['is_connected'] == true ||
        userMap?['is_connected'] == true;

    final isRequested = json['is_requested'] == true ||
        userMap?['is_requested'] == true;

    final canSendConnectionRequest = (json['can_send_connection_request'] as bool?) ??
        (userMap?['can_send_connection_request'] as bool?) ??
        (isCurrentUser ? false : true);

    return LeaderboardEntryModel(
      id: id,
      userId: userId,
      name: name,
      firstName: firstName,
      lastName: lastName,
      profilePhotoUrl: photoUrl,
      designation: designation,
      companyName: companyName,
      city: city,
      category: category,
      coins: coins,
      impactCount: impactCount,
      rank: rank,
      isCurrentUser: isCurrentUser,
      isVerified: isVerified,
      isPro: isPro,
      isBookmark: isBookmark,
      isFollowing: isFollowing,
      isConnected: isConnected,
      connectionStatus: connectionStatus,
      isRequested: isRequested,
      canSendConnectionRequest: canSendConnectionRequest,
      coinMedalRank: coinMedalRank,
      coinMilestoneTitle: coinMilestoneTitle,
      coinMilestoneMeaning: coinMilestoneMeaning,
      contributionAwardName: contributionAwardName,
      contributionAwardRecognition: contributionAwardRecognition,
      recognitionCaption: recognitionCaption,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'display_name': name,
      'first_name': firstName,
      'last_name': lastName,
      'profile_photo': profilePhotoUrl != null ? {'url': profilePhotoUrl} : null,
      'designation': designation,
      'company_name': companyName,
      'city': city,
      'category': category,
      'coins_balance': coins,
      'life_impacted_count': impactCount,
      'rank': rank,
      'is_current_user': isCurrentUser,
      'is_verified': isVerified,
      'is_pro': isPro,
      'is_bookmark': isBookmark,
      'is_following': isFollowing,
      'is_connected': isConnected,
      'connection_status': connectionStatus,
      'is_requested': isRequested,
      'can_send_connection_request': canSendConnectionRequest,
      'coin_medal_rank': coinMedalRank,
      'coin_milestone_title': coinMilestoneTitle,
      'coin_milestone_meaning': coinMilestoneMeaning,
      'contribution_award_name': contributionAwardName,
      'contribution_award_recognition': contributionAwardRecognition,
      'recognition_caption': recognitionCaption,
    };
  }
}
