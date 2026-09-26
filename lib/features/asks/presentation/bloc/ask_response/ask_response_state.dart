import 'package:equatable/equatable.dart';

enum AskResponseStatus { initial, loading, success, error }

class AskResponseState extends Equatable {
  final AskResponseStatus status;
  final String? errorMessage;

  const AskResponseState({
    this.status = AskResponseStatus.initial,
    this.errorMessage,
  });

  AskResponseState copyWith({
    AskResponseStatus? status,
    String? errorMessage,
  }) {
    return AskResponseState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage];
}
