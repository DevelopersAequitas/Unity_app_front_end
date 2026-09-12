import '../../domain/entities/match_peer_entity.dart';
import 'peer_model.dart';

class MatchPeerModel {
  final PeerModel peer;
  final int matchPercentage;
  final List<String> matchReasons;

  const MatchPeerModel({
    required this.peer,
    required this.matchPercentage,
    this.matchReasons = const [],
  });

  factory MatchPeerModel.fromJson(Map<String, dynamic> json) {
    int percentage = 85;
    final match = json['profile_match'] ?? json['match'];
    if (match is Map) {
      final rawScore = match['score'] ?? match['match_percentage'] ?? match['percentage'];
      if (rawScore is num) {
        percentage = rawScore.toInt();
      }
    } else if (json['match_percentage'] is num) {
      percentage = (json['match_percentage'] as num).toInt();
    }

    final List<String> reasons = [];
    if (match is Map && match['reasons'] is List) {
      reasons.addAll((match['reasons'] as List).map((e) => e.toString()));
    }

    return MatchPeerModel(
      peer: PeerModel.fromJson(json),
      matchPercentage: percentage,
      matchReasons: reasons,
    );
  }

  MatchPeerEntity toEntity() {
    final base = peer.toEntity();
    return MatchPeerEntity(
      id: base.id,
      displayName: base.displayName,
      firstName: base.firstName,
      lastName: base.lastName,
      profilePhotoUrl: base.profilePhotoUrl,
      companyName: base.companyName,
      city: base.city,
      designation: base.designation,
      category: base.category,
      lifeImpactedCount: base.lifeImpactedCount,
      isVerified: base.isVerified,
      isBookmarked: base.isBookmarked,
      isOnline: base.isOnline,
      connectionStatus: base.connectionStatus,
      matchPercentage: matchPercentage,
      matchReasons: matchReasons.isNotEmpty
          ? matchReasons
          : [
              if (base.category != null) 'Same Industry Focus: ${base.category}',
              if (base.city != null) 'Based in ${base.city}',
              'Potential Collaborative Synergies',
            ],
    );
  }
}
