import '../../domain/entities/referral_stats_entity.dart';

class ReferralStatsModel extends ReferralStatsEntity {
  const ReferralStatsModel({
    super.referralsGiven = 0,
    super.referralsReceived = 0,
    super.totalReferrals = 0,
  });

  factory ReferralStatsModel.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> countsMap = json;
    if (json['counts'] is Map<String, dynamic>) {
      countsMap = json['counts'] as Map<String, dynamic>;
    } else if (json['data'] is Map<String, dynamic> &&
        (json['data'] as Map<String, dynamic>)['counts'] is Map<String, dynamic>) {
      countsMap = (json['data'] as Map<String, dynamic>)['counts'] as Map<String, dynamic>;
    }

    final given = int.tryParse(countsMap['referrals_given']?.toString() ??
            countsMap['given']?.toString() ??
            '') ??
        0;
    final received = int.tryParse(countsMap['referrals_received']?.toString() ??
            countsMap['received']?.toString() ??
            '') ??
        0;
    final total = int.tryParse(countsMap['total_referrals']?.toString() ??
            countsMap['total']?.toString() ??
            '') ??
        (given + received);

    return ReferralStatsModel(
      referralsGiven: given,
      referralsReceived: received,
      totalReferrals: total,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'referrals_given': referralsGiven,
      'referrals_received': referralsReceived,
      'total_referrals': totalReferrals,
    };
  }
}
