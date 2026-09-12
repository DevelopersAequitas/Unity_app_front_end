import '../../domain/entities/timeline_impact_entity.dart';

class TimelineImpactModel {
  final String action;
  final String? impactDate;
  final int lifeImpacted;
  final String? impactedPeerId;
  final String? impactedPeerDisplayName;
  final String? impactedPeerAvatarUrl;

  const TimelineImpactModel({
    required this.action,
    this.impactDate,
    this.lifeImpacted = 1,
    this.impactedPeerId,
    this.impactedPeerDisplayName,
    this.impactedPeerAvatarUrl,
  });

  factory TimelineImpactModel.fromJson(Map<String, dynamic> json) {
    final peer = json['impacted_peer'] as Map<String, dynamic>?;
    String? peerName;
    if (peer != null) {
      final first = peer['first_name'] as String?;
      final last = peer['last_name'] as String?;
      peerName = peer['display_name'] as String? ??
          ('${first ?? ''} ${last ?? ''}'.trim().isNotEmpty
              ? '${first ?? ''} ${last ?? ''}'.trim()
              : null);
    }

    final rawImpact = json['life_impacted'] ?? json['lives_impacted'];
    final impactVal = rawImpact is int
        ? rawImpact
        : int.tryParse(rawImpact?.toString() ?? '1') ?? 1;

    return TimelineImpactModel(
      action: (json['action'] ?? json['story_to_share'] ?? 'Created an Impact').toString(),
      impactDate: json['impact_date']?.toString(),
      lifeImpacted: impactVal,
      impactedPeerId: peer?['id']?.toString(),
      impactedPeerDisplayName: peerName,
      impactedPeerAvatarUrl: (peer?['profile_photo_url'] ?? peer?['avatar_url']) as String?,
    );
  }

  TimelineImpactEntity toEntity() {
    return TimelineImpactEntity(
      action: action,
      impactDate: impactDate,
      lifeImpacted: lifeImpacted,
      impactedPeerId: impactedPeerId,
      impactedPeerDisplayName: impactedPeerDisplayName,
      impactedPeerAvatarUrl: impactedPeerAvatarUrl,
    );
  }
}
