import 'package:equatable/equatable.dart';

abstract class EntrepreneurCertificationEvent extends Equatable {
  const EntrepreneurCertificationEvent();

  @override
  List<Object?> get props => [];
}

class LoadEntrepreneurInitialDataEvent extends EntrepreneurCertificationEvent {
  const LoadEntrepreneurInitialDataEvent();
}

class LoadEntrepreneurQuestionsEvent extends EntrepreneurCertificationEvent {
  const LoadEntrepreneurQuestionsEvent();
}

class LoadEntrepreneurSubmissionsEvent extends EntrepreneurCertificationEvent {
  final int page;
  final bool isRefresh;

  const LoadEntrepreneurSubmissionsEvent({
    this.page = 1,
    this.isRefresh = false,
  });

  @override
  List<Object?> get props => [page, isRefresh];
}

class AnswerEntrepreneurQuestionEvent extends EntrepreneurCertificationEvent {
  final String field;
  final String answer;

  const AnswerEntrepreneurQuestionEvent({
    required this.field,
    required this.answer,
  });

  @override
  List<Object?> get props => [field, answer];
}

class SetEntrepreneurQuestionnaireStepEvent
    extends EntrepreneurCertificationEvent {
  final int step;

  const SetEntrepreneurQuestionnaireStepEvent(this.step);

  @override
  List<Object?> get props => [step];
}

class SelectEntrepreneurTabEvent extends EntrepreneurCertificationEvent {
  final int tabIndex;

  const SelectEntrepreneurTabEvent(this.tabIndex);

  @override
  List<Object?> get props => [tabIndex];
}

class RetakeEntrepreneurAssessmentEvent extends EntrepreneurCertificationEvent {
  const RetakeEntrepreneurAssessmentEvent();
}

class SubmitEntrepreneurCertificationEvent
    extends EntrepreneurCertificationEvent {
  final String fullName;
  final String businessName;
  final String email;
  final String contactNo;

  const SubmitEntrepreneurCertificationEvent({
    required this.fullName,
    required this.businessName,
    required this.email,
    required this.contactNo,
  });

  @override
  List<Object?> get props => [fullName, businessName, email, contactNo];
}
