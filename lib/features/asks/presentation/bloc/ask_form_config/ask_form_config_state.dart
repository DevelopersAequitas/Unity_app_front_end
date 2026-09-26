import 'package:equatable/equatable.dart';
import '../../../domain/entities/ask_form_config_entity.dart';

enum AskFormConfigStatus { initial, loading, success, error }

class AskFormConfigState extends Equatable {
  final AskFormConfigStatus status;
  final AskFormConfigEntity config;
  final String? errorMessage;

  const AskFormConfigState({
    this.status = AskFormConfigStatus.initial,
    this.config = const AskFormConfigEntity(),
    this.errorMessage,
  });

  AskFormConfigState copyWith({
    AskFormConfigStatus? status,
    AskFormConfigEntity? config,
    String? errorMessage,
  }) {
    return AskFormConfigState(
      status: status ?? this.status,
      config: config ?? this.config,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, config, errorMessage];
}
