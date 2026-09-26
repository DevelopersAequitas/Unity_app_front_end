import 'package:equatable/equatable.dart';

enum AskSubmissionStatus { initial, loading, success, error }

class AskSubmissionState extends Equatable {
  final AskSubmissionStatus status;
  final String? publishedAskId;
  final String? errorMessage;

  const AskSubmissionState({
    this.status = AskSubmissionStatus.initial,
    this.publishedAskId,
    this.errorMessage,
  });

  AskSubmissionState copyWith({
    AskSubmissionStatus? status,
    String? publishedAskId,
    String? errorMessage,
  }) {
    return AskSubmissionState(
      status: status ?? this.status,
      publishedAskId: publishedAskId ?? this.publishedAskId,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, publishedAskId, errorMessage];
}
