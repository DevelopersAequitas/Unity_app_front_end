import 'package:equatable/equatable.dart';

class LeadershipInterestEntity extends Equatable {
  final String applyingFor;
  final String? referredName;
  final String? referredMobile;
  final String? leadershipRole;
  final String? contributeCity;
  final String? primaryDomain;
  final String? whyInterested;
  final String? excitement;
  final String? ownership;
  final String? timeCommitment;
  final bool? hasLedBefore;
  final String? message;

  const LeadershipInterestEntity({
    this.applyingFor = 'myself',
    this.referredName,
    this.referredMobile,
    this.leadershipRole,
    this.contributeCity,
    this.primaryDomain,
    this.whyInterested,
    this.excitement,
    this.ownership,
    this.timeCommitment,
    this.hasLedBefore,
    this.message,
  });

  @override
  List<Object?> get props => [
        applyingFor,
        referredName,
        referredMobile,
        leadershipRole,
        contributeCity,
        primaryDomain,
        whyInterested,
        excitement,
        ownership,
        timeCommitment,
        hasLedBefore,
        message,
      ];
}
