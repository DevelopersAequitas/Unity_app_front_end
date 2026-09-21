import 'package:equatable/equatable.dart';

class ProfileEntity extends Equatable {
  final String id;
  final String? userId;
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
  final String? zohoPlanCode;
  final String? zohoSubscriptionId;
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
  final int badgesCount;
  final int p2pMeetingsCount;
  final int referralsCount;
  final int businessDealsCount;
  final int testimonialsCount;
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
  final double? googleMapsLatitude;
  final double? googleMapsLongitude;
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
  final String? mainBusinessCategory;
  final int? mainBusinessCategoryId;
  final int? businessCategoryId;
  final bool isOtherCategory;
  final IntroducedByUserEntity? introducedByUser;
  final bool isPro;
  final bool isFollowing;
  final bool isBookmark;
  final bool isConnected;
  final bool isRequested;
  final String connectionStatus;
  final bool isOnline;
  final bool isBlocked;

  const ProfileEntity({
    required this.id,
    this.userId,
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
    this.zohoPlanCode,
    this.zohoSubscriptionId,
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
    this.badgesCount = 0,
    this.p2pMeetingsCount = 0,
    this.referralsCount = 0,
    this.businessDealsCount = 0,
    this.testimonialsCount = 0,
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
    this.googleMapsLatitude,
    this.googleMapsLongitude,
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
    this.mainBusinessCategory,
    this.mainBusinessCategoryId,
    this.businessCategoryId,
    this.isOtherCategory = false,
    this.introducedByUser,
    this.isPro = false,
    this.isFollowing = false,
    this.isBookmark = false,
    this.isConnected = false,
    this.isRequested = false,
    this.connectionStatus = 'none',
    this.isOnline = false,
    this.isBlocked = false,
  });

  ProfileEntity copyWith({
    String? id,
    String? userId,
    String? peerId,
    String? publicProfileSlug,
    String? profilePhotoId,
    String? profilePhotoUrl,
    String? coverPhotoId,
    String? coverPhotoUrl,
    String? profileVideoId,
    String? profileVideoUrl,
    String? welcomeCreativeUrl,
    String? firstName,
    String? lastName,
    String? displayName,
    String? companyName,
    String? designation,
    String? email,
    String? phone,
    String? secondaryMobile,
    String? gender,
    String? dob,
    String? anniversaryDate,
    String? preferredLanguage,
    ProfileCityEntity? city,
    String? state,
    String? country,
    String? pincode,
    String? address,
    String? timezone,
    String? membershipStatus,
    String? membershipStatusLabel,
    String? membershipStartsAt,
    String? membershipEndsAt,
    String? zohoPlanCode,
    String? zohoSubscriptionId,
    String? activeCircleId,
    String? circleJoinedAt,
    String? circleExpiresAt,
    ActiveCircleEntity? activeCircle,
    List<CircleMembershipEntity>? circleMemberships,
    List<ProfileCategoryEntity>? categories,
    int? connectionCount,
    int? followersCount,
    int? followingCount,
    int? postsCount,
    int? coinsBalance,
    int? lifeImpactedCount,
    int? badgesCount,
    int? p2pMeetingsCount,
    int? referralsCount,
    int? businessDealsCount,
    int? testimonialsCount,
    String? businessType,
    int? experienceYears,
    String? experienceSummary,
    String? bio,
    String? longBioHtml,
    List<String>? skills,
    List<String>? interests,
    List<String>? industryTags,
    List<String>? targetRegions,
    List<String>? targetBusinessCategories,
    List<String>? hobbiesInterests,
    List<String>? leadershipRoles,
    List<String>? specialRecognitions,
    SocialLinksEntity? socialLinks,
    List<MediaItemEntity>? media,
    bool? isVerified,
    bool? isSponsoredMember,
    String? companyType,
    int? yearOfEstablishment,
    String? annualRevenueRange,
    String? turnoverRange,
    String? numberOfEmployees,
    String? gstNumber,
    String? businessWebsite,
    String? superpower,
    List<String>? iCanHelpWith,
    List<String>? iAmLookingFor,
    List<String>? businessKeywords,
    String? productsServicesOffered,
    String? businessAddress,
    double? googleMapsLatitude,
    double? googleMapsLongitude,
    String? businessCity,
    String? businessState,
    String? businessPincode,
    String? businessCountry,
    List<String>? industriesOfInterest,
    List<String>? collaborationGoals,
    String? preferredMeetingFormat,
    bool? willingToMentor,
    bool? openToCrossCityCollaboration,
    bool? openToSpeakingAtEvents,
    String? communityDirectoryListing,
    String? contactVisibility,
    List<String>? sustainabilityAreas,
    List<String>? greenpreneurGoals,
    String? otherCategoryName,
    String? businessSubCategory,
    String? businessCategory,
    String? mainBusinessCategory,
    int? mainBusinessCategoryId,
    int? businessCategoryId,
    bool? isOtherCategory,
    IntroducedByUserEntity? introducedByUser,
    bool? isPro,
    bool? isFollowing,
    bool? isBookmark,
    bool? isConnected,
    bool? isRequested,
    String? connectionStatus,
    bool? isOnline,
    bool? isBlocked,
  }) {
    return ProfileEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      peerId: peerId ?? this.peerId,
      publicProfileSlug: publicProfileSlug ?? this.publicProfileSlug,
      profilePhotoId: profilePhotoId ?? this.profilePhotoId,
      profilePhotoUrl: profilePhotoUrl ?? this.profilePhotoUrl,
      coverPhotoId: coverPhotoId ?? this.coverPhotoId,
      coverPhotoUrl: coverPhotoUrl ?? this.coverPhotoUrl,
      profileVideoId: profileVideoId ?? this.profileVideoId,
      profileVideoUrl: profileVideoUrl ?? this.profileVideoUrl,
      welcomeCreativeUrl: welcomeCreativeUrl ?? this.welcomeCreativeUrl,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      displayName: displayName ?? this.displayName,
      companyName: companyName ?? this.companyName,
      designation: designation ?? this.designation,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      secondaryMobile: secondaryMobile ?? this.secondaryMobile,
      gender: gender ?? this.gender,
      dob: dob ?? this.dob,
      anniversaryDate: anniversaryDate ?? this.anniversaryDate,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      city: city ?? this.city,
      state: state ?? this.state,
      country: country ?? this.country,
      pincode: pincode ?? this.pincode,
      address: address ?? this.address,
      timezone: timezone ?? this.timezone,
      membershipStatus: membershipStatus ?? this.membershipStatus,
      membershipStatusLabel: membershipStatusLabel ?? this.membershipStatusLabel,
      membershipStartsAt: membershipStartsAt ?? this.membershipStartsAt,
      membershipEndsAt: membershipEndsAt ?? this.membershipEndsAt,
      zohoPlanCode: zohoPlanCode ?? this.zohoPlanCode,
      zohoSubscriptionId: zohoSubscriptionId ?? this.zohoSubscriptionId,
      activeCircleId: activeCircleId ?? this.activeCircleId,
      circleJoinedAt: circleJoinedAt ?? this.circleJoinedAt,
      circleExpiresAt: circleExpiresAt ?? this.circleExpiresAt,
      activeCircle: activeCircle ?? this.activeCircle,
      circleMemberships: circleMemberships ?? this.circleMemberships,
      categories: categories ?? this.categories,
      connectionCount: connectionCount ?? this.connectionCount,
      followersCount: followersCount ?? this.followersCount,
      followingCount: followingCount ?? this.followingCount,
      postsCount: postsCount ?? this.postsCount,
      coinsBalance: coinsBalance ?? this.coinsBalance,
      lifeImpactedCount: lifeImpactedCount ?? this.lifeImpactedCount,
      badgesCount: badgesCount ?? this.badgesCount,
      p2pMeetingsCount: p2pMeetingsCount ?? this.p2pMeetingsCount,
      referralsCount: referralsCount ?? this.referralsCount,
      businessDealsCount: businessDealsCount ?? this.businessDealsCount,
      testimonialsCount: testimonialsCount ?? this.testimonialsCount,
      businessType: businessType ?? this.businessType,
      experienceYears: experienceYears ?? this.experienceYears,
      experienceSummary: experienceSummary ?? this.experienceSummary,
      bio: bio ?? this.bio,
      longBioHtml: longBioHtml ?? this.longBioHtml,
      skills: skills ?? this.skills,
      interests: interests ?? this.interests,
      industryTags: industryTags ?? this.industryTags,
      targetRegions: targetRegions ?? this.targetRegions,
      targetBusinessCategories: targetBusinessCategories ?? this.targetBusinessCategories,
      hobbiesInterests: hobbiesInterests ?? this.hobbiesInterests,
      leadershipRoles: leadershipRoles ?? this.leadershipRoles,
      specialRecognitions: specialRecognitions ?? this.specialRecognitions,
      socialLinks: socialLinks ?? this.socialLinks,
      media: media ?? this.media,
      isVerified: isVerified ?? this.isVerified,
      isSponsoredMember: isSponsoredMember ?? this.isSponsoredMember,
      companyType: companyType ?? this.companyType,
      yearOfEstablishment: yearOfEstablishment ?? this.yearOfEstablishment,
      annualRevenueRange: annualRevenueRange ?? this.annualRevenueRange,
      turnoverRange: turnoverRange ?? this.turnoverRange,
      numberOfEmployees: numberOfEmployees ?? this.numberOfEmployees,
      gstNumber: gstNumber ?? this.gstNumber,
      businessWebsite: businessWebsite ?? this.businessWebsite,
      superpower: superpower ?? this.superpower,
      iCanHelpWith: iCanHelpWith ?? this.iCanHelpWith,
      iAmLookingFor: iAmLookingFor ?? this.iAmLookingFor,
      businessKeywords: businessKeywords ?? this.businessKeywords,
      productsServicesOffered: productsServicesOffered ?? this.productsServicesOffered,
      businessAddress: businessAddress ?? this.businessAddress,
      googleMapsLatitude: googleMapsLatitude ?? this.googleMapsLatitude,
      googleMapsLongitude: googleMapsLongitude ?? this.googleMapsLongitude,
      businessCity: businessCity ?? this.businessCity,
      businessState: businessState ?? this.businessState,
      businessPincode: businessPincode ?? this.businessPincode,
      businessCountry: businessCountry ?? this.businessCountry,
      industriesOfInterest: industriesOfInterest ?? this.industriesOfInterest,
      collaborationGoals: collaborationGoals ?? this.collaborationGoals,
      preferredMeetingFormat: preferredMeetingFormat ?? this.preferredMeetingFormat,
      willingToMentor: willingToMentor ?? this.willingToMentor,
      openToCrossCityCollaboration: openToCrossCityCollaboration ?? this.openToCrossCityCollaboration,
      openToSpeakingAtEvents: openToSpeakingAtEvents ?? this.openToSpeakingAtEvents,
      communityDirectoryListing: communityDirectoryListing ?? this.communityDirectoryListing,
      contactVisibility: contactVisibility ?? this.contactVisibility,
      sustainabilityAreas: sustainabilityAreas ?? this.sustainabilityAreas,
      greenpreneurGoals: greenpreneurGoals ?? this.greenpreneurGoals,
      otherCategoryName: otherCategoryName ?? this.otherCategoryName,
      businessSubCategory: businessSubCategory ?? this.businessSubCategory,
      businessCategory: businessCategory ?? this.businessCategory,
      mainBusinessCategory: mainBusinessCategory ?? this.mainBusinessCategory,
      mainBusinessCategoryId: mainBusinessCategoryId ?? this.mainBusinessCategoryId,
      businessCategoryId: businessCategoryId ?? this.businessCategoryId,
      isOtherCategory: isOtherCategory ?? this.isOtherCategory,
      introducedByUser: introducedByUser ?? this.introducedByUser,
      isPro: isPro ?? this.isPro,
      isFollowing: isFollowing ?? this.isFollowing,
      isBookmark: isBookmark ?? this.isBookmark,
      isConnected: isConnected ?? this.isConnected,
      isRequested: isRequested ?? this.isRequested,
      connectionStatus: connectionStatus ?? this.connectionStatus,
      isOnline: isOnline ?? this.isOnline,
      isBlocked: isBlocked ?? this.isBlocked,
    );
  }

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
        testimonialsCount,
        bio,
        skills,
        interests,
        socialLinks,
        isVerified,
        isPro,
        isFollowing,
        isBookmark,
        connectionStatus,
        isBlocked,
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
