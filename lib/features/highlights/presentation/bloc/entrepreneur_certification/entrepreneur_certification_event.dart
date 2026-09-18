import 'package:equatable/equatable.dart';

abstract class EntrepreneurCertificationEvent extends Equatable {
  const EntrepreneurCertificationEvent();

  @override
  List<Object?> get props => [];
}

class LoadEntrepreneurQuestionsEvent extends EntrepreneurCertificationEvent {
  const LoadEntrepreneurQuestionsEvent();
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

class SubmitEntrepreneurCertificationEvent extends EntrepreneurCertificationEvent {
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
