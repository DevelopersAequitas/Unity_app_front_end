import 'package:equatable/equatable.dart';
import '../../../domain/entities/vyapaar_jagat_story_status_entity.dart';

enum VyapaarJagatStatus { initial, loading, submitting, success, error }

class VyapaarJagatState extends Equatable {
  final VyapaarJagatStatus status;
  final VyapaarJagatStoryStatusEntity? storyStatus;
  final String? successMessage;
  final String? errorMessage;

  const VyapaarJagatState({
    this.status = VyapaarJagatStatus.initial,
    this.storyStatus,
    this.successMessage,
    this.errorMessage,
  });

  VyapaarJagatState copyWith({
    VyapaarJagatStatus? status,
    VyapaarJagatStoryStatusEntity? storyStatus,
    String? successMessage,
    String? errorMessage,
  }) {
    return VyapaarJagatState(
      status: status ?? this.status,
      storyStatus: storyStatus ?? this.storyStatus,
      successMessage: successMessage,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, storyStatus, successMessage, errorMessage];
}
