import 'package:equatable/equatable.dart';

abstract class LeadershipCertificationEvent extends Equatable {
  const LeadershipCertificationEvent();

  @override
  List<Object?> get props => [];
}

class LoadLeadershipInitialDataEvent extends LeadershipCertificationEvent {
  const LoadLeadershipInitialDataEvent();
}

class LoadLeadershipQuestionsEvent extends LeadershipCertificationEvent {
  const LoadLeadershipQuestionsEvent();
}

class LoadLeadershipSubmissionsEvent extends LeadershipCertificationEvent {
  final int page;
  final bool isRefresh;

  const LoadLeadershipSubmissionsEvent({this.page = 1, this.isRefresh = false});

  @override
  List<Object?> get props => [page, isRefresh];
}

class AnswerLeadershipQuestionEvent extends LeadershipCertificationEvent {
  final String field;
  final String answer;

  const AnswerLeadershipQuestionEvent({
    required this.field,
    required this.answer,
  });

  @override
  List<Object?> get props => [field, answer];
}

class SetQuestionnaireStepEvent extends LeadershipCertificationEvent {
  final int step;

  const SetQuestionnaireStepEvent(this.step);

  @override
  List<Object?> get props => [step];
}

class SelectLeadershipTabEvent extends LeadershipCertificationEvent {
  final int tabIndex;

  const SelectLeadershipTabEvent(this.tabIndex);

  @override
  List<Object?> get props => [tabIndex];
}

class RetakeLeadershipAssessmentEvent extends LeadershipCertificationEvent {
  const RetakeLeadershipAssessmentEvent();
}

class SubmitLeadershipCertificationEvent extends LeadershipCertificationEvent {
  final String fullName;
  final String businessName;
  final String email;
  final String contactNo;

  const SubmitLeadershipCertificationEvent({
    required this.fullName,
    required this.businessName,
    required this.email,
    required this.contactNo,
  });

  @override
  List<Object?> get props => [fullName, businessName, email, contactNo];
}
