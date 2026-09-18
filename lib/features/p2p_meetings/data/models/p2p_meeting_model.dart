import '../../../../core/constants/app_environment.dart';
import '../../domain/entities/p2p_meeting_entity.dart';

class P2pMeetingModel {
  final String id;
  final String? postId;
  final String? initiatorUserId;
  final String? peerUserId;
  final String peerName;
  final String? peerDesignation;
  final String? peerCompany;
  final String? peerLocation;
  final String? peerCategory;
  final String? peerPhotoUrl;
  final bool isPeerPro;
  final String? meetingDate;
  final String? meetingPlace;
  final String? remarks;
  final List<String> mediaUrls;
  final int? coinsEarned;
  final int? impactEarned;
  final String? createdAt;
  final String? updatedAt;
  final bool isInitiatedByMe;

  const P2pMeetingModel({
    required this.id,
    this.postId,
    this.initiatorUserId,
    this.peerUserId,
    required this.peerName,
    this.peerDesignation,
    this.peerCompany,
    this.peerLocation,
    this.peerCategory,
    this.peerPhotoUrl,
    this.isPeerPro = false,
    this.meetingDate,
    this.meetingPlace,
    this.remarks,
    this.mediaUrls = const [],
    this.coinsEarned,
    this.impactEarned,
    this.createdAt,
    this.updatedAt,
    this.isInitiatedByMe = false,
  });

  factory P2pMeetingModel.fromJson(
    Map<String, dynamic> json, {
    String? currentUserId,
  }) {
    int? parseInt(dynamic v) {
      if (v == null) return null;
      if (v is num) return v.toInt();
      return int.tryParse(v.toString());
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
          final url = m['url'] ?? m['file_url'] ?? m['path'] ?? (m['id'] != null ? '${AppEnvironment.baseUrl}/files/${m['id']}' : (m['file_id'] != null ? '${AppEnvironment.baseUrl}/files/${m['file_id']}' : null));
          addMediaUrl(url?.toString());
        } else if (m is String && m.isNotEmpty) {
          addMediaUrl(m);
        }
      }
    }

    if (json['media_file_id'] != null && json['media_file_id'].toString().isNotEmpty) {
      addMediaUrl('${AppEnvironment.baseUrl}/files/${json['media_file_id']}');
    }

    if (json['creative_url'] != null && json['creative_url'].toString().isNotEmpty) {
      addMediaUrl(json['creative_url'].toString());
    }

    if (json['creative_image_url'] != null && json['creative_image_url'].toString().isNotEmpty) {
      addMediaUrl(json['creative_image_url'].toString());
    }

    if (json['creative_file_id'] != null && json['creative_file_id'].toString().isNotEmpty) {
      addMediaUrl('${AppEnvironment.baseUrl}/files/${json['creative_file_id']}');
    }

    if (json['creative'] is Map) {
      final c = json['creative'] as Map;
      final url = c['url'] ?? c['file_url'] ?? (c['id'] != null ? '${AppEnvironment.baseUrl}/files/${c['id']}' : (c['creative_file_id'] != null ? '${AppEnvironment.baseUrl}/files/${c['creative_file_id']}' : null));
      addMediaUrl(url?.toString());
    }

    final initUserId = (json['initiator_user_id'] ??
            json['initiated_by_user_id'] ??
            json['from_user_id'] ??
            json['user_id'])
        ?.toString();
    final pUserId = (json['peer_user_id'] ??
            json['initiated_to_user_id'] ??
            json['to_user_id'])
        ?.toString();

    final isMe = currentUserId != null && initUserId == currentUserId;

    // Prioritize other_user map which is the direct peer in activities API
    final otherUser = json['other_user'] is Map ? json['other_user'] as Map<String, dynamic> : null;
    final peerMap = json['peer'] is Map ? json['peer'] as Map<String, dynamic> : null;
    final initiatedTo = json['initiated_to'] is Map ? json['initiated_to'] as Map<String, dynamic> : null;
    final givenTo = json['given_to'] is Map ? json['given_to'] as Map<String, dynamic> : null;
    final initiatedBy = json['initiated_by'] is Map ? json['initiated_by'] as Map<String, dynamic> : null;
    final givenBy = json['given_by'] is Map ? json['given_by'] as Map<String, dynamic> : null;
    final userMap = json['user'] is Map ? json['user'] as Map<String, dynamic> : null;

    final targetPeer = otherUser ?? peerMap ?? initiatedTo ?? givenTo ?? userMap ?? initiatedBy ?? givenBy;

    final resolvedPeerUserId = (targetPeer?['id'] ??
            pUserId ??
            (isMe ? (initiatedTo?['id'] ?? givenTo?['id']) : (initiatedBy?['id'] ?? givenBy?['id'])))
        ?.toString();

    var pName = (targetPeer?['name'] ??
            targetPeer?['display_name'] ??
            targetPeer?['full_name'] ??
            json['other_user_name'] ??
            json['peer_name'] ??
            json['peer_user_name'] ??
            '')
        .toString();

    if (pName.isEmpty) {
      if (isMe && initiatedTo != null) {
        pName = (initiatedTo['name'] ?? initiatedTo['display_name'] ?? '').toString();
      } else if (!isMe && initiatedBy != null) {
        pName = (initiatedBy['name'] ?? initiatedBy['display_name'] ?? '').toString();
      }
    }

    if (pName.isEmpty) pName = 'Peer Member';

    var pDesignation = (targetPeer?['designation'] ?? json['peer_designation'])?.toString();
    var pCompany = (targetPeer?['company_name'] ?? targetPeer?['company'] ?? json['peer_company'])?.toString();
    var pLocation = (targetPeer?['city'] ?? targetPeer?['location'] ?? json['peer_location'] ?? json['city'])?.toString();
    var pCategory = (targetPeer?['level4_category'] ??
            targetPeer?['category'] ??
            targetPeer?['business_sub_category'] ??
            targetPeer?['main_business_category'] ??
            json['peer_category'] ??
            json['category'])
        ?.toString();

    String? pPhoto = (targetPeer?['profile_photo_url'] ??
            targetPeer?['profile_photo'] ??
            targetPeer?['avatar_url'] ??
            targetPeer?['avatar'] ??
            targetPeer?['photo'] ??
            json['peer_photo_url'] ??
            json['other_user_profile_photo_url'])
        ?.toString();

    if (pPhoto != null && pPhoto.isNotEmpty) {
      pPhoto = resolveFileUrl(pPhoto);
    }

    var pIsPro = targetPeer?['is_pro'] == true ||
        targetPeer?['is_pro'] == 1 ||
        targetPeer?['is_pro'] == '1' ||
        json['is_peer_pro'] == true ||
        json['is_pro'] == true;

    int? coins;
    if (json['coins'] is Map) {
      coins = parseInt(json['coins']['earned'] ?? json['coins']['points']);
    } else {
      coins = parseInt(json['coins_earned'] ?? json['coins'] ?? json['coins_awarded']);
    }

    int? impact;
    if (json['life_impact'] is Map) {
      impact = parseInt(json['life_impact']['points_earned'] ?? json['life_impact']['points'] ?? json['life_impact']['impact']);
    } else {
      impact = parseInt(json['impact_earned'] ?? json['life_impact'] ?? json['impacts'] ?? json['life_impact_points']);
    }

    final pId = json['post_id']?.toString() ??
        (json['post'] is Map ? json['post']['id']?.toString() : null);

    return P2pMeetingModel(
      id: (json['id'] ?? json['activity_id'] ?? json['meeting_id'] ?? json['uuid'] ?? '').toString(),
      postId: pId,
      initiatorUserId: initUserId,
      peerUserId: resolvedPeerUserId,
      peerName: pName,
      peerDesignation: pDesignation,
      peerCompany: pCompany,
      peerLocation: pLocation,
      peerCategory: pCategory,
      peerPhotoUrl: pPhoto,
      isPeerPro: pIsPro,
      meetingDate: (json['meeting_date'] ?? json['date'])?.toString(),
      meetingPlace: (json['meeting_place'] ?? json['place'] ?? json['location'])?.toString(),
      remarks: (json['remarks'] ?? json['meeting_title'] ?? json['notes'] ?? json['description'])?.toString(),
      mediaUrls: mediaList,
      coinsEarned: coins,
      impactEarned: impact,
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
      isInitiatedByMe: json['is_initiated_by_me'] == true || isMe,
    );
  }

  P2pMeetingEntity toEntity() => P2pMeetingEntity(
        id: id,
        postId: postId,
        initiatorUserId: initiatorUserId,
        peerUserId: peerUserId,
        peerName: peerName,
        peerDesignation: peerDesignation,
        peerCompany: peerCompany,
        peerLocation: peerLocation,
        peerCategory: peerCategory,
        peerPhotoUrl: peerPhotoUrl,
        isPeerPro: isPeerPro,
        meetingDate: meetingDate,
        meetingPlace: meetingPlace,
        remarks: remarks,
        mediaUrls: mediaUrls,
        coinsEarned: coinsEarned,
        impactEarned: impactEarned,
        createdAt: createdAt,
        updatedAt: updatedAt,
        isInitiatedByMe: isInitiatedByMe,
      );
}
