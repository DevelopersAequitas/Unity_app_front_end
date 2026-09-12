import 'package:equatable/equatable.dart';

abstract class PeerRequestsEvent extends Equatable {
  const PeerRequestsEvent();

  @override
  List<Object?> get props => [];
}

class PeerRequestsFetchRequested extends PeerRequestsEvent {
  const PeerRequestsFetchRequested();
}

class PeerRequestsRefreshRequested extends PeerRequestsEvent {
  const PeerRequestsRefreshRequested();
}

class PeerRequestsTabChanged extends PeerRequestsEvent {
  final int tabIndex; // 0: Received, 1: Sent
  const PeerRequestsTabChanged(this.tabIndex);

  @override
  List<Object?> get props => [tabIndex];
}

class PeerRequestAcceptRequested extends PeerRequestsEvent {
  final String requestId;
  final String requesterId;

  const PeerRequestAcceptRequested({
    required this.requestId,
    required this.requesterId,
  });

  @override
  List<Object?> get props => [requestId, requesterId];
}

class PeerRequestDeclineRequested extends PeerRequestsEvent {
  final String requestId;
  final String memberId;

  const PeerRequestDeclineRequested({
    required this.requestId,
    required this.memberId,
  });

  @override
  List<Object?> get props => [requestId, memberId];
}

class PeerRequestCancelRequested extends PeerRequestsEvent {
  final String requestId;

  const PeerRequestCancelRequested(this.requestId);

  @override
  List<Object?> get props => [requestId];
}
