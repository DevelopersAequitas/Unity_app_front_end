class VyapaarJagatStoryEntity {
  final String fullName;
  final String designation;
  final String companyName;
  final String website;
  final String entrepreneurialJourney;
  final String businessDescription;
  final String biggestChallenge;
  final String biggestAchievement;
  final String businessImpact;
  final String futureGoals;
  final String adviceForEntrepreneurs;
  final String linkedinUrl;
  final String facebookUrl;
  final String instagramUrl;
  final String twitterUrl;
  final bool consent;

  const VyapaarJagatStoryEntity({
    required this.fullName,
    required this.designation,
    required this.companyName,
    required this.website,
    required this.entrepreneurialJourney,
    required this.businessDescription,
    required this.biggestChallenge,
    required this.biggestAchievement,
    required this.businessImpact,
    required this.futureGoals,
    required this.adviceForEntrepreneurs,
    required this.linkedinUrl,
    required this.facebookUrl,
    required this.instagramUrl,
    required this.twitterUrl,
    this.consent = true,
  });
}
