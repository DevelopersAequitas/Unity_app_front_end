import '../../../../core/utils/app_date_formatter.dart';
import '../../domain/entities/milestone_entity.dart';

class MilestoneItemModel {
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

  const MilestoneItemModel({
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

  factory MilestoneItemModel.fromJson(Map<String, dynamic> json) {
    return MilestoneItemModel(
      transactionId: json['transaction_id']?.toString() ?? json['id']?.toString(),
      amount: (json['amount'] as num?)?.toInt() ?? 0,
      balanceAfter: (json['balance_after'] as num?)?.toInt() ?? 0,
      reference: json['reference']?.toString() ?? '',
      medalRank: json['medal_rank']?.toString(),
      title: json['title']?.toString(),
      meaning: json['meaning']?.toString(),
      threshold: (json['threshold'] as num?)?.toInt() ??
          (json['coins_earned'] as num?)?.toInt() ??
          0,
      coinsEarned: (json['coins_earned'] as num?)?.toInt() ??
          (json['threshold'] as num?)?.toInt() ??
          0,
      createdAt: AppDateFormatter.parseUtc(json['created_at']),
      achievedAt: AppDateFormatter.parseUtc(json['achieved_at']) ??
          AppDateFormatter.parseUtc(json['created_at']),
    );
  }

  MilestoneItemEntity toEntity() {
    return MilestoneItemEntity(
      transactionId: transactionId,
      amount: amount,
      balanceAfter: balanceAfter,
      reference: reference,
      medalRank: medalRank,
      title: title,
      meaning: meaning,
      threshold: threshold,
      coinsEarned: coinsEarned,
      createdAt: createdAt,
      achievedAt: achievedAt,
    );
  }
}

class NextMilestoneModel {
  final String medalRank;
  final String title;
  final int threshold;
  final int coinsNeeded;
  final double progressPercentage;

  const NextMilestoneModel({
    required this.medalRank,
    required this.title,
    required this.threshold,
    required this.coinsNeeded,
    required this.progressPercentage,
  });

  factory NextMilestoneModel.fromJson(Map<String, dynamic> json) {
    return NextMilestoneModel(
      medalRank: json['medal_rank']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      threshold: (json['threshold'] as num?)?.toInt() ?? 0,
      coinsNeeded: (json['coins_needed'] as num?)?.toInt() ?? 0,
      progressPercentage:
          (json['progress_percentage'] as num?)?.toDouble() ?? 0.0,
    );
  }

  NextMilestoneEntity toEntity() {
    return NextMilestoneEntity(
      medalRank: medalRank,
      title: title,
      threshold: threshold,
      coinsNeeded: coinsNeeded,
      progressPercentage: progressPercentage,
    );
  }
}

class BadgeDetailModel {
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

  const BadgeDetailModel({
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

  factory BadgeDetailModel.fromJson(Map<String, dynamic> json) {
    return BadgeDetailModel(
      badgeId: json['badge_id']?.toString() ?? json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      badgeImageUrl: json['badge_image_url']?.toString() ??
          json['image_url']?.toString() ??
          json['icon_url']?.toString() ??
          '',
      requiredCount: (json['required_count'] as num?)?.toInt() ?? 0,
      achievedCount: (json['achieved_count'] as num?)?.toInt() ?? 0,
      status: json['status']?.toString() ?? 'locked',
      earnedAt: AppDateFormatter.parseUtc(json['earned_at']),
      revokedAt: AppDateFormatter.parseUtc(json['revoked_at']),
    );
  }

  BadgeDetailEntity toEntity() {
    return BadgeDetailEntity(
      badgeId: badgeId,
      title: title,
      type: type,
      description: description,
      badgeImageUrl: badgeImageUrl,
      requiredCount: requiredCount,
      achievedCount: achievedCount,
      status: status,
      earnedAt: earnedAt,
      revokedAt: revokedAt,
    );
  }
}

class LatestMilestoneModel {
  final int currentCoinsBalance;
  final int totalLifeImpacted;
  final MilestoneItemModel? currentMilestone;
  final NextMilestoneModel? nextMilestone;
  final List<BadgeDetailModel> lifeImpactBadges;
  final List<BadgeDetailModel> coinsBadges;
  final List<BadgeDetailModel> memberIntroBadges;
  final int totalBadgesCount;

  const LatestMilestoneModel({
    required this.currentCoinsBalance,
    this.totalLifeImpacted = 0,
    this.currentMilestone,
    this.nextMilestone,
    this.lifeImpactBadges = const [],
    this.coinsBadges = const [],
    this.memberIntroBadges = const [],
    this.totalBadgesCount = 0,
  });

  factory LatestMilestoneModel.fromJson(Map<String, dynamic> json) {
    List<BadgeDetailModel> lifeImpact = [];
    List<BadgeDetailModel> coinsList = [];
    List<BadgeDetailModel> introList = [];

    if (json['badges'] is Map<String, dynamic>) {
      final badgesMap = json['badges'] as Map<String, dynamic>;

      if (badgesMap['life_impact'] is List) {
        lifeImpact = (badgesMap['life_impact'] as List)
            .whereType<Map<String, dynamic>>()
            .map((e) => BadgeDetailModel.fromJson(e))
            .toList();
      }

      if (badgesMap['coins'] is List) {
        coinsList = (badgesMap['coins'] as List)
            .whereType<Map<String, dynamic>>()
            .map((e) => BadgeDetailModel.fromJson(e))
            .toList();
      }

      if (badgesMap['member_introduction'] is List) {
        introList = (badgesMap['member_introduction'] as List)
            .whereType<Map<String, dynamic>>()
            .map((e) => BadgeDetailModel.fromJson(e))
            .toList();
      }
    }

    final int totalCount =
        lifeImpact.length + coinsList.length + introList.length;

    final int lifeImpacted = (json['total_life_impacted'] as num?)?.toInt() ??
        (json['life_impacted_count'] as num?)?.toInt() ??
        (json['total_lives_impacted'] as num?)?.toInt() ??
        (lifeImpact.isNotEmpty
            ? lifeImpact
                .map((e) => e.achievedCount)
                .fold(0, (a, b) => a > b ? a : b)
            : 0);

    return LatestMilestoneModel(
      currentCoinsBalance:
          (json['current_coins_balance'] as num?)?.toInt() ??
          (json['coins_balance'] as num?)?.toInt() ??
          0,
      totalLifeImpacted: lifeImpacted,
      currentMilestone: json['current_milestone'] != null
          ? MilestoneItemModel.fromJson(
              json['current_milestone'] as Map<String, dynamic>)
          : null,
      nextMilestone: json['next_milestone'] != null
          ? NextMilestoneModel.fromJson(
              json['next_milestone'] as Map<String, dynamic>)
          : null,
      lifeImpactBadges: lifeImpact,
      coinsBadges: coinsList,
      memberIntroBadges: introList,
      totalBadgesCount: totalCount,
    );
  }

  LatestMilestoneEntity toEntity() {
    return LatestMilestoneEntity(
      currentCoinsBalance: currentCoinsBalance,
      totalLifeImpacted: totalLifeImpacted,
      currentMilestone: currentMilestone?.toEntity(),
      nextMilestone: nextMilestone?.toEntity(),
      lifeImpactBadges: lifeImpactBadges.map((e) => e.toEntity()).toList(),
      coinsBadges: coinsBadges.map((e) => e.toEntity()).toList(),
      memberIntroBadges: memberIntroBadges.map((e) => e.toEntity()).toList(),
      totalBadgesCount: totalBadgesCount,
    );
  }
}
