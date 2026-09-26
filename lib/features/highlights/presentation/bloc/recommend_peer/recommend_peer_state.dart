import 'package:equatable/equatable.dart';
import '../../../domain/entities/peer_recommendation_entity.dart';

enum RecommendPeerStatus { initial, submitting, success, failure }
enum RecommendPeerHistoryStatus { initial, loading, success, failure }

class RecommendPeerState extends Equatable {
  final RecommendPeerStatus status;
  final RecommendPeerHistoryStatus historyStatus;
  final List<PeerRecommendationEntity> history;
  final String? errorMessage;
  final String? successMessage;
  final String? historyErrorMessage;

  const RecommendPeerState({
    this.status = RecommendPeerStatus.initial,
    this.historyStatus = RecommendPeerHistoryStatus.initial,
    this.history = const [],
    this.errorMessage,
    this.successMessage,
    this.historyErrorMessage,
  });

  RecommendPeerState copyWith({
    RecommendPeerStatus? status,
    RecommendPeerHistoryStatus? historyStatus,
    List<PeerRecommendationEntity>? history,
    String? errorMessage,
    String? successMessage,
    String? historyErrorMessage,
  }) {
    return RecommendPeerState(
      status: status ?? this.status,
      historyStatus: historyStatus ?? this.historyStatus,
      history: history ?? this.history,
      errorMessage: errorMessage,
      successMessage: successMessage,
      historyErrorMessage: historyErrorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        historyStatus,
        history,
        errorMessage,
        successMessage,
        historyErrorMessage,
      ];
}
