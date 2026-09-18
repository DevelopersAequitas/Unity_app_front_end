import 'package:equatable/equatable.dart';

class ReferralStatsEntity extends Equatable {
  final int referralsGiven;
  final int referralsReceived;
  final int totalReferrals;

  const ReferralStatsEntity({
    this.referralsGiven = 0,
    this.referralsReceived = 0,
    this.totalReferrals = 0,
  });

  @override
  List<Object?> get props => [
        referralsGiven,
        referralsReceived,
        totalReferrals,
      ];
}
