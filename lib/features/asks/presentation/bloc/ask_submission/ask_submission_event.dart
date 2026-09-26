import 'package:equatable/equatable.dart';
import '../../../domain/entities/ask_submission_entity.dart';

abstract class AskSubmissionEvent extends Equatable {
  const AskSubmissionEvent();

  @override
  List<Object?> get props => [];
}

class AskPublishRequested extends AskSubmissionEvent {
  final AskSubmissionEntity submission;

  const AskPublishRequested(this.submission);

  @override
  List<Object?> get props => [submission];
}
