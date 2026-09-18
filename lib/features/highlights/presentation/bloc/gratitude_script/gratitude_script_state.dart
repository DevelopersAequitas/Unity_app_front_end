import 'package:equatable/equatable.dart';
import '../../../domain/entities/gratitude_script_entity.dart';

enum GratitudeScriptStatus { initial, loading, success, failure }

class GratitudeScriptState extends Equatable {
  final GratitudeScriptStatus status;
  final GratitudeScriptEntity script;
  final bool isSaving;
  final String? errorMessage;
  final String? successMessage;

  const GratitudeScriptState({
    this.status = GratitudeScriptStatus.initial,
    this.script = const GratitudeScriptEntity(),
    this.isSaving = false,
    this.errorMessage,
    this.successMessage,
  });

  GratitudeScriptState copyWith({
    GratitudeScriptStatus? status,
    GratitudeScriptEntity? script,
    bool? isSaving,
    String? errorMessage,
    String? successMessage,
  }) {
    return GratitudeScriptState(
      status: status ?? this.status,
      script: script ?? this.script,
      isSaving: isSaving ?? this.isSaving,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }

  @override
  List<Object?> get props => [status, script, isSaving, errorMessage, successMessage];
}
