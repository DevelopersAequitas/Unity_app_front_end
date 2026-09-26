import 'package:equatable/equatable.dart';
import '../../domain/entities/ask_flow_entity.dart';

enum AskFlowsStatus { initial, loading, success, error }

class AskFlowsState extends Equatable {
  final AskFlowsStatus status;
  final List<AskFlowEntity> flows;
  final String? errorMessage;

  const AskFlowsState({
    this.status = AskFlowsStatus.initial,
    this.flows = const [],
    this.errorMessage,
  });

  AskFlowsState copyWith({
    AskFlowsStatus? status,
    List<AskFlowEntity>? flows,
    String? errorMessage,
  }) {
    return AskFlowsState(
      status: status ?? this.status,
      flows: flows ?? this.flows,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, flows, errorMessage];
}
