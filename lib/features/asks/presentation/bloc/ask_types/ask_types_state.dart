import 'package:equatable/equatable.dart';
import '../../../domain/entities/ask_type_entity.dart';

enum AskTypesStatus { initial, loading, success, error }

class AskTypesState extends Equatable {
  final AskTypesStatus status;
  final List<AskTypeEntity> types;
  final String? errorMessage;

  const AskTypesState({
    this.status = AskTypesStatus.initial,
    this.types = const [],
    this.errorMessage,
  });

  AskTypesState copyWith({
    AskTypesStatus? status,
    List<AskTypeEntity>? types,
    String? errorMessage,
  }) {
    return AskTypesState(
      status: status ?? this.status,
      types: types ?? this.types,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, types, errorMessage];
}
