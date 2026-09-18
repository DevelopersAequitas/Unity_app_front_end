import 'package:equatable/equatable.dart';
import '../../../domain/entities/certification_question_entity.dart';
import '../../../domain/entities/leadership_certification_result_entity.dart';

enum LeadershipCertificationStatus { initial, loading, questionsLoaded, submitting, success, failure }

class LeadershipCertificationState extends Equatable {
  final LeadershipCertificationStatus status;
  final List<CertificationQuestionEntity> questions;
  final Map<String, String> answers;
  final LeadershipCertificationResultEntity? result;
  final String? errorMessage;
  final bool isEligible;
  final String? ineligibilityReason;

  const LeadershipCertificationState({
    this.status = LeadershipCertificationStatus.initial,
    this.questions = const [],
    this.answers = const {},
    this.result,
    this.errorMessage,
    this.isEligible = true,
    this.ineligibilityReason,
  });

  LeadershipCertificationState copyWith({
    LeadershipCertificationStatus? status,
    List<CertificationQuestionEntity>? questions,
    Map<String, String>? answers,
    LeadershipCertificationResultEntity? result,
    String? errorMessage,
    bool? isEligible,
    String? ineligibilityReason,
  }) {
    return LeadershipCertificationState(
      status: status ?? this.status,
      questions: questions ?? this.questions,
      answers: answers ?? this.answers,
      result: result ?? this.result,
      errorMessage: errorMessage,
      isEligible: isEligible ?? this.isEligible,
      ineligibilityReason: ineligibilityReason ?? this.ineligibilityReason,
    );
  }

  @override
  List<Object?> get props => [status, questions, answers, result, errorMessage, isEligible, ineligibilityReason];
}
