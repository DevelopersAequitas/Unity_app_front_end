import 'package:equatable/equatable.dart';
import 'p2p_meeting_entity.dart';

class P2pMeetingUserSummaryEntity extends Equatable {
  final String userId;
  final int total;
  final int iInitiated;
  final int peerInitiated;
  final List<P2pMeetingEntity> items;

  const P2pMeetingUserSummaryEntity({
    required this.userId,
    this.total = 0,
    this.iInitiated = 0,
    this.peerInitiated = 0,
    this.items = const [],
  });

  @override
  List<Object?> get props => [
        userId,
        total,
        iInitiated,
        peerInitiated,
        items,
      ];
}
