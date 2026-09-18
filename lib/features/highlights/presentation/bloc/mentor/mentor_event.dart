import 'package:equatable/equatable.dart';
import '../../../domain/entities/mentor_submission_entity.dart';

abstract class MentorEvent extends Equatable {
  const MentorEvent();

  @override
  List<Object?> get props => [];
}

class FetchMentorHistoryEvent extends MentorEvent {
  const FetchMentorHistoryEvent();
}

class SubmitMentorApplicationEvent extends MentorEvent {
  final MentorSubmissionEntity entity;

  const SubmitMentorApplicationEvent(this.entity);

  @override
  List<Object?> get props => [entity];
}

class ResetMentorStateEvent extends MentorEvent {
  const ResetMentorStateEvent();
}
