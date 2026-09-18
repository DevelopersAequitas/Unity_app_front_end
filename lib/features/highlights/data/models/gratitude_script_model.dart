import '../../domain/entities/gratitude_script_entity.dart';

class GratitudeScriptModel {
  final String authorName;
  final String businessName;
  final String category;
  final String profilePhotoUrl;
  final String startDate;
  final String endDate;
  final int totalDays;
  final int livesImpacted;
  final double businessDone;
  final int lifetimeLivesImpacted;
  final double lifetimeBusinessDone;
  final String greetingText;
  final String introductionText;
  final String monthlyLivesImpactedText;
  final String monthlyBusinessDoneText;
  final String lifetimeImpactText;
  final String businessDealsText;
  final String progressWord;
  final String nextMonthGoal;
  final String experienceStory;
  final String closingText;
  final List<String> checklist;

  const GratitudeScriptModel({
    this.authorName = '',
    this.businessName = '',
    this.category = '',
    this.profilePhotoUrl = '',
    this.startDate = '',
    this.endDate = '',
    this.totalDays = 30,
    this.livesImpacted = 0,
    this.businessDone = 0,
    this.lifetimeLivesImpacted = 0,
    this.lifetimeBusinessDone = 0,
    this.greetingText = 'Hello Peers,',
    this.introductionText = '',
    this.monthlyLivesImpactedText = '',
    this.monthlyBusinessDoneText = '',
    this.lifetimeImpactText = '',
    this.businessDealsText = '',
    this.progressWord = '',
    this.nextMonthGoal = '',
    this.experienceStory = '',
    this.closingText = '',
    this.checklist = const [],
  });

  factory GratitudeScriptModel.fromJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>? ?? {};
    final period = json['period'] as Map<String, dynamic>? ?? {};
    final summary = json['summary'] as Map<String, dynamic>? ?? {};
    final script = json['script'] as Map<String, dynamic>? ?? {};
    final form = json['form_fields'] as Map<String, dynamic>? ?? {};

    final List<String> items = [];
    final rawChecklist = script['checklist_items'] ?? json['checklist_items'];
    if (rawChecklist is List) {
      for (final it in rawChecklist) {
        if (it is Map<String, dynamic>) {
          final isAvail = it['is_available'] == true || (it['count'] is num && (it['count'] as num) > 0);
          if (isAvail) {
            final related = it['related_items'];
            if (related is List && related.isNotEmpty) {
              for (final r in related) {
                if (r is Map<String, dynamic> && r['display_text'] != null) {
                  items.add(r['display_text'].toString());
                }
              }
            } else if (it['display_text'] != null) {
              items.add(it['display_text'].toString());
            }
          }
        }
      }
    }

    double parseNum(dynamic val) {
      if (val is num) return val.toDouble();
      return double.tryParse(val?.toString() ?? '') ?? 0.0;
    }

    return GratitudeScriptModel(
      authorName: user['display_name']?.toString() ?? user['name']?.toString() ?? 'Peer',
      businessName: user['business_name']?.toString() ?? user['company_name']?.toString() ?? '',
      category: user['category']?.toString() ?? user['business_type']?.toString() ?? '',
      profilePhotoUrl: user['profile_photo_url']?.toString() ?? '',
      startDate: period['start_date']?.toString() ?? '',
      endDate: period['end_date']?.toString() ?? '',
      totalDays: (period['total_days'] ?? 30) as int,
      livesImpacted: (summary['total_lives_impacted_last_30_days'] ?? period['total_lives_impacted_last_30_days'] ?? 0) as int,
      businessDone: parseNum(summary['total_business_done_with_peers_last_30_days'] ?? period['total_business_done_with_peers_last_30_days']),
      lifetimeLivesImpacted: (summary['lifetime_total_lives_impacted'] ?? 0) as int,
      lifetimeBusinessDone: parseNum(summary['lifetime_total_business_done_with_peers']),
      greetingText: script['greeting_text']?.toString() ?? 'Hello Peers,',
      introductionText: script['introduction_text']?.toString() ?? '',
      monthlyLivesImpactedText: script['monthly_lives_impacted_text']?.toString() ?? '',
      monthlyBusinessDoneText: script['monthly_business_done_text']?.toString() ?? '',
      lifetimeImpactText: script['lifetime_impact_text']?.toString() ?? '',
      businessDealsText: script['business_deals_text']?.toString() ?? '',
      progressWord: form['meaningful_progress_this_month']?.toString() ?? form['meaningful_progress']?.toString() ?? '',
      nextMonthGoal: form['goal_for_next_month']?.toString() ?? '',
      experienceStory: form['experience_or_story_optional']?.toString() ?? form['story']?.toString() ?? '',
      closingText: script['closing_text']?.toString() ?? 'Thank you Peers for the support, referrals, collaboration, and opportunities.',
      checklist: items,
    );
  }

  GratitudeScriptEntity toEntity() {
    return GratitudeScriptEntity(
      authorName: authorName,
      businessName: businessName,
      category: category,
      profilePhotoUrl: profilePhotoUrl,
      startDate: startDate,
      endDate: endDate,
      totalDays: totalDays,
      livesImpacted: livesImpacted,
      businessDone: businessDone,
      lifetimeLivesImpacted: lifetimeLivesImpacted,
      lifetimeBusinessDone: lifetimeBusinessDone,
      greetingText: greetingText,
      introductionText: introductionText,
      monthlyLivesImpactedText: monthlyLivesImpactedText,
      monthlyBusinessDoneText: monthlyBusinessDoneText,
      lifetimeImpactText: lifetimeImpactText,
      businessDealsText: businessDealsText,
      progressWord: progressWord,
      nextMonthGoal: nextMonthGoal,
      experienceStory: experienceStory,
      closingText: closingText,
      checklist: checklist,
    );
  }
}

