import '../../domain/entities/vyapaar_jagat_story_entity.dart';

class VyapaarJagatStoryModel extends VyapaarJagatStoryEntity {
  const VyapaarJagatStoryModel({
    required super.fullName,
    required super.designation,
    required super.companyName,
    required super.website,
    required super.entrepreneurialJourney,
    required super.businessDescription,
    required super.biggestChallenge,
    required super.biggestAchievement,
    required super.businessImpact,
    required super.futureGoals,
    required super.adviceForEntrepreneurs,
    required super.linkedinUrl,
    required super.facebookUrl,
    required super.instagramUrl,
    required super.twitterUrl,
    super.consent = true,
  });

  factory VyapaarJagatStoryModel.fromEntity(VyapaarJagatStoryEntity entity) {
    return VyapaarJagatStoryModel(
      fullName: entity.fullName,
      designation: entity.designation,
      companyName: entity.companyName,
      website: entity.website,
      entrepreneurialJourney: entity.entrepreneurialJourney,
      businessDescription: entity.businessDescription,
      biggestChallenge: entity.biggestChallenge,
      biggestAchievement: entity.biggestAchievement,
      businessImpact: entity.businessImpact,
      futureGoals: entity.futureGoals,
      adviceForEntrepreneurs: entity.adviceForEntrepreneurs,
      linkedinUrl: entity.linkedinUrl,
      facebookUrl: entity.facebookUrl,
      instagramUrl: entity.instagramUrl,
      twitterUrl: entity.twitterUrl,
      consent: entity.consent,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'full_name': fullName,
      'designation': designation,
      'company_name': companyName,
      'website': website,
      'entrepreneurial_journey': entrepreneurialJourney,
      'business_description': businessDescription,
      'biggest_challenge': biggestChallenge,
      'biggest_achievement': biggestAchievement,
      'business_impact': businessImpact,
      'future_goals': futureGoals,
      'advice_for_entrepreneurs': adviceForEntrepreneurs,
      'linkedin_url': linkedinUrl,
      'facebook_url': facebookUrl,
      'instagram_url': instagramUrl,
      'twitter_url': twitterUrl,
      'consent': consent,
    };
  }
}
