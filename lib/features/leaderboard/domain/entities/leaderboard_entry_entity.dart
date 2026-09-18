import 'package:equatable/equatable.dart';

class LeaderboardEntryEntity extends Equatable {
  final String id;
  final String userId;
  final String name;
  final String? firstName;
  final String? lastName;
  final String? profilePhotoUrl;
  final String? designation;
  final String? companyName;
  final String? city;
  final String? category;
  final int coins;
  final int? impactCount;
  final int rank;
  final bool isCurrentUser;
  final bool isVerified;
  final bool isPro;
  final bool isBookmark;
  final bool isFollowing;
  final bool isConnected;
  final String? connectionStatus;
  final bool isRequested;
  final bool canSendConnectionRequest;
  final String? coinMedalRank;
  final String? coinMilestoneTitle;
  final String? coinMilestoneMeaning;
  final String? contributionAwardName;
  final String? contributionAwardRecognition;
  final String? recognitionCaption;

  const LeaderboardEntryEntity({
    required this.id,
    required this.userId,
    required this.name,
    this.firstName,
    this.lastName,
    this.profilePhotoUrl,
    this.designation,
    this.companyName,
    this.city,
    this.category,
    this.coins = 0,
    this.impactCount,
    this.rank = 0,
    this.isCurrentUser = false,
    this.isVerified = false,
    this.isPro = false,
    this.isBookmark = false,
    this.isFollowing = false,
    this.isConnected = false,
    this.connectionStatus,
    this.isRequested = false,
    this.canSendConnectionRequest = true,
    this.coinMedalRank,
    this.coinMilestoneTitle,
    this.coinMilestoneMeaning,
    this.contributionAwardName,
    this.contributionAwardRecognition,
    this.recognitionCaption,
  });

  String get subtitle {
    final d = designation?.trim() ?? '';
    final c = companyName?.trim() ?? '';
    if (d.isNotEmpty && c.isNotEmpty) return '$d · $c';
    if (d.isNotEmpty) return d;
    if (c.isNotEmpty) return c;
    return city?.trim() ?? '';
  }

  String get defaultPodiumCaption {
    if (coinMilestoneTitle != null && coinMilestoneTitle!.trim().isNotEmpty) {
      return coinMilestoneTitle!.trim();
    }
    if (recognitionCaption != null &&
        recognitionCaption!.isNotEmpty &&
        recognitionCaption!.length <= 30 &&
        !recognitionCaption!.contains('.')) {
      return recognitionCaption!;
    }
    switch (rank) {
      case 1:
        return 'Making the biggest impact';
      case 2:
        return 'Inspiring globally';
      case 3:
        return 'Driving change';
      default:
        return 'Making an impact';
    }
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        name,
        firstName,
        lastName,
        profilePhotoUrl,
        designation,
        companyName,
        city,
        category,
        coins,
        impactCount,
        rank,
        isCurrentUser,
        isVerified,
        isPro,
        isBookmark,
        isFollowing,
        isConnected,
        connectionStatus,
        isRequested,
        canSendConnectionRequest,
        coinMedalRank,
        coinMilestoneTitle,
        coinMilestoneMeaning,
        contributionAwardName,
        contributionAwardRecognition,
        recognitionCaption,
      ];
}
