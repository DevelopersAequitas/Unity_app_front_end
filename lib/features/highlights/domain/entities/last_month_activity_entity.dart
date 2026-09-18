import 'package:equatable/equatable.dart';

class LastMonthActivityEntity extends Equatable {
  final String userName;
  final String businessName;
  final String profilePhotoUrl;
  final String startDate;
  final String endDate;
  final int totalDays;
  final int p2pMeetings;
  final int dealsGiven;
  final int dealsReceived;
  final int referralsGiven;
  final int referralsReceived;
  final int testimonials;
  final int visitors;
  final int recommendedPeers;
  final int listedRequirements;
  final String p2pDisplayText;
  final String dealsReceivedDisplayText;
  final String dealsGivenDisplayText;
  final String referralsGivenDisplayText;
  final String testimonialsDisplayText;
  final String periodName;
  final String gratitudeStatement;

  const LastMonthActivityEntity({
    this.userName = '',
    this.businessName = '',
    this.profilePhotoUrl = '',
    this.startDate = '',
    this.endDate = '',
    this.totalDays = 30,
    this.p2pMeetings = 0,
    this.dealsGiven = 0,
    this.dealsReceived = 0,
    this.referralsGiven = 0,
    this.referralsReceived = 0,
    this.testimonials = 0,
    this.visitors = 0,
    this.recommendedPeers = 0,
    this.listedRequirements = 0,
    this.p2pDisplayText = '',
    this.dealsReceivedDisplayText = '',
    this.dealsGivenDisplayText = '',
    this.referralsGivenDisplayText = '',
    this.testimonialsDisplayText = '',
    this.periodName = 'Last Month',
    this.gratitudeStatement = '',
  });

  @override
  List<Object?> get props => [
        userName,
        businessName,
        profilePhotoUrl,
        startDate,
        endDate,
        totalDays,
        p2pMeetings,
        dealsGiven,
        dealsReceived,
        referralsGiven,
        referralsReceived,
        testimonials,
        visitors,
        recommendedPeers,
        listedRequirements,
        p2pDisplayText,
        dealsReceivedDisplayText,
        dealsGivenDisplayText,
        referralsGivenDisplayText,
        testimonialsDisplayText,
        periodName,
        gratitudeStatement,
      ];
}

