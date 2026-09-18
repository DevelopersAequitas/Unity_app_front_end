import 'package:equatable/equatable.dart';
import '../../../peers/domain/entities/peer_entity.dart';
import '../../domain/entities/p2p_meeting_request_entity.dart';

enum ScheduleP2pMeetingStatus { initial, submitting, success, failure }

class ScheduleP2pMeetingState extends Equatable {
  final ScheduleP2pMeetingStatus status;
  final PeerEntity? selectedPeer;
  final String scheduledAt; // YYYY-MM-DD HH:mm:ss
  final String place;
  final String message;
  final P2pMeetingRequestEntity? createdRequest;
  final String? errorMessage;

  const ScheduleP2pMeetingState({
    this.status = ScheduleP2pMeetingStatus.initial,
    this.selectedPeer,
    this.scheduledAt = '',
    this.place = '',
    this.message = '',
    this.createdRequest,
    this.errorMessage,
  });

  bool get isValid =>
      selectedPeer != null &&
      scheduledAt.trim().isNotEmpty &&
      place.trim().isNotEmpty;

  ScheduleP2pMeetingState copyWith({
    ScheduleP2pMeetingStatus? status,
    PeerEntity? selectedPeer,
    String? scheduledAt,
    String? place,
    String? message,
    P2pMeetingRequestEntity? createdRequest,
    String? errorMessage,
  }) {
    return ScheduleP2pMeetingState(
      status: status ?? this.status,
      selectedPeer: selectedPeer ?? this.selectedPeer,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      place: place ?? this.place,
      message: message ?? this.message,
      createdRequest: createdRequest ?? this.createdRequest,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        selectedPeer,
        scheduledAt,
        place,
        message,
        createdRequest,
        errorMessage,
      ];
}
