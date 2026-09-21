import 'package:equatable/equatable.dart';

class MilestoneItemEntity extends Equatable {
  final String? transactionId;
  final int amount;
  final int balanceAfter;
  final String reference;
  final String? medalRank;
  final String? title;
  final String? meaning;
  final int threshold;
  final int coinsEarned;
  final DateTime? createdAt;
  final DateTime? achievedAt;

  const MilestoneItemEntity({
    this.transactionId,
    this.amount = 0,
    this.balanceAfter = 0,
    this.reference = '',
    this.medalRank,
    this.title,
    this.meaning,
    this.threshold = 0,
    this.coinsEarned = 0,
    this.createdAt,
    this.achievedAt,
  });

  @override
  List<Object?> get props => [
        transactionId,
        amount,
        balanceAfter,
        reference,
        medalRank,
        title,
        meaning,
        threshold,
        coinsEarned,
        createdAt,
        achievedAt,
      ];
}

class NextMilestoneEntity extends Equatable {
  final String medalRank;
  final String title;
  final int threshold;
  final int coinsNeeded;
  final double progressPercentage;

  const NextMilestoneEntity({
    required this.medalRank,
    required this.title,
    required this.threshold,
    required this.coinsNeeded,
    required this.progressPercentage,
  });

  @override
  List<Object?> get props => [
        medalRank,
        title,
        threshold,
        coinsNeeded,
        progressPercentage,
      ];
}

class BadgeDetailEntity extends Equatable {
  final String badgeId;
  final String title;
  final String type;
  final String description;
  final String badgeImageUrl;
  final int requiredCount;
  final int achievedCount;
  final String status;
  final DateTime? earnedAt;
  final DateTime? revokedAt;

  const BadgeDetailEntity({
    required this.badgeId,
    required this.title,
    required this.type,
    required this.description,
    required this.badgeImageUrl,
    required this.requiredCount,
    required this.achievedCount,
    required this.status,
    this.earnedAt,
    this.revokedAt,
  });

  @override
  List<Object?> get props => [
        badgeId,
        title,
        type,
        description,
        badgeImageUrl,
        requiredCount,
        achievedCount,
        status,
        earnedAt,
        revokedAt,
      ];
}

class LatestMilestoneEntity extends Equatable {
  final int currentCoinsBalance;
  final int totalLifeImpacted;
  final MilestoneItemEntity? currentMilestone;
  final NextMilestoneEntity? nextMilestone;
  final List<BadgeDetailEntity> lifeImpactBadges;
  final List<BadgeDetailEntity> coinsBadges;
  final List<BadgeDetailEntity> memberIntroBadges;
  final int totalBadgesCount;

  const LatestMilestoneEntity({
    required this.currentCoinsBalance,
    this.totalLifeImpacted = 0,
    this.currentMilestone,
    this.nextMilestone,
    this.lifeImpactBadges = const [],
    this.coinsBadges = const [],
    this.memberIntroBadges = const [],
    this.totalBadgesCount = 0,
  });

  @override
  List<Object?> get props => [
        currentCoinsBalance,
        totalLifeImpacted,
        currentMilestone,
        nextMilestone,
        lifeImpactBadges,
        coinsBadges,
        memberIntroBadges,
        totalBadgesCount,
      ];
}
