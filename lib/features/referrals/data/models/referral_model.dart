import '../../domain/entities/referral_entity.dart';

class ReferralModel extends ReferralEntity {
  const ReferralModel({
    required super.id,
    super.fromUserId,
    super.toUserId,
    super.referralType = 'b2b_referral',
    required super.referralDate,
    required super.referralOf,
    super.phone,
    super.email,
    super.address,
    super.hotValue = 3,
    super.remarks,
    super.statusId,
    super.statusName = 'Pending',
    required super.peerName,
    super.peerPhotoUrl,
    super.peerDesignation,
    super.peerCompany,
    super.peerLocation,
    super.city,
    super.category,
    super.lifeImpactedCount,
    super.isPro = false,
    super.createdAt,
    super.updatedAt,
    super.coinsEarned,
    super.impactEarned,
  });

  factory ReferralModel.fromJson(Map<String, dynamic> json) {
    String? fromUserId =
        json['from_user_id']?.toString() ?? json['giver_id']?.toString();
    String? toUserId =
        json['to_user_id']?.toString() ?? json['receiver_id']?.toString();

    String peerName = 'Peers Member';
    String? peerPhotoUrl;
    String? peerDesignation;
    String? peerCompany;
    String? peerLocation;
    String? city;
    String? category;
    int? lifeImpactedCount;
    bool isPro = false;

    // Check user map inside json: given_to, given_by, to_user, from_user, other_user, user
    Map<String, dynamic>? userMap;
    if (json['other_user'] is Map<String, dynamic>) {
      userMap = json['other_user'] as Map<String, dynamic>;
    } else if (json['to_user'] is Map<String, dynamic>) {
      userMap = json['to_user'] as Map<String, dynamic>;
      toUserId ??= userMap['id']?.toString();
    } else if (json['from_user'] is Map<String, dynamic>) {
      userMap = json['from_user'] as Map<String, dynamic>;
      fromUserId ??= userMap['id']?.toString();
    } else if (json['given_to'] is Map<String, dynamic>) {
      userMap = json['given_to'] as Map<String, dynamic>;
      toUserId ??= userMap['id']?.toString();
    } else if (json['given_by'] is Map<String, dynamic>) {
      userMap = json['given_by'] as Map<String, dynamic>;
      fromUserId ??= userMap['id']?.toString();
    } else if (json['user'] is Map<String, dynamic>) {
      userMap = json['user'] as Map<String, dynamic>;
    }

    if (userMap != null) {
      final firstName = userMap['first_name']?.toString() ?? '';
      final lastName = userMap['last_name']?.toString() ?? '';
      final combinedName = '$firstName $lastName'.trim();

      peerName = (userMap['display_name'] ??
              (combinedName.isNotEmpty ? combinedName : null) ??
              userMap['name'] ??
              userMap['full_name'] ??
              'Peers Member')
          .toString();

      peerPhotoUrl = (userMap['profile_photo_url'] ??
              userMap['profile_photo'] ??
              userMap['avatar'])
          ?.toString();
      peerDesignation = userMap['designation']?.toString();
      peerCompany = userMap['company_name']?.toString() ??
          userMap['company']?.toString();
      city = userMap['city']?.toString() ?? userMap['location']?.toString();
      peerLocation = city;
      category = userMap['level4_category']?.toString() ??
          userMap['category']?.toString();
      if (userMap['life_impacted_count'] != null) {
        lifeImpactedCount =
            int.tryParse(userMap['life_impacted_count'].toString());
      }
      isPro = userMap['is_pro'] == true ||
          userMap['is_pro'] == 1 ||
          userMap['is_pro'] == '1';
    } else {
      peerName = (json['other_user_name'] ??
              json['peer_name'] ??
              json['to_user_name'] ??
              json['from_user_name'] ??
              json['given_to_name'] ??
              json['given_by_name'] ??
              'Peers Member')
          .toString();
      peerPhotoUrl = (json['other_user_profile_photo_url'] ??
              json['peer_photo_url'] ??
              json['profile_photo_url'])
          ?.toString();
      peerDesignation =
          json['other_user_designation']?.toString() ?? json['designation']?.toString();
      peerCompany = json['other_user_company']?.toString() ??
          json['company_name']?.toString();
      city = json['other_user_location']?.toString() ??
          json['city']?.toString() ??
          json['location']?.toString();
      peerLocation = city;
      category = json['level4_category']?.toString() ?? json['category']?.toString();
      if (json['life_impacted_count'] != null) {
        lifeImpactedCount =
            int.tryParse(json['life_impacted_count'].toString());
      }
      isPro = json['is_pro'] == true || json['is_pro'] == 1;
    }

    final referralOf = (json['referral_of'] ??
            json['company_name'] ??
            json['client_name'] ??
            json['name'] ??
            'Referral')
        .toString();

    final referralDate = (json['referral_date'] ??
            json['date'] ??
            json['created_at'] ??
            DateTime.now().toIso8601String().substring(0, 10))
        .toString();

    final referralType = (json['referral_type'] ?? 'b2b_referral').toString();

    int hotValue = 3;
    if (json['hot_value'] != null) {
      if (json['hot_value'] is int) {
        hotValue = json['hot_value'] as int;
      } else {
        hotValue = int.tryParse(json['hot_value'].toString()) ?? 3;
      }
    }

    int? statusId;
    String statusName = 'Pending';
    if (json['status_id'] != null) {
      statusId = json['status_id'] is int
          ? json['status_id'] as int
          : int.tryParse(json['status_id'].toString());
    }

    if (json['status'] is Map) {
      final statusMap = json['status'] as Map;
      statusId ??= int.tryParse(statusMap['id']?.toString() ?? '');
      statusName = statusMap['name']?.toString() ?? 'Pending';
    } else if (json['status'] is String) {
      statusName = json['status'] as String;
    } else if (statusId != null) {
      switch (statusId) {
        case 1:
          statusName = 'Pending';
          break;
        case 2:
          statusName = 'Contacted';
          break;
        case 3:
          statusName = 'Got Business';
          break;
        case 4:
          statusName = 'Not Qualified';
          break;
        default:
          statusName = 'Pending';
      }
    }

    int? coinsEarned;
    if (json['coins'] is Map) {
      final coinsMap = json['coins'] as Map;
      coinsEarned = int.tryParse(coinsMap['earned']?.toString() ?? '');
    } else if (json['coins_earned'] != null) {
      coinsEarned = int.tryParse(json['coins_earned'].toString());
    } else if (json['coins'] != null && json['coins'] is! Map) {
      coinsEarned = int.tryParse(json['coins'].toString());
    }

    int? impactEarned;
    if (json['impacts'] is Map) {
      final impactsMap = json['impacts'] as Map;
      impactEarned = int.tryParse(impactsMap['earned']?.toString() ?? '');
    } else if (json['life_impact'] is Map) {
      final lifeImpactMap = json['life_impact'] as Map;
      impactEarned = int.tryParse(lifeImpactMap['earned']?.toString() ?? '');
    } else if (json['impacts_earned'] != null) {
      impactEarned = int.tryParse(json['impacts_earned'].toString());
    } else if (json['impact_earned'] != null) {
      impactEarned = int.tryParse(json['impact_earned'].toString());
    } else if (json['impacts'] != null && json['impacts'] is! Map) {
      impactEarned = int.tryParse(json['impacts'].toString());
    }

    return ReferralModel(
      id: (json['id'] ?? '').toString(),
      fromUserId: fromUserId,
      toUserId: toUserId,
      referralType: referralType,
      referralDate: referralDate,
      referralOf: referralOf,
      phone: json['phone']?.toString(),
      email: json['email']?.toString(),
      address: json['address']?.toString(),
      hotValue: hotValue.clamp(1, 5),
      remarks: json['remarks']?.toString() ?? json['notes']?.toString(),
      statusId: statusId,
      statusName: statusName,
      peerName: peerName,
      peerPhotoUrl: peerPhotoUrl,
      peerDesignation: peerDesignation,
      peerCompany: peerCompany,
      peerLocation: peerLocation,
      city: city,
      category: category,
      lifeImpactedCount: lifeImpactedCount,
      isPro: isPro,
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
      coinsEarned: coinsEarned,
      impactEarned: impactEarned,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'from_user_id': fromUserId,
      'to_user_id': toUserId,
      'referral_type': referralType,
      'referral_date': referralDate,
      'referral_of': referralOf,
      'phone': phone,
      'email': email,
      'address': address,
      'hot_value': hotValue,
      'remarks': remarks,
      'status_id': statusId,
      'status_name': statusName,
      'peer_name': peerName,
      'peer_photo_url': peerPhotoUrl,
      'peer_designation': peerDesignation,
      'peer_company': peerCompany,
      'peer_location': peerLocation,
      'city': city,
      'category': category,
      'life_impacted_count': lifeImpactedCount,
      'is_pro': isPro,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
