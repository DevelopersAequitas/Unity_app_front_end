import '../../domain/entities/last_month_activity_entity.dart';

class LastMonthActivityModel {
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

  const LastMonthActivityModel({
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

  factory LastMonthActivityModel.fromJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>? ?? {};
    final period = json['period'] as Map<String, dynamic>? ?? {};
    final activities = json['activities'] as Map<String, dynamic>? ?? {};

    int getCount(String key) {
      final act = activities[key];
      if (act is Map<String, dynamic>) {
        return (act['count'] ?? 0) as int;
      }
      return (json[key] ?? 0) as int;
    }

    String getDisplayText(String key) {
      final act = activities[key];
      if (act is Map<String, dynamic>) {
        return act['display_text']?.toString() ?? '';
      }
      return '';
    }

    final p2p = getCount('p2p_meetings');
    final dealsRec = getCount('business_deals_received');
    final dealsGiv = getCount('business_deals_given');
    final refGiv = getCount('referrals_given');
    final refRec = getCount('referrals_received');
    final test = getCount('testimonials_given');
    final vis = getCount('registered_visitors');
    final recPeers = getCount('recommended_peers');
    final reqs = getCount('listed_requirements');

    final sDate = period['start_date']?.toString() ?? '';
    final eDate = period['end_date']?.toString() ?? '';
    final days = (period['total_days'] ?? 30) as int;
    final pName = (sDate.isNotEmpty && eDate.isNotEmpty)
        ? '$sDate to $eDate'
        : 'Last $days Days';

    final statement = json['gratitude_statement']?.toString() ??
        'In the last $days days, I completed $p2p P2P meeting(s), gave $dealsGiv business deal(s), received $dealsRec deal(s), and exchanged $refGiv referral(s).';

    return LastMonthActivityModel(
      userName: user['display_name']?.toString() ?? user['name']?.toString() ?? 'Peer',
      businessName: user['business_name']?.toString() ?? user['company_name']?.toString() ?? '',
      profilePhotoUrl: user['profile_photo_url']?.toString() ?? '',
      startDate: sDate,
      endDate: eDate,
      totalDays: days,
      p2pMeetings: p2p,
      dealsGiven: dealsGiv,
      dealsReceived: dealsRec,
      referralsGiven: refGiv,
      referralsReceived: refRec,
      testimonials: test,
      visitors: vis,
      recommendedPeers: recPeers,
      listedRequirements: reqs,
      p2pDisplayText: getDisplayText('p2p_meetings'),
      dealsReceivedDisplayText: getDisplayText('business_deals_received'),
      dealsGivenDisplayText: getDisplayText('business_deals_given'),
      referralsGivenDisplayText: getDisplayText('referrals_given'),
      testimonialsDisplayText: getDisplayText('testimonials_given'),
      periodName: pName,
      gratitudeStatement: statement,
    );
  }

  LastMonthActivityEntity toEntity() {
    return LastMonthActivityEntity(
      userName: userName,
      businessName: businessName,
      profilePhotoUrl: profilePhotoUrl,
      startDate: startDate,
      endDate: endDate,
      totalDays: totalDays,
      p2pMeetings: p2pMeetings,
      dealsGiven: dealsGiven,
      dealsReceived: dealsReceived,
      referralsGiven: referralsGiven,
      referralsReceived: referralsReceived,
      testimonials: testimonials,
      visitors: visitors,
      recommendedPeers: recommendedPeers,
      listedRequirements: listedRequirements,
      p2pDisplayText: p2pDisplayText,
      dealsReceivedDisplayText: dealsReceivedDisplayText,
      dealsGivenDisplayText: dealsGivenDisplayText,
      referralsGivenDisplayText: referralsGivenDisplayText,
      testimonialsDisplayText: testimonialsDisplayText,
      periodName: periodName,
      gratitudeStatement: gratitudeStatement,
    );
  }
}

