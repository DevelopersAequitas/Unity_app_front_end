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
    final root = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;
    final counts = root['counts'] is Map<String, dynamic>
        ? root['counts'] as Map<String, dynamic>
        : root;

    int parseNum(dynamic val) {
      if (val is num) return val.toInt();
      if (val != null) return int.tryParse(val.toString()) ?? 0;
      return 0;
    }

    final total = parseNum(
      counts['total_invited'] ??
          counts['total_referrals'] ??
          counts['total_members'] ??
          counts['total_joined'] ??
          counts['total_invites'] ??
          root['total_members'] ??
          root['total_invited'] ??
          root['total'],
    );
    final given =
        parseNum(counts['referrals_given'] ?? counts['given_referrals']);
    final received =
        parseNum(counts['referrals_received'] ?? counts['received_referrals']);
    final active = parseNum(
        counts['active_referrals'] ?? counts['active_members'] ?? total);
    final rewards = parseNum(
      counts['total_referral_coins'] ??
          counts['rewards_earned'] ??
          counts['total_coins'] ??
          counts['coins_earned'] ??
          root['total_referral_coins'] ??
          root['rewards_earned'] ??
          root['total_coins'],
    );

    final refCode = root['referral_code']?.toString() ??
        counts['referral_code']?.toString() ??
        json['referral_code']?.toString() ??
        '';
    final refLink = root['referral_link']?.toString() ??
        counts['referral_link']?.toString() ??
        json['referral_link']?.toString() ??
        '';

    return NetworkStatsModel(
      totalInvited: total,
      activeMembers: active,
      rewardsEarned: rewards,
      referralsGiven: given,
      referralsReceived: received,
      referralCode: refCode,
      referralLink: refLink,
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
