import 'package:equatable/equatable.dart';
import '../../../peers/domain/entities/peer_entity.dart';

class AskMatchPeerEntity extends Equatable {
  final String id;
  final String name;
  final String businessType;
  final String location;
  final String typeLabel;
  final bool isTypeMatched;
  final String capitalLabel;
  final bool isCapitalMatched;
  final String stageLabel;
  final bool isStageMatched;
  final int matchScore;
  final String matchReason;
  final String matchStatus;
  final Map<String, dynamic> matchesMap;
  final PeerEntity peer;

  const AskMatchPeerEntity({
    required this.id,
    required this.name,
    this.businessType = '',
    this.location = '',
    this.typeLabel = 'Industry',
    this.isTypeMatched = true,
    this.capitalLabel = 'Capital',
    this.isCapitalMatched = true,
    this.stageLabel = 'Stage',
    this.isStageMatched = true,
    this.matchScore = 100,
    this.matchReason = '',
    this.matchStatus = 'suggested',
    this.matchesMap = const {},
    this.peer = const PeerEntity(id: '', displayName: ''),
  });

  @override
  List<Object?> get props => [
        id,
        name,
        businessType,
        location,
        typeLabel,
        isTypeMatched,
        capitalLabel,
        isCapitalMatched,
        stageLabel,
        isStageMatched,
        matchScore,
        matchReason,
        matchStatus,
        matchesMap,
        peer,
      ];
}
