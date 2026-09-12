import 'package:equatable/equatable.dart';
import '../../domain/entities/peer_request_entity.dart';

enum PeerRequestsStatus { initial, loading, success, failure }

class PeerRequestsState extends Equatable {
  final PeerRequestsStatus status;
  final int activeTab; // 0 = Received, 1 = Sent
  final List<PeerRequestEntity> receivedRequests;
  final List<PeerRequestEntity> sentRequests;
  final String? errorMessage;

  const PeerRequestsState({
    this.status = PeerRequestsStatus.initial,
    this.activeTab = 0,
    this.receivedRequests = const [],
    this.sentRequests = const [],
    this.errorMessage,
  });

  PeerRequestsState copyWith({
    PeerRequestsStatus? status,
    int? activeTab,
    List<PeerRequestEntity>? receivedRequests,
    List<PeerRequestEntity>? sentRequests,
    String? errorMessage,
  }) {
    return PeerRequestsState(
      status: status ?? this.status,
      activeTab: activeTab ?? this.activeTab,
      receivedRequests: receivedRequests ?? this.receivedRequests,
      sentRequests: sentRequests ?? this.sentRequests,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        activeTab,
        receivedRequests,
        sentRequests,
        errorMessage,
      ];
}
