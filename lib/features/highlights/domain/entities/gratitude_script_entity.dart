import 'package:equatable/equatable.dart';

class GratitudeScriptEntity extends Equatable {
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

  const GratitudeScriptEntity({
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
    this.closingText = 'Thank you Peers for the support, referrals, collaboration, and opportunities.',
    this.checklist = const [],
  });

  String buildFullScript() {
    final buffer = StringBuffer();
    if (greetingText.isNotEmpty) buffer.writeln(greetingText);
    if (introductionText.isNotEmpty) buffer.writeln(introductionText);
    if (monthlyLivesImpactedText.isNotEmpty) buffer.writeln(monthlyLivesImpactedText);
    if (monthlyBusinessDoneText.isNotEmpty) buffer.writeln(monthlyBusinessDoneText);
    for (final item in checklist) {
      if (item.isNotEmpty) buffer.writeln('• $item');
    }
    if (businessDealsText.isNotEmpty) buffer.writeln(businessDealsText);
    if (lifetimeImpactText.isNotEmpty) buffer.writeln(lifetimeImpactText);
    if (progressWord.isNotEmpty) buffer.writeln('Meaningful Progress: $progressWord');
    if (nextMonthGoal.isNotEmpty) buffer.writeln('Next Month Goal: $nextMonthGoal');
    if (experienceStory.isNotEmpty) buffer.writeln('Experience / Story: $experienceStory');
    if (closingText.isNotEmpty) buffer.writeln('\n$closingText');
    return buffer.toString().trim();
  }

  GratitudeScriptEntity copyWith({
    String? authorName,
    String? businessName,
    String? category,
    String? profilePhotoUrl,
    String? startDate,
    String? endDate,
    int? totalDays,
    int? livesImpacted,
    double? businessDone,
    int? lifetimeLivesImpacted,
    double? lifetimeBusinessDone,
    String? greetingText,
    String? introductionText,
    String? monthlyLivesImpactedText,
    String? monthlyBusinessDoneText,
    String? lifetimeImpactText,
    String? businessDealsText,
    String? progressWord,
    String? nextMonthGoal,
    String? experienceStory,
    String? closingText,
    List<String>? checklist,
  }) {
    return GratitudeScriptEntity(
      authorName: authorName ?? this.authorName,
      businessName: businessName ?? this.businessName,
      category: category ?? this.category,
      profilePhotoUrl: profilePhotoUrl ?? this.profilePhotoUrl,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      totalDays: totalDays ?? this.totalDays,
      livesImpacted: livesImpacted ?? this.livesImpacted,
      businessDone: businessDone ?? this.businessDone,
      lifetimeLivesImpacted: lifetimeLivesImpacted ?? this.lifetimeLivesImpacted,
      lifetimeBusinessDone: lifetimeBusinessDone ?? this.lifetimeBusinessDone,
      greetingText: greetingText ?? this.greetingText,
      introductionText: introductionText ?? this.introductionText,
      monthlyLivesImpactedText: monthlyLivesImpactedText ?? this.monthlyLivesImpactedText,
      monthlyBusinessDoneText: monthlyBusinessDoneText ?? this.monthlyBusinessDoneText,
      lifetimeImpactText: lifetimeImpactText ?? this.lifetimeImpactText,
      businessDealsText: businessDealsText ?? this.businessDealsText,
      progressWord: progressWord ?? this.progressWord,
      nextMonthGoal: nextMonthGoal ?? this.nextMonthGoal,
      experienceStory: experienceStory ?? this.experienceStory,
      closingText: closingText ?? this.closingText,
      checklist: checklist ?? this.checklist,
    );
  }

  @override
  List<Object?> get props => [
        authorName,
        businessName,
        category,
        profilePhotoUrl,
        startDate,
        endDate,
        totalDays,
        livesImpacted,
        businessDone,
        lifetimeLivesImpacted,
        lifetimeBusinessDone,
        greetingText,
        introductionText,
        monthlyLivesImpactedText,
        monthlyBusinessDoneText,
        lifetimeImpactText,
        businessDealsText,
        progressWord,
        nextMonthGoal,
        experienceStory,
        closingText,
        checklist,
      ];
}

