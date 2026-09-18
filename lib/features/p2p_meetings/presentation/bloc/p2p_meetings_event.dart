import 'package:equatable/equatable.dart';
import '../../domain/entities/reschedule_p2p_meeting_params.dart';

abstract class P2pMeetingsEvent extends Equatable {
  const P2pMeetingsEvent();

  @override
  List<Object?> get props => [];
}

class P2pMeetingsFetchRequested extends P2pMeetingsEvent {
  const P2pMeetingsFetchRequested();
}

class P2pMeetingsRefreshRequested extends P2pMeetingsEvent {
  const P2pMeetingsRefreshRequested();
}

class P2pMeetingsTopTabChanged extends P2pMeetingsEvent {
  final String topTab; // 'completed' or 'scheduled'
  const P2pMeetingsTopTabChanged(this.topTab);

  @override
  List<Object?> get props => [topTab];
}

class P2pMeetingsCompletedSubTabChanged extends P2pMeetingsEvent {
  final String subTab; // 'i_initiated' or 'peer_initiated'
  const P2pMeetingsCompletedSubTabChanged(this.subTab);

  @override
  List<Object?> get props => [subTab];
}

class P2pMeetingsScheduledSubTabChanged extends P2pMeetingsEvent {
  final String subTab; // 'received', 'sent', 'reschedules'
  const P2pMeetingsScheduledSubTabChanged(this.subTab);

  @override
  List<Object?> get props => [subTab];
}

class P2pMeetingsSearchChanged extends P2pMeetingsEvent {
  final String query;
  const P2pMeetingsSearchChanged(this.query);

  @override
  List<Object?> get props => [query];
}

class P2pMeetingAcceptRequested extends P2pMeetingsEvent {
  final String requestId;
  const P2pMeetingAcceptRequested(this.requestId);

  @override
  List<Object?> get props => [requestId];
}

class P2pMeetingRejectRequested extends P2pMeetingsEvent {
  final String requestId;
  const P2pMeetingRejectRequested(this.requestId);

  @override
  List<Object?> get props => [requestId];
}

class P2pMeetingCancelRequested extends P2pMeetingsEvent {
  final String requestId;
  const P2pMeetingCancelRequested(this.requestId);

  @override
  List<Object?> get props => [requestId];
}

class P2pMeetingRescheduleRequested extends P2pMeetingsEvent {
  final RescheduleP2pMeetingParams params;
  const P2pMeetingRescheduleRequested(this.params);

  @override
  List<Object?> get props => [params];
}

class P2pMeetingRescheduleApproved extends P2pMeetingsEvent {
  final String rescheduleRequestId;
  const P2pMeetingRescheduleApproved(this.rescheduleRequestId);

  @override
  List<Object?> get props => [rescheduleRequestId];
}

class P2pMeetingRescheduleRejected extends P2pMeetingsEvent {
  final String rescheduleRequestId;
  final String? reason;
  const P2pMeetingRescheduleRejected(this.rescheduleRequestId, {this.reason});

  @override
  List<Object?> get props => [rescheduleRequestId, reason];
}
