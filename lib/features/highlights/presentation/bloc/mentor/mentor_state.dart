import 'package:equatable/equatable.dart';
import '../../../domain/entities/mentor_submission_entity.dart';

enum MentorStatus { initial, loading, submitting, success, error }

class MentorState extends Equatable {
  final MentorStatus status;
  final List<MentorSubmissionEntity> submissions;
  final String? successMessage;
  final String? errorMessage;

  const MentorState({
    this.status = MentorStatus.initial,
    this.submissions = const [],
    this.successMessage,
    this.errorMessage,
  });

  MentorState copyWith({
    MentorStatus? status,
    List<MentorSubmissionEntity>? submissions,
    String? successMessage,
    String? errorMessage,
  }) {
    return MentorState(
      status: status ?? this.status,
      submissions: submissions ?? this.submissions,
      successMessage: successMessage,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, submissions, successMessage, errorMessage];
}
