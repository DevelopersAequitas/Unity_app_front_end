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
