import 'package:equatable/equatable.dart';

class ProfileEntity extends Equatable {
  final String id;
  final String? peerId;
  final String? publicProfileSlug;
  final String? profilePhotoId;
  final String? profilePhotoUrl;
  final String? coverPhotoId;
  final String? coverPhotoUrl;
  final String? profileVideoId;
  final String? profileVideoUrl;
  final String? welcomeCreativeUrl;
  final String? firstName;
  final String? lastName;
  final String displayName;
  final String? companyName;
  final String? designation;
  final String? email;
  final String? phone;
  final String? secondaryMobile;
  final String? gender;
  final String? dob;
  final String? anniversaryDate;
  final String? preferredLanguage;
  final ProfileCityEntity? city;
  final String? state;
  final String? country;
  final String? pincode;
  final String? address;
  final String? timezone;
  final String? membershipStatus;
  final String? membershipStatusLabel;
  final String? membershipStartsAt;
  final String? membershipEndsAt;
  final String? activeCircleId;
  final String? circleJoinedAt;
  final String? circleExpiresAt;
  final ActiveCircleEntity? activeCircle;
  final List<CircleMembershipEntity> circleMemberships;
  final List<ProfileCategoryEntity> categories;
  final int connectionCount;
  final int followersCount;
  final int followingCount;
  final int postsCount;
  final int coinsBalance;
  final int lifeImpactedCount;
  final String? businessType;
  final int? experienceYears;
  final String? experienceSummary;
  final String? bio;
  final String? longBioHtml;
  final List<String> skills;
  final List<String> interests;
  final List<String> industryTags;
  final List<String> targetRegions;
  final List<String> targetBusinessCategories;
  final List<String> hobbiesInterests;
  final List<String> leadershipRoles;
  final List<String> specialRecognitions;
  final SocialLinksEntity? socialLinks;
  final List<MediaItemEntity> media;
  final bool isVerified;
  final bool isSponsoredMember;
  final String? companyType;
  final int? yearOfEstablishment;
  final String? annualRevenueRange;
  final String? turnoverRange;
  final String? numberOfEmployees;
  final String? gstNumber;
  final String? businessWebsite;
  final String? superpower;
  final List<String> iCanHelpWith;
  final List<String> iAmLookingFor;
  final List<String> businessKeywords;
  final String? productsServicesOffered;
  final String? businessAddress;
  final String? businessCity;
  final String? businessState;
  final String? businessPincode;
  final String? businessCountry;
  final List<String> industriesOfInterest;
  final List<String> collaborationGoals;
  final String? preferredMeetingFormat;
  final bool willingToMentor;
  final bool openToCrossCityCollaboration;
  final bool openToSpeakingAtEvents;
  final String? communityDirectoryListing;
  final String? contactVisibility;
  final List<String> sustainabilityAreas;
  final List<String> greenpreneurGoals;
  final String? otherCategoryName;
  final String? businessSubCategory;
  final String? businessCategory;
  final IntroducedByUserEntity? introducedByUser;

  const ProfileEntity({
    required this.id,
    this.peerId,
    this.publicProfileSlug,
    this.profilePhotoId,
    this.profilePhotoUrl,
    this.coverPhotoId,
    this.coverPhotoUrl,
    this.profileVideoId,
    this.profileVideoUrl,
    this.welcomeCreativeUrl,
    this.firstName,
    this.lastName,
    required this.displayName,
    this.companyName,
    this.designation,
    this.email,
    this.phone,
    this.secondaryMobile,
    this.gender,
    this.dob,
    this.anniversaryDate,
    this.preferredLanguage,
    this.city,
    this.state,
    this.country,
    this.pincode,
    this.address,
    this.timezone,
    this.membershipStatus,
    this.membershipStatusLabel,
    this.membershipStartsAt,
    this.membershipEndsAt,
    this.activeCircleId,
    this.circleJoinedAt,
    this.circleExpiresAt,
    this.activeCircle,
    this.circleMemberships = const [],
    this.categories = const [],
    this.connectionCount = 0,
    this.followersCount = 0,
    this.followingCount = 0,
    this.postsCount = 0,
    this.coinsBalance = 0,
    this.lifeImpactedCount = 0,
    this.businessType,
    this.experienceYears,
    this.experienceSummary,
    this.bio,
    this.longBioHtml,
    this.skills = const [],
    this.interests = const [],
    this.industryTags = const [],
    this.targetRegions = const [],
    this.targetBusinessCategories = const [],
    this.hobbiesInterests = const [],
    this.leadershipRoles = const [],
    this.specialRecognitions = const [],
    this.socialLinks,
    this.media = const [],
    this.isVerified = false,
    this.isSponsoredMember = false,
    this.companyType,
    this.yearOfEstablishment,
    this.annualRevenueRange,
    this.turnoverRange,
    this.numberOfEmployees,
    this.gstNumber,
    this.businessWebsite,
    this.superpower,
    this.iCanHelpWith = const [],
    this.iAmLookingFor = const [],
    this.businessKeywords = const [],
    this.productsServicesOffered,
    this.businessAddress,
    this.businessCity,
    this.businessState,
    this.businessPincode,
    this.businessCountry,
    this.industriesOfInterest = const [],
    this.collaborationGoals = const [],
    this.preferredMeetingFormat,
    this.willingToMentor = false,
    this.openToCrossCityCollaboration = false,
    this.openToSpeakingAtEvents = false,
    this.communityDirectoryListing,
    this.contactVisibility,
    this.sustainabilityAreas = const [],
    this.greenpreneurGoals = const [],
    this.otherCategoryName,
    this.businessSubCategory,
    this.businessCategory,
    this.introducedByUser,
  });

  String get formattedLocation {
    final parts = [
      if (city?.name != null && city!.name.isNotEmpty) city!.name,
      if (state != null && state!.isNotEmpty) state!,
      if (country != null && country!.isNotEmpty) country!,
    ];
    return parts.isNotEmpty ? parts.join(', ') : (city?.formattedLocation ?? 'India');
  }

  @override
  List<Object?> get props => [
        id,
        peerId,
        displayName,
        profilePhotoUrl,
        coverPhotoUrl,
        companyName,
        designation,
        email,
        phone,
        city,
        state,
        country,
        membershipStatus,
        activeCircle,
        connectionCount,
        followersCount,
        followingCount,
        postsCount,
        coinsBalance,
        lifeImpactedCount,
        bio,
        skills,
        interests,
        socialLinks,
        isVerified,
      ];
}

class ProfileCityEntity extends Equatable {
  final String? id;
  final String name;
  final String? formattedLocation;

  const ProfileCityEntity({
    this.id,
    required this.name,
    this.formattedLocation,
  });

  @override
  List<Object?> get props => [id, name, formattedLocation];
}

class ActiveCircleEntity extends Equatable {
  final String id;
  final String name;
  final String? slug;
  final ProfileCityEntity? city;

  const ActiveCircleEntity({
    required this.id,
    required this.name,
    this.slug,
    this.city,
  });

  @override
  List<Object?> get props => [id, name, slug, city];
}

class CircleMembershipEntity extends Equatable {
  final String circleMemberId;
  final String circleId;
  final String circleName;
  final String? circleSlug;
  final String? memberStatus;
  final String? memberRole;
  final String? joinedAt;
  final String? expiresAt;
  final String? paymentStatus;

  const CircleMembershipEntity({
    required this.circleMemberId,
    required this.circleId,
    required this.circleName,
    this.circleSlug,
    this.memberStatus,
    this.memberRole,
    this.joinedAt,
    this.expiresAt,
    this.paymentStatus,
  });

  @override
  List<Object?> get props => [
        circleMemberId,
        circleId,
        circleName,
        memberStatus,
        memberRole,
        joinedAt,
        expiresAt,
      ];
}

class ProfileCategoryEntity extends Equatable {
  final String circleId;
  final String circleName;
  final String? level1;
  final String? level2;
  final String? level3;
  final String? level4;

  const ProfileCategoryEntity({
    required this.circleId,
    required this.circleName,
    this.level1,
    this.level2,
    this.level3,
    this.level4,
  });

  String get fullCategoryPath {
    final list = [
      if (level1 != null && level1!.isNotEmpty) level1!,
      if (level2 != null && level2!.isNotEmpty) level2!,
      if (level3 != null && level3!.isNotEmpty) level3!,
      if (level4 != null && level4!.isNotEmpty) level4!,
    ];
    return list.join(' → ');
  }

  @override
  List<Object?> get props => [circleId, circleName, level1, level2, level3, level4];
}

class SocialLinksEntity extends Equatable {
  final String? website;
  final String? linkedin;
  final String? instagram;
  final String? facebook;
  final String? twitter;
  final String? youtube;
  final String? otherWebsite;

  const SocialLinksEntity({
    this.website,
    this.linkedin,
    this.instagram,
    this.facebook,
    this.twitter,
    this.youtube,
    this.otherWebsite,
  });

  @override
  List<Object?> get props => [
        website,
        linkedin,
        instagram,
        facebook,
        twitter,
        youtube,
        otherWebsite,
      ];
}

class MediaItemEntity extends Equatable {
  final String id;
  final String url;
  final String type; // 'image', 'video', 'document'

  const MediaItemEntity({
    required this.id,
    required this.url,
    required this.type,
  });

  @override
  List<Object?> get props => [id, url, type];
}

class IntroducedByUserEntity extends Equatable {
  final String id;
  final String name;
  final String? profilePhotoUrl;

  const IntroducedByUserEntity({
    required this.id,
    required this.name,
    this.profilePhotoUrl,
  });

  @override
  List<Object?> get props => [id, name, profilePhotoUrl];
}
