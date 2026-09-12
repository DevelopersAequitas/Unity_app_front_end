import 'peer_entity.dart';

class MatchPeerEntity extends PeerEntity {
  final int matchPercentage;
  final List<String> matchReasons;

  const MatchPeerEntity({
    required super.id,
    required super.displayName,
    super.firstName,
    super.lastName,
    super.profilePhotoUrl,
    super.companyName,
    super.city,
    super.designation,
    super.category,
    super.lifeImpactedCount,
    super.isVerified = false,
    super.isBookmarked = false,
    super.isOnline = false,
    super.connectionStatus = 'none',
    required this.matchPercentage,
    this.matchReasons = const [],
  });

  @override
  List<Object?> get props => [
        ...super.props,
        matchPercentage,
        matchReasons,
      ];
}
