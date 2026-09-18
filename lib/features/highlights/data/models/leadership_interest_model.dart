import '../../domain/entities/leadership_interest_entity.dart';

class LeadershipInterestModel extends LeadershipInterestEntity {
  const LeadershipInterestModel({
    super.applyingFor,
    super.referredName,
    super.referredMobile,
    super.leadershipRole,
    super.contributeCity,
    super.primaryDomain,
    super.whyInterested,
    super.excitement,
    super.ownership,
    super.timeCommitment,
    super.hasLedBefore,
    super.message,
  });

  factory LeadershipInterestModel.fromEntity(LeadershipInterestEntity entity) {
    return LeadershipInterestModel(
      applyingFor: entity.applyingFor,
      referredName: entity.referredName,
      referredMobile: entity.referredMobile,
      leadershipRole: entity.leadershipRole,
      contributeCity: entity.contributeCity,
      primaryDomain: entity.primaryDomain,
      whyInterested: entity.whyInterested,
      excitement: entity.excitement,
      ownership: entity.ownership,
      timeCommitment: entity.timeCommitment,
      hasLedBefore: entity.hasLedBefore,
      message: entity.message,
    );
  }

  Map<String, dynamic> toJson() {
    if (applyingFor == 'referring_friend') {
      return {
        'applying_for': 'referring_friend',
        'referred_name': referredName,
        'referred_mobile': referredMobile,
      };
    }
    return {
      'applying_for': 'myself',
      if (leadershipRole != null) 'leadership_roles': [leadershipRole],
      if (contributeCity != null) 'contribute_city': contributeCity,
      if (primaryDomain != null) 'primary_domain': primaryDomain,
      if (whyInterested != null) 'why_interested': whyInterested,
      if (excitement != null) 'excitement': excitement,
      if (ownership != null) 'ownership': ownership,
      if (timeCommitment != null) 'time_commitment': timeCommitment,
      if (hasLedBefore != null) 'has_led_before': hasLedBefore,
      if (message != null && message!.isNotEmpty) 'message': message,
    };
  }
}
