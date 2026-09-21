import '../../domain/entities/profile_entity.dart';

class ProfileCompletenessResult {
  final int overallPercentage;
  final int personalPercentage;
  final int businessPercentage;
  final int professionalPercentage;
  final int interestsPercentage;
  final int socialPercentage;
  final int mediaPercentage;

  const ProfileCompletenessResult({
    required this.overallPercentage,
    required this.personalPercentage,
    required this.businessPercentage,
    required this.professionalPercentage,
    required this.interestsPercentage,
    required this.socialPercentage,
    required this.mediaPercentage,
  });

  int getSectionPercentage(String sectionKey) {
    switch (sectionKey) {
      case 'personal':
        return personalPercentage;
      case 'business':
        return businessPercentage;
      case 'professional':
        return professionalPercentage;
      case 'interests':
        return interestsPercentage;
      case 'social':
        return socialPercentage;
      case 'media':
        return mediaPercentage;
      default:
        return 0;
    }
  }
}

class ProfileCompletenessCalculator {
  ProfileCompletenessCalculator._();

  static ProfileCompletenessResult calculate(ProfileEntity? profile) {
    if (profile == null) {
      return const ProfileCompletenessResult(
        overallPercentage: 0,
        personalPercentage: 0,
        businessPercentage: 0,
        professionalPercentage: 0,
        interestsPercentage: 0,
        socialPercentage: 0,
        mediaPercentage: 0,
      );
    }

    // 1. Personal Information (key fields)
    final personalFields = [
      _hasValue(profile.profilePhotoUrl),
      _hasValue(profile.coverPhotoUrl),
      _hasValue(profile.firstName),
      _hasValue(profile.lastName),
      _hasValue(profile.displayName),
      _hasValue(profile.email),
      _hasValue(profile.phone),
      _hasValue(profile.dob),
      _hasValue(profile.gender),
      _hasValue(profile.city?.name) || _hasValue(profile.state),
      _hasValue(profile.bio),
      _hasValue(profile.superpower),
    ];
    final personalPercent = _calcPercent(personalFields);

    // 2. Business Information (key fields)
    final businessFields = [
      _hasValue(profile.companyName),
      _hasValue(profile.designation),
      _hasValue(profile.businessType),
      _hasValue(profile.companyType),
      profile.yearOfEstablishment != null,
      _hasValue(profile.annualRevenueRange) || _hasValue(profile.turnoverRange),
      _hasValue(profile.numberOfEmployees),
      _hasValue(profile.gstNumber),
      _hasValue(profile.businessWebsite),
      _hasValue(profile.businessAddress),
      _hasValue(profile.businessCategory) ||
          _hasValue(profile.businessSubCategory) ||
          _hasValue(profile.otherCategoryName),
      _hasValue(profile.productsServicesOffered),
    ];
    final businessPercent = _calcPercent(businessFields);

    // 3. Professional Journey (key fields)
    final professionalFields = [
      profile.experienceYears != null && profile.experienceYears! > 0,
      _hasValue(profile.experienceSummary),
      profile.skills.isNotEmpty,
      profile.industriesOfInterest.isNotEmpty,
      profile.specialRecognitions.isNotEmpty,
      profile.leadershipRoles.isNotEmpty,
    ];
    final professionalPercent = _calcPercent(professionalFields);

    // 4. Interests & Goals (key fields)
    final interestsFields = [
      profile.interests.isNotEmpty,
      profile.iCanHelpWith.isNotEmpty,
      profile.iAmLookingFor.isNotEmpty,
      profile.collaborationGoals.isNotEmpty,
      _hasValue(profile.preferredMeetingFormat),
      profile.willingToMentor || profile.openToCrossCityCollaboration || profile.openToSpeakingAtEvents,
    ];
    final interestsPercent = _calcPercent(interestsFields);

    // 5. Social & Links (key fields)
    final socialFields = [
      _hasValue(profile.socialLinks?.website),
      _hasValue(profile.socialLinks?.linkedin),
      _hasValue(profile.socialLinks?.instagram),
      _hasValue(profile.socialLinks?.facebook),
      _hasValue(profile.socialLinks?.twitter),
      _hasValue(profile.socialLinks?.youtube),
    ];
    final socialPercent = _calcPercent(socialFields);

    // 6. Media & Portfolio (key fields)
    final mediaFields = [
      _hasValue(profile.profileVideoUrl),
      profile.media.isNotEmpty,
      _hasValue(profile.welcomeCreativeUrl),
    ];
    final mediaPercent = _calcPercent(mediaFields);

    // Overall completion percentage is the balanced average across all 6 sections
    final overall = ((personalPercent +
                businessPercent +
                professionalPercent +
                interestsPercent +
                socialPercent +
                mediaPercent) /
            6)
        .round()
        .clamp(0, 100);

    return ProfileCompletenessResult(
      overallPercentage: overall,
      personalPercentage: personalPercent,
      businessPercentage: businessPercent,
      professionalPercentage: professionalPercent,
      interestsPercentage: interestsPercent,
      socialPercentage: socialPercent,
      mediaPercentage: mediaPercent,
    );
  }

  static bool _hasValue(String? str) {
    if (str == null) return false;
    final trimmed = str.trim();
    return trimmed.isNotEmpty && trimmed != 'null' && trimmed != 'N/A';
  }

  static int _calcPercent(List<bool> checks) {
    if (checks.isEmpty) return 0;
    final filled = checks.where((c) => c).length;
    return ((filled / checks.length) * 100).round().clamp(0, 100);
  }
}
