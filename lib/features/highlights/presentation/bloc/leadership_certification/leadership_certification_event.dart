import 'package:equatable/equatable.dart';

abstract class LeadershipCertificationEvent extends Equatable {
  const LeadershipCertificationEvent();

  @override
  List<Object?> get props => [];
}

class LoadLeadershipQuestionsEvent extends LeadershipCertificationEvent {
  const LoadLeadershipQuestionsEvent();
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
