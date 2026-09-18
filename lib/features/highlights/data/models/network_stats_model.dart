import '../../domain/entities/network_stats_entity.dart';

class NetworkStatsModel {
  final int totalInvited;
  final int activeMembers;
  final int rewardsEarned;
  final int referralsGiven;
  final int referralsReceived;
  final String referralCode;
  final String referralLink;

  const NetworkStatsModel({
    this.totalInvited = 0,
    this.activeMembers = 0,
    this.rewardsEarned = 0,
    this.referralsGiven = 0,
    this.referralsReceived = 0,
    this.referralCode = '',
    this.referralLink = '',
  });

  factory NetworkStatsModel.fromJson(Map<String, dynamic> json) {
    final counts = json['counts'] is Map<String, dynamic> ? json['counts'] as Map<String, dynamic> : json;
    final total = (counts['total_referrals'] ?? counts['total_invited'] ?? counts['total_invites'] ?? 0) as int;
    final given = (counts['referrals_given'] ?? counts['given_referrals'] ?? 0) as int;
    final received = (counts['referrals_received'] ?? counts['received_referrals'] ?? 0) as int;
    final active = (counts['active_referrals'] ?? counts['active_members'] ?? given) as int;
    final rewards = (counts['total_referral_coins'] ?? counts['rewards_earned'] ?? counts['total_coins'] ?? 0) as int;

    return NetworkStatsModel(
      totalInvited: total > 0 ? total : (given + received),
      activeMembers: active,
      rewardsEarned: rewards,
      referralsGiven: given,
      referralsReceived: received,
      referralCode: json['referral_code']?.toString() ?? counts['referral_code']?.toString() ?? '',
      referralLink: json['referral_link']?.toString() ?? counts['referral_link']?.toString() ?? '',
    );
  }

  NetworkStatsEntity toEntity() {
    return NetworkStatsEntity(
      totalInvited: totalInvited,
      activeMembers: activeMembers,
      rewardsEarned: rewardsEarned,
      referralsGiven: referralsGiven,
      referralsReceived: referralsReceived,
      referralCode: referralCode,
      referralLink: referralLink,
    );
  }
}
