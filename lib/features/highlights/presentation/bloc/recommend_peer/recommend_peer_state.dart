import 'package:equatable/equatable.dart';

enum RecommendPeerStatus { initial, submitting, success, failure }

class RecommendPeerState extends Equatable {
  final RecommendPeerStatus status;
  final String? errorMessage;
  final String? successMessage;

  const RecommendPeerState({
    this.status = RecommendPeerStatus.initial,
    this.errorMessage,
    this.successMessage,
  });

  RecommendPeerState copyWith({
    RecommendPeerStatus? status,
    String? errorMessage,
    String? successMessage,
  }) {
    return RecommendPeerState(
      status: status ?? this.status,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, successMessage];
}
