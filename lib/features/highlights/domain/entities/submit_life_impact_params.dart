class SubmitLifeImpactParams {
  final String impactedPeerId;
  final String action;
  final String date;
  final int lifeImpacted;
  final String storyToShare;
  final String additionalRemarks;

  const SubmitLifeImpactParams({
    required this.impactedPeerId,
    required this.action,
    required this.date,
    this.lifeImpacted = 1,
    this.storyToShare = '',
    this.additionalRemarks = '',
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'impacted_peer_id': impactedPeerId,
      'action': action,
      'date': date,
      'life_impacted': lifeImpacted,
    };
    if (storyToShare.isNotEmpty) map['story_to_share'] = storyToShare;
    if (additionalRemarks.isNotEmpty) {
      map['additional_remarks'] = additionalRemarks;
    }
    return map;
  }
}
