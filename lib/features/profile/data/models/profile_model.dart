import '../../domain/entities/profile_entity.dart';

class ProfileModel extends ProfileEntity {
  const ProfileModel({
    required super.id,
    super.userId,
    super.peerId,
    super.publicProfileSlug,
    super.profilePhotoId,
    super.profilePhotoUrl,
    super.coverPhotoId,
    super.coverPhotoUrl,
    super.profileVideoId,
    super.profileVideoUrl,
    super.welcomeCreativeUrl,
    super.firstName,
    super.lastName,
    required super.displayName,
    super.companyName,
    super.designation,
    super.email,
    super.phone,
    super.secondaryMobile,
    super.gender,
    super.dob,
    super.anniversaryDate,
    super.preferredLanguage,
    super.city,
    super.state,
    super.country,
    super.pincode,
    super.address,
    super.timezone,
    super.membershipStatus,
    super.membershipStatusLabel,
    super.membershipStartsAt,
    super.membershipEndsAt,
    super.zohoPlanCode,
    super.zohoSubscriptionId,
    super.activeCircleId,
    super.circleJoinedAt,
    super.circleExpiresAt,
    super.activeCircle,
    super.circleMemberships = const [],
    super.categories = const [],
    super.connectionCount = 0,
    super.followersCount = 0,
    super.followingCount = 0,
    super.postsCount = 0,
    super.coinsBalance = 0,
    super.lifeImpactedCount = 0,
    super.badgesCount = 0,
    super.p2pMeetingsCount = 0,
    super.referralsCount = 0,
    super.businessDealsCount = 0,
    super.testimonialsCount = 0,
    super.businessType,
    super.experienceYears,
    super.experienceSummary,
    super.bio,
    super.longBioHtml,
    super.skills = const [],
    super.interests = const [],
    super.industryTags = const [],
    super.targetRegions = const [],
    super.targetBusinessCategories = const [],
    super.hobbiesInterests = const [],
    super.leadershipRoles = const [],
    super.specialRecognitions = const [],
    super.socialLinks,
    super.media = const [],
    super.isVerified = false,
    super.isSponsoredMember = false,
    super.companyType,
    super.yearOfEstablishment,
    super.annualRevenueRange,
    super.turnoverRange,
    super.numberOfEmployees,
    super.gstNumber,
    super.businessWebsite,
    super.superpower,
    super.iCanHelpWith = const [],
    super.iAmLookingFor = const [],
    super.businessKeywords = const [],
    super.productsServicesOffered,
    super.businessAddress,
    super.googleMapsLatitude,
    super.googleMapsLongitude,
    super.businessCity,
    super.businessState,
    super.businessPincode,
    super.businessCountry,
    super.industriesOfInterest = const [],
    super.collaborationGoals = const [],
    super.preferredMeetingFormat,
    super.willingToMentor = false,
    super.openToCrossCityCollaboration = false,
    super.openToSpeakingAtEvents = false,
    super.communityDirectoryListing,
    super.contactVisibility,
    super.sustainabilityAreas = const [],
    super.greenpreneurGoals = const [],
    super.otherCategoryName,
    super.businessSubCategory,
    super.businessCategory,
    super.mainBusinessCategory,
    super.mainBusinessCategoryId,
    super.businessCategoryId,
    super.isOtherCategory = false,
    super.introducedByUser,
    super.isPro = false,
    super.isFollowing = false,
    super.isBookmark = false,
    super.isConnected = false,
    super.isRequested = false,
    super.connectionStatus = 'none',
    super.isOnline = false,
    super.isBlocked = false,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    final root =
        (json.containsKey('data') && json['data'] is Map<String, dynamic>)
        ? json['data'] as Map<String, dynamic>
        : json;

    // City parsing
    ProfileCityEntity? cityEntity;
    if (root['city'] is Map) {
      final c = root['city'] as Map<String, dynamic>;
      cityEntity = ProfileCityEntity(
        id: c['id']?.toString(),
        name: (c['name'] ?? c['display_name'] ?? c['formatted_location'] ?? '')
            .toString(),
        formattedLocation: c['formatted_location']?.toString(),
      );
    } else if (root['city'] != null &&
        root['city'].toString().trim().isNotEmpty) {
      cityEntity = ProfileCityEntity(
        name: root['city'].toString(),
        formattedLocation: root['city'].toString(),
      );
    }

    // Active Circle parsing
    ActiveCircleEntity? activeCircleEntity;
    if (root['active_circle'] is Map) {
      final ac = root['active_circle'] as Map<String, dynamic>;
      ProfileCityEntity? circleCity;
      if (ac['city'] is Map) {
        final cc = ac['city'] as Map<String, dynamic>;
        circleCity = ProfileCityEntity(
          id: cc['id']?.toString(),
          name: (cc['name'] ?? '').toString(),
        );
      }
      activeCircleEntity = ActiveCircleEntity(
        id: (ac['id'] ?? '').toString(),
        name: (ac['name'] ?? 'Peers Circle').toString(),
        slug: ac['slug']?.toString(),
        city: circleCity,
      );
    }

    // Circle Memberships
    final List<CircleMembershipEntity> memberships = [];
    if (root['circle_memberships'] is List) {
      for (final item in root['circle_memberships']) {
        if (item is Map<String, dynamic>) {
          memberships.add(
            CircleMembershipEntity(
              circleMemberId: (item['circle_member_id'] ?? item['id'] ?? '')
                  .toString(),
              circleId: (item['circle_id'] ?? '').toString(),
              circleName: (item['circle_name'] ?? '').toString(),
              circleSlug: item['circle_slug']?.toString(),
              memberStatus: item['member_status']?.toString(),
              memberRole: item['member_role']?.toString(),
              joinedAt: item['joined_at']?.toString(),
              expiresAt: item['expires_at']?.toString(),
              paymentStatus: item['payment_status']?.toString(),
            ),
          );
        }
      }
    }

    // Categories parsing
    final List<ProfileCategoryEntity> categoriesList = [];
    if (root['categories'] is List) {
      for (final item in root['categories']) {
        if (item is Map<String, dynamic>) {
          String? l1, l2, l3, l4;
          if (item['level1_category'] is Map) {
            l1 = item['level1_category']['name']?.toString();
          } else if (item['level1'] != null) {
            l1 = item['level1'].toString();
          }
          if (item['level2_category'] is Map) {
            l2 = item['level2_category']['name']?.toString();
          } else if (item['level2'] != null) {
            l2 = item['level2'].toString();
          }
          if (item['level3_category'] is Map) {
            l3 = item['level3_category']['name']?.toString();
          } else if (item['level3'] != null) {
            l3 = item['level3'].toString();
          }
          if (item['level4_category'] is Map) {
            l4 = item['level4_category']['name']?.toString();
          } else if (item['level4'] != null) {
            l4 = item['level4'].toString();
          }
          categoriesList.add(
            ProfileCategoryEntity(
              circleId: (item['circle_id'] ?? '').toString(),
              circleName: (item['circle_name'] ?? '').toString(),
              level1: l1,
              level2: l2,
              level3: l3,
              level4: l4,
            ),
          );
        }
      }
    }

    // Social links parsing
    SocialLinksEntity? socialEntity;
    if (root['social_links'] is Map) {
      final s = root['social_links'] as Map<String, dynamic>;
      socialEntity = SocialLinksEntity(
        website:
            s['website']?.toString() ??
            root['website']?.toString() ??
            root['business_website']?.toString(),
        linkedin:
            s['linkedin']?.toString() ?? root['linkedin_profile']?.toString(),
        instagram:
            s['instagram']?.toString() ?? root['instagram_handle']?.toString(),
        facebook:
            s['facebook']?.toString() ?? root['facebook_profile']?.toString(),
        twitter: s['twitter']?.toString() ?? root['twitter_handle']?.toString(),
        youtube:
            s['youtube']?.toString() ?? root['youtube_channel']?.toString(),
        otherWebsite:
            s['other_website']?.toString() ?? root['other_website']?.toString(),
      );
    } else {
      socialEntity = SocialLinksEntity(
        website:
            root['website']?.toString() ?? root['business_website']?.toString(),
        linkedin: root['linkedin_profile']?.toString(),
        instagram: root['instagram_handle']?.toString(),
        facebook: root['facebook_profile']?.toString(),
        twitter: root['twitter_handle']?.toString(),
        youtube: root['youtube_channel']?.toString(),
        otherWebsite: root['other_website']?.toString(),
      );
    }

    // Media parsing
    final List<MediaItemEntity> mediaList = [];
    if (root['media'] is List) {
      for (final item in root['media']) {
        if (item is Map<String, dynamic>) {
          mediaList.add(
            MediaItemEntity(
              id: (item['id'] ?? '').toString(),
              url: (item['url'] ?? '').toString(),
              type: (item['type'] ?? 'image').toString(),
            ),
          );
        }
      }
    }

    // Introduced by parsing
    IntroducedByUserEntity? introducedEntity;
    if (root['introduced_by_user'] is Map) {
      final u = root['introduced_by_user'] as Map<String, dynamic>;
      introducedEntity = IntroducedByUserEntity(
        id: (u['id'] ?? '').toString(),
        name: (u['name'] ?? u['displayName'] ?? '').toString(),
        profilePhotoUrl: u['profile_photo_url']?.toString(),
      );
    }

    List<String> parseStringList(dynamic val) {
      if (val is List) {
        return val
            .map((e) => e.toString().trim())
            .where((e) => e.isNotEmpty)
            .toList();
      }
      return const [];
    }

    return ProfileModel(
      id: (root['id'] ?? root['user_id'] ?? '').toString(),
      userId: root['user_id']?.toString() ?? root['userId']?.toString(),
      peerId: root['peer_id']?.toString(),
      publicProfileSlug: root['public_profile_slug']?.toString(),
      profilePhotoId: root['profile_photo_id']?.toString(),
      profilePhotoUrl: root['profile_photo_url']?.toString(),
      coverPhotoId: root['cover_photo_id']?.toString(),
      coverPhotoUrl: root['cover_photo_url']?.toString(),
      profileVideoId: (root['profile_video'] is Map
              ? (root['profile_video']['id']?.toString())
              : null) ??
          (root['profile_video_id'] ??
                  root['intro_video_id'] ??
                  root['profile_video_file_id'] ??
                  root['intro_video_file_id'])
              ?.toString(),
      profileVideoUrl: (root['profile_video'] is Map
              ? (root['profile_video']['url']?.toString())
              : null) ??
          (root['profile_video_url'] ??
                  root['intro_video_url'] ??
                  (root['profile_video'] is String ? root['profile_video'] : null) ??
                  root['intro_video'])
              ?.toString(),
      welcomeCreativeUrl: root['welcome_creative_url']?.toString(),
      firstName: root['first_name']?.toString(),
      lastName: root['last_name']?.toString(),
      displayName: (root['display_name'] ?? root['name'] ?? 'Peers Member')
          .toString(),
      companyName: root['company_name']?.toString(),
      designation: root['designation']?.toString(),
      email: root['email']?.toString(),
      phone: root['phone']?.toString(),
      secondaryMobile: root['secondary_mobile']?.toString(),
      gender: root['gender']?.toString(),
      dob: root['dob']?.toString(),
      anniversaryDate: root['anniversary_date']?.toString(),
      preferredLanguage: root['preferred_language']?.toString(),
      city: cityEntity,
      state: root['state']?.toString(),
      country: root['country']?.toString(),
      pincode: root['pincode']?.toString(),
      address: root['address']?.toString(),
      timezone: root['timezone']?.toString(),
      membershipStatus: root['membership_status']?.toString(),
      membershipStatusLabel:
          root['membership_status_label']?.toString() ?? 'Member',
      membershipStartsAt: (root['membership_starts_at'] ?? root['membership_start_date'])?.toString(),
      membershipEndsAt: (root['membership_ends_at'] ?? root['membership_expiry'] ?? root['membership_end_date'])?.toString(),
      zohoPlanCode: root['zoho_plan_code']?.toString() ?? root['plan_code']?.toString(),
      zohoSubscriptionId: root['zoho_subscription_id']?.toString() ?? root['subscription_id']?.toString(),
      activeCircleId: root['active_circle_id']?.toString(),
      circleJoinedAt: root['circle_joined_at']?.toString(),
      circleExpiresAt: root['circle_expires_at']?.toString(),
      activeCircle: activeCircleEntity,
      circleMemberships: memberships,
      categories: categoriesList,
      connectionCount:
          int.tryParse(root['connection_count']?.toString() ?? '0') ?? 0,
      followersCount:
          int.tryParse(root['followers_count']?.toString() ?? '0') ?? 0,
      followingCount:
          int.tryParse(root['following_count']?.toString() ?? '0') ?? 0,
      postsCount: int.tryParse(root['posts_count']?.toString() ?? '0') ?? 0,
      coinsBalance: int.tryParse(root['coins_balance']?.toString() ?? '0') ?? 0,
      lifeImpactedCount:
          int.tryParse(root['life_impacted_count']?.toString() ?? '0') ?? 0,
      badgesCount: int.tryParse(root['badges_count']?.toString() ?? '0') ?? 0,
      p2pMeetingsCount:
          int.tryParse(root['p2p_meetings_count']?.toString() ?? '0') ?? 0,
      referralsCount:
          int.tryParse(root['referrals_count']?.toString() ?? '0') ?? 0,
      businessDealsCount:
          int.tryParse(
            root['business_deals_count']?.toString() ??
                root['deals_count']?.toString() ??
                '0',
          ) ??
          0,
      testimonialsCount:
          int.tryParse(root['testimonials_count']?.toString() ?? '0') ?? 0,
      businessType: root['business_type']?.toString(),
      experienceYears: int.tryParse(root['experience_years']?.toString() ?? ''),
      experienceSummary: root['experience_summary']?.toString(),
      bio: root['bio']?.toString(),
      longBioHtml: root['long_bio_html']?.toString(),
      skills: parseStringList(root['skills']),
      interests: parseStringList(root['interests']),
      industryTags: parseStringList(root['industry_tags']),
      targetRegions: parseStringList(root['target_regions']),
      targetBusinessCategories: parseStringList(
        root['target_business_categories'],
      ),
      hobbiesInterests: parseStringList(root['hobbies_interests']),
      leadershipRoles: parseStringList(root['leadership_roles']),
      specialRecognitions: parseStringList(root['special_recognitions']),
      socialLinks: socialEntity,
      media: mediaList,
      isVerified:
          root['is_verified'] == true || root['is_verified_peer'] == true,
      isSponsoredMember: root['is_sponsored_member'] == true,
      companyType: root['company_type']?.toString(),
      yearOfEstablishment: int.tryParse(
        root['year_of_establishment']?.toString() ?? '',
      ),
      annualRevenueRange: root['annual_revenue_range']?.toString(),
      turnoverRange: root['turnover_range']?.toString(),
      numberOfEmployees: root['number_of_employees']?.toString(),
      gstNumber: root['gst_number']?.toString(),
      businessWebsite: root['business_website']?.toString(),
      superpower: root['superpower']?.toString(),
      iCanHelpWith: parseStringList(root['i_can_help_with']),
      iAmLookingFor: parseStringList(root['i_am_looking_for']),
      businessKeywords: parseStringList(root['business_keywords']),
      productsServicesOffered: root['products_services_offered']?.toString(),
      businessAddress: root['business_address']?.toString(),
      googleMapsLatitude: double.tryParse(
        root['google_maps_latitude']?.toString() ??
            root['latitude']?.toString() ??
            '',
      ),
      googleMapsLongitude: double.tryParse(
        root['google_maps_longitude']?.toString() ??
            root['longitude']?.toString() ??
            '',
      ),
      businessCity: root['business_city']?.toString(),
      businessState: root['business_state']?.toString(),
      businessPincode: root['business_pincode']?.toString(),
      businessCountry: root['business_country']?.toString(),
      industriesOfInterest: parseStringList(root['industries_of_interest']),
      collaborationGoals: parseStringList(root['collaboration_goals']),
      preferredMeetingFormat: root['preferred_meeting_format']?.toString(),
      willingToMentor: root['willing_to_mentor'] == true,
      openToCrossCityCollaboration:
          root['open_to_cross_city_collaboration'] == true,
      openToSpeakingAtEvents: root['open_to_speaking_at_events'] == true,
      communityDirectoryListing: root['community_directory_listing']
          ?.toString(),
      contactVisibility: root['contact_visibility']?.toString(),
      sustainabilityAreas: parseStringList(root['sustainability_areas']),
      greenpreneurGoals: parseStringList(root['greenpreneur_goals']),
      otherCategoryName: root['other_category_name']?.toString(),
      businessSubCategory: root['business_sub_category']?.toString(),
      businessCategory: root['business_category'] is Map
          ? (root['business_category']['name'] ??
                    root['business_category']['title'])
                ?.toString()
          : root['business_category']?.toString(),
      mainBusinessCategory: root['main_business_category'] is Map
          ? (root['main_business_category']['name'] ??
                    root['main_business_category']['title'])
                ?.toString()
          : root['main_business_category']?.toString(),
      mainBusinessCategoryId:
          int.tryParse(root['main_business_category_id']?.toString() ?? '') ??
          (root['main_business_category'] is Map
              ? int.tryParse(
                  root['main_business_category']['id']?.toString() ?? '',
                )
              : null),
      businessCategoryId:
          int.tryParse(root['business_category_id']?.toString() ?? '') ??
          (root['business_category'] is Map
              ? int.tryParse(root['business_category']['id']?.toString() ?? '')
              : null),
      isOtherCategory: root['is_other_category'] == true,
      introducedByUser: introducedEntity,
      isPro: root['is_pro'] == true ||
          root['is_pro'] == 1 ||
          root['is_pro']?.toString() == '1' ||
          (root['zoho_plan_code'] != null && root['zoho_plan_code'].toString().isNotEmpty) ||
          (root['zoho_subscription_id'] != null && root['zoho_subscription_id'].toString().isNotEmpty) ||
          (root['membership_status'] != null &&
              ['only_unity_peer', 'only unity peer', 'global_peer', 'circle_peer', 'multi_circle_peer', 'chartered_peer']
                  .contains(root['membership_status'].toString().toLowerCase().trim())),
      isFollowing: root['is_following'] == true,
      isBookmark: root['is_bookmark'] == true,
      isConnected: root['is_connected'] == true || root['connection_status'] == 'connected',
      isRequested: root['is_requested'] == true || root['connection_status'] == 'pending_sent' || root['connection_status'] == 'pending',
      connectionStatus: (root['connection_status'] ??
              root['connection_state'] ??
              (root['is_connected'] == true ? 'connected' : (root['is_requested'] == true ? 'pending' : 'none')))
          .toString(),
      isOnline: root['is_online'] == true ||
          root['is_online'] == 1 ||
          root['is_online'] == '1' ||
          root['online_status'] == 'online',
      isBlocked: root['is_blocked'] == true ||
          root['is_blocked_by_me'] == true ||
          root['blocked'] == true ||
          root['block_status'] == 'blocked',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'peer_id': peerId,
      'public_profile_slug': publicProfileSlug,
      'profile_photo_id': profilePhotoId,
      'profile_photo_url': profilePhotoUrl,
      'cover_photo_id': coverPhotoId,
      'cover_photo_url': coverPhotoUrl,
      'profile_video_id': profileVideoId,
      'profile_video_url': profileVideoUrl,
      'welcome_creative_url': welcomeCreativeUrl,
      'first_name': firstName,
      'last_name': lastName,
      'display_name': displayName,
      'company_name': companyName,
      'designation': designation,
      'email': email,
      'phone': phone,
      'secondary_mobile': secondaryMobile,
      'gender': gender,
      'dob': dob,
      'anniversary_date': anniversaryDate,
      'preferred_language': preferredLanguage,
      'city': city != null
          ? {
              'id': city!.id,
              'name': city!.name,
              'formatted_location': city!.formattedLocation,
            }
          : null,
      'state': state,
      'country': country,
      'pincode': pincode,
      'address': address,
      'timezone': timezone,
      'membership_status': membershipStatus,
      'membership_status_label': membershipStatusLabel,
      'membership_starts_at': membershipStartsAt,
      'membership_ends_at': membershipEndsAt,
      'zoho_plan_code': zohoPlanCode,
      'zoho_subscription_id': zohoSubscriptionId,
      'active_circle_id': activeCircleId,
      'circle_joined_at': circleJoinedAt,
      'circle_expires_at': circleExpiresAt,
      'connection_count': connectionCount,
      'followers_count': followersCount,
      'following_count': followingCount,
      'posts_count': postsCount,
      'coins_balance': coinsBalance,
      'life_impacted_count': lifeImpactedCount,
      'badges_count': badgesCount,
      'p2p_meetings_count': p2pMeetingsCount,
      'referrals_count': referralsCount,
      'business_deals_count': businessDealsCount,
      'testimonials_count': testimonialsCount,
      'business_type': businessType,
      'experience_years': experienceYears,
      'experience_summary': experienceSummary,
      'bio': bio,
      'long_bio_html': longBioHtml,
      'skills': skills,
      'interests': interests,
      'industry_tags': industryTags,
      'target_regions': targetRegions,
      'target_business_categories': targetBusinessCategories,
      'hobbies_interests': hobbiesInterests,
      'leadership_roles': leadershipRoles,
      'special_recognitions': specialRecognitions,
      'is_verified': isVerified,
      'is_sponsored_member': isSponsoredMember,
      'company_type': companyType,
      'year_of_establishment': yearOfEstablishment,
      'annual_revenue_range': annualRevenueRange,
      'turnover_range': turnoverRange,
      'number_of_employees': numberOfEmployees,
      'gst_number': gstNumber,
      'business_website': businessWebsite,
      'superpower': superpower,
      'i_can_help_with': iCanHelpWith,
      'i_am_looking_for': iAmLookingFor,
      'business_keywords': businessKeywords,
      'products_services_offered': productsServicesOffered,
      'business_address': businessAddress,
      'business_city': businessCity,
      'business_state': businessState,
      'business_pincode': businessPincode,
      'business_country': businessCountry,
      'industries_of_interest': industriesOfInterest,
      'collaboration_goals': collaborationGoals,
      'preferred_meeting_format': preferredMeetingFormat,
      'willing_to_mentor': willingToMentor,
      'open_to_cross_city_collaboration': openToCrossCityCollaboration,
      'open_to_speaking_at_events': openToSpeakingAtEvents,
      'community_directory_listing': communityDirectoryListing,
      'contact_visibility': contactVisibility,
      'sustainability_areas': sustainabilityAreas,
      'greenpreneur_goals': greenpreneurGoals,
      'other_category_name': otherCategoryName,
      'business_sub_category': businessSubCategory,
      'business_category': businessCategory,
      'social_links': socialLinks != null
          ? {
              'website': socialLinks!.website,
              'linkedin': socialLinks!.linkedin,
              'instagram': socialLinks!.instagram,
              'facebook': socialLinks!.facebook,
              'twitter': socialLinks!.twitter,
              'youtube': socialLinks!.youtube,
              'other_website': socialLinks!.otherWebsite,
            }
          : null,
    };
  }

  Map<String, dynamic> toUpdatePayload() {
    return {
      if (firstName != null) 'first_name': firstName,
      if (lastName != null) 'last_name': lastName,
      if (displayName.isNotEmpty) 'display_name': displayName,
      if (companyName != null) 'company_name': companyName,
      if (designation != null) 'designation': designation,
      if (secondaryMobile != null) 'secondary_mobile': secondaryMobile,
      if (gender != null) 'gender': gender,
      if (dob != null) 'dob': dob,
      if (anniversaryDate != null) 'anniversary_date': anniversaryDate,
      if (preferredLanguage != null) 'preferred_language': preferredLanguage,
      if (city?.name != null) 'city': city!.name,
      if (state != null) 'state': state,
      if (country != null) 'country': country,
      if (pincode != null) 'pincode': pincode,
      if (address != null) 'address': address,
      if (profilePhotoId != null) 'profile_photo_id': profilePhotoId,
      if (coverPhotoId != null) 'cover_photo_id': coverPhotoId,
      if (profileVideoId != null) 'profile_video_id': profileVideoId,
      if (businessType != null) 'business_type': businessType,
      if (experienceYears != null) 'experience_years': experienceYears,
      if (experienceSummary != null) 'experience_summary': experienceSummary,
      if (bio != null) 'bio': bio,
      if (companyType != null) 'company_type': companyType,
      if (yearOfEstablishment != null)
        'year_of_establishment': yearOfEstablishment,
      if (annualRevenueRange != null)
        'annual_revenue_range': annualRevenueRange,
      if (numberOfEmployees != null) 'number_of_employees': numberOfEmployees,
      if (gstNumber != null) 'gst_number': gstNumber,
      if (businessWebsite != null) 'business_website': businessWebsite,
      if (businessAddress != null) 'business_address': businessAddress,
      if (googleMapsLatitude != null) 'google_maps_latitude': googleMapsLatitude,
      if (googleMapsLongitude != null) 'google_maps_longitude': googleMapsLongitude,
      if (businessPincode != null) 'business_pincode': businessPincode,
      if (businessCountry != null) 'business_country': businessCountry,
      if (otherCategoryName != null) 'other_category_name': otherCategoryName,
      if (businessSubCategory != null)
        'business_sub_category': businessSubCategory,
      if (productsServicesOffered != null)
        'products_services_offered': productsServicesOffered,
      if (superpower != null) 'superpower': superpower,
      if (preferredMeetingFormat != null)
        'preferred_meeting_format': preferredMeetingFormat,
      'skills': skills,
      'interests': interests,
      'i_can_help_with': iCanHelpWith,
      'i_am_looking_for': iAmLookingFor,
      'business_keywords': businessKeywords,
      'industries_of_interest': industriesOfInterest,
      'collaboration_goals': collaborationGoals,
      'sustainability_areas': sustainabilityAreas,
      'greenpreneur_goals': greenpreneurGoals,
      'special_recognitions': specialRecognitions,
      'leadership_roles': leadershipRoles,
      'willing_to_mentor': willingToMentor,
      'open_to_cross_city_collaboration': openToCrossCityCollaboration,
      'open_to_speaking_at_events': openToSpeakingAtEvents,
      if (communityDirectoryListing != null)
        'community_directory_listing': communityDirectoryListing,
      if (contactVisibility != null) 'contact_visibility': contactVisibility,
      if (socialLinks != null)
        'social_links': {
          if (socialLinks!.website != null) 'website': socialLinks!.website,
          if (socialLinks!.linkedin != null) 'linkedin': socialLinks!.linkedin,
          if (socialLinks!.instagram != null)
            'instagram': socialLinks!.instagram,
          if (socialLinks!.facebook != null) 'facebook': socialLinks!.facebook,
          if (socialLinks!.twitter != null) 'twitter': socialLinks!.twitter,
          if (socialLinks!.youtube != null) 'youtube': socialLinks!.youtube,
          if (socialLinks!.otherWebsite != null)
            'other_website': socialLinks!.otherWebsite,
        },
    };
  }
}
