import 'dart:convert';
import '../../../../core/constants/app_environment.dart';
import '../../domain/entities/testimonial_entity.dart';
import '../../domain/entities/testimonial_media_entity.dart';

class TestimonialMediaModel extends TestimonialMediaEntity {
  const TestimonialMediaModel({
    required super.id,
    required super.type,
    super.url,
  });

  factory TestimonialMediaModel.fromJson(Map<String, dynamic> json) {
    final id = (json['id'] ?? '').toString();
    final type = (json['type'] ?? 'image').toString();
    String? url = json['url']?.toString();
    if ((url == null || url.isEmpty) && id.isNotEmpty) {
      url = '${AppEnvironment.baseUrl}/files/$id';
    }
    return TestimonialMediaModel(
      id: id,
      type: type,
      url: url,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'url': url,
    };
  }
}

class TestimonialModel extends TestimonialEntity {
  const TestimonialModel({
    required super.id,
    required super.content,
    super.fromUserId,
    super.toUserId,
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
    super.rating,
    super.media = const [],
    super.coinsEarned,
    super.impactEarned,
  });

  factory TestimonialModel.fromJson(Map<String, dynamic> json) {
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

    // Check other_user / given_by / given_to map
    Map<String, dynamic>? userMap;
    if (json['other_user'] is Map<String, dynamic>) {
      userMap = json['other_user'] as Map<String, dynamic>;
    } else if (json['given_by'] is Map<String, dynamic>) {
      userMap = json['given_by'] as Map<String, dynamic>;
      fromUserId ??= userMap['id']?.toString();
    } else if (json['given_to'] is Map<String, dynamic>) {
      userMap = json['given_to'] as Map<String, dynamic>;
      toUserId ??= userMap['id']?.toString();
    }

    if (userMap != null) {
      peerName = (userMap['name'] ??
              userMap['display_name'] ??
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
              json['giver_name'] ??
              'Peers Member')
          .toString();
      peerPhotoUrl = (json['other_user_profile_photo_url'] ??
              json['peer_photo_url'] ??
              json['giver_photo_url'])
          ?.toString();
      peerDesignation =
          json['other_user_designation']?.toString() ?? json['designation']?.toString();
      peerCompany = json['other_user_company']?.toString() ??
          json['company_name']?.toString();
      city = json['other_user_location']?.toString() ??
          json['city']?.toString() ??
          json['location']?.toString();
      peerLocation = city;
      category = json['level4_category']?.toString();
      if (json['life_impacted_count'] != null) {
        lifeImpactedCount =
            int.tryParse(json['life_impacted_count'].toString());
      }
      isPro = json['is_pro'] == true;
    }

    final List<TestimonialMediaModel> mediaList = [];
    dynamic rawMedia = json['media'];
    if (rawMedia is String && rawMedia.trim().isNotEmpty) {
      try {
        rawMedia = jsonDecode(rawMedia);
      } catch (_) {
        rawMedia = null;
      }
    }
    if (rawMedia is List) {
      for (final item in rawMedia) {
        if (item is Map<String, dynamic>) {
          mediaList.add(TestimonialMediaModel.fromJson(item));
        }
      }
    }

    double? rating;
    if (json['rating'] != null) {
      rating = double.tryParse(json['rating'].toString());
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

    return TestimonialModel(
      id: (json['id'] ?? '').toString(),
      content: (json['content'] ?? json['message'] ?? '').toString(),
      fromUserId: fromUserId,
      toUserId: toUserId,
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
      rating: rating,
      media: mediaList,
      coinsEarned: coinsEarned,
      impactEarned: impactEarned,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'from_user_id': fromUserId,
      'to_user_id': toUserId,
      'peer_name': peerName,
      'peer_photo_url': peerPhotoUrl,
      'peer_designation': peerDesignation,
      'peer_company': peerCompany,
      'peer_location': peerLocation,
      'city': city,
      'level4_category': category,
      'life_impacted_count': lifeImpactedCount,
      'is_pro': isPro,
      'created_at': createdAt,
      'rating': rating,
      'media': media.map((m) {
        if (m is TestimonialMediaModel) return m.toJson();
        return {'id': m.id, 'type': m.type, 'url': m.url};
      }).toList(),
    };
  }
}
