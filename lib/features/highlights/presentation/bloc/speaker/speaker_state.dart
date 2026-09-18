import 'package:equatable/equatable.dart';
import '../../../domain/entities/speaker_submission_entity.dart';

enum SpeakerStatus { initial, loading, submitting, success, error }

class SpeakerState extends Equatable {
  final SpeakerStatus status;
  final List<SpeakerSubmissionEntity> submissions;
  final String? successMessage;
  final String? errorMessage;

  const SpeakerState({
    this.status = SpeakerStatus.initial,
    this.submissions = const [],
    this.successMessage,
    this.errorMessage,
  });

  SpeakerState copyWith({
    SpeakerStatus? status,
    List<SpeakerSubmissionEntity>? submissions,
    String? successMessage,
    String? errorMessage,
  }) {
    return SpeakerState(
      status: status ?? this.status,
      submissions: submissions ?? this.submissions,
      successMessage: successMessage,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, submissions, successMessage, errorMessage];
}
