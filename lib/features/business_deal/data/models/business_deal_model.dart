import '../../../../core/constants/app_environment.dart';
import '../../domain/entities/business_deal_entity.dart';

class BusinessDealModel extends BusinessDealEntity {
  const BusinessDealModel({
    required super.id,
    super.fromUserId,
    super.toUserId,
    required super.dealDate,
    required super.dealAmount,
    super.businessType = 'new',
    super.comment,
    super.referralId,
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
    super.postId,
    super.mediaUrls = const [],
  });

  factory BusinessDealModel.fromJson(Map<String, dynamic> json) {
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

    // Check other_user / from_user / to_user / given_by / given_to map
    Map<String, dynamic>? userMap;
    if (json['other_user'] is Map<String, dynamic>) {
      userMap = json['other_user'] as Map<String, dynamic>;
    } else if (json['from_user'] is Map<String, dynamic>) {
      userMap = json['from_user'] as Map<String, dynamic>;
      fromUserId ??= userMap['id']?.toString();
    } else if (json['to_user'] is Map<String, dynamic>) {
      userMap = json['to_user'] as Map<String, dynamic>;
      toUserId ??= userMap['id']?.toString();
    } else if (json['given_by'] is Map<String, dynamic>) {
      userMap = json['given_by'] as Map<String, dynamic>;
      fromUserId ??= userMap['id']?.toString();
    } else if (json['given_to'] is Map<String, dynamic>) {
      userMap = json['given_to'] as Map<String, dynamic>;
      toUserId ??= userMap['id']?.toString();
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

    double dealAmount = 0.0;
    if (json['deal_amount'] != null) {
      if (json['deal_amount'] is num) {
        dealAmount = (json['deal_amount'] as num).toDouble();
      } else {
        dealAmount = double.tryParse(json['deal_amount'].toString()) ?? 0.0;
      }
    } else if (json['amount'] != null) {
      if (json['amount'] is num) {
        dealAmount = (json['amount'] as num).toDouble();
      } else {
        dealAmount = double.tryParse(json['amount'].toString()) ?? 0.0;
      }
    }

    final dealDate = (json['deal_date'] ??
            json['date'] ??
            json['created_at'] ??
            DateTime.now().toIso8601String().substring(0, 10))
        .toString();

    final businessType = (json['business_type'] ?? 'new').toString();

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

    String resolveFileUrl(String input) {
      final s = input.trim();
      if (s.isEmpty) return '';
      if (s.startsWith('http://') || s.startsWith('https://')) return s;
      if (s.startsWith('/')) return '${AppEnvironment.baseUrl}$s';
      return '${AppEnvironment.baseUrl}/files/$s';
    }

    final mediaList = <String>[];
    void addMediaUrl(String? u) {
      if (u == null) return;
      final resolved = resolveFileUrl(u);
      if (resolved.isNotEmpty && !mediaList.contains(resolved)) {
        mediaList.add(resolved);
      }
    }

    final mediaSource = json['media'] ?? json['media_files'] ?? json['attachments'];
    if (mediaSource is List) {
      for (final m in mediaSource) {
        if (m is Map) {
          final url = m['url'] ??
              m['file_url'] ??
              m['path'] ??
              (m['id'] != null
                  ? '${AppEnvironment.baseUrl}/files/${m['id']}'
                  : (m['file_id'] != null
                      ? '${AppEnvironment.baseUrl}/files/${m['file_id']}'
                      : null));
          addMediaUrl(url?.toString());
        } else if (m is String && m.isNotEmpty) {
          addMediaUrl(m);
        }
      }
    }

    if (json['media_file_id'] != null &&
        json['media_file_id'].toString().isNotEmpty) {
      addMediaUrl('${AppEnvironment.baseUrl}/files/${json['media_file_id']}');
    }

    if (json['creative_url'] != null &&
        json['creative_url'].toString().isNotEmpty) {
      addMediaUrl(json['creative_url'].toString());
    }

    if (json['creative_image_url'] != null &&
        json['creative_image_url'].toString().isNotEmpty) {
      addMediaUrl(json['creative_image_url'].toString());
    }

    if (json['creative_file_id'] != null &&
        json['creative_file_id'].toString().isNotEmpty) {
      addMediaUrl('${AppEnvironment.baseUrl}/files/${json['creative_file_id']}');
    }

    return BusinessDealModel(
      id: (json['id'] ?? '').toString(),
      fromUserId: fromUserId,
      toUserId: toUserId,
      dealDate: dealDate,
      dealAmount: dealAmount,
      businessType: businessType,
      comment: json['comment']?.toString() ?? json['notes']?.toString(),
      referralId: json['referral_id']?.toString(),
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
      postId: json['post_id']?.toString(),
      mediaUrls: mediaList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'from_user_id': fromUserId,
      'to_user_id': toUserId,
      'deal_date': dealDate,
      'deal_amount': dealAmount,
      'business_type': businessType,
      'comment': comment,
      'referral_id': referralId,
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
