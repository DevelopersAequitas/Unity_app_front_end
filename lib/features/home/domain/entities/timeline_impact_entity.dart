import 'package:equatable/equatable.dart';

class TimelineImpactEntity extends Equatable {
  final String action;
  final String? impactDate;
  final int lifeImpacted;
  final String? impactedPeerId;
  final String? impactedPeerDisplayName;
  final String? impactedPeerAvatarUrl;

  const TimelineImpactEntity({
    required this.action,
    this.impactDate,
    this.lifeImpacted = 1,
    this.impactedPeerId,
    this.impactedPeerDisplayName,
    this.impactedPeerAvatarUrl,
  });

  @override
  List<Object?> get props => [
    action,
    impactDate,
    lifeImpacted,
    impactedPeerId,
    impactedPeerDisplayName,
    impactedPeerAvatarUrl,
  ];
}
