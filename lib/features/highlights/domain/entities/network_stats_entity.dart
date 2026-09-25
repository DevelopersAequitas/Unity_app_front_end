import 'package:equatable/equatable.dart';

class NetworkStatsEntity extends Equatable {
  final int totalInvited;
  final int activeMembers;
  final int rewardsEarned;
  final int referralsGiven;
  final int referralsReceived;
  final String referralCode;
  final String referralLink;

  const NetworkStatsEntity({
    this.totalInvited = 0,
    this.activeMembers = 0,
    this.rewardsEarned = 0,
    this.referralsGiven = 0,
    this.referralsReceived = 0,
    this.referralCode = '',
    this.referralLink = '',
  });

  NetworkStatsEntity copyWith({
    int? totalInvited,
    int? activeMembers,
    int? rewardsEarned,
    int? referralsGiven,
    int? referralsReceived,
    String? referralCode,
    String? referralLink,
  }) {
    return NetworkStatsEntity(
      totalInvited: totalInvited ?? this.totalInvited,
      activeMembers: activeMembers ?? this.activeMembers,
      rewardsEarned: rewardsEarned ?? this.rewardsEarned,
      referralsGiven: referralsGiven ?? this.referralsGiven,
      referralsReceived: referralsReceived ?? this.referralsReceived,
      referralCode: referralCode ?? this.referralCode,
      referralLink: referralLink ?? this.referralLink,
    );
  }

  @override
  List<Object?> get props => [
        totalInvited,
        activeMembers,
        rewardsEarned,
        referralsGiven,
        referralsReceived,
        referralCode,
        referralLink,
      ];
}
