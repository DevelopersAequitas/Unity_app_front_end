import 'package:equatable/equatable.dart';
import '../../../domain/entities/certification_question_entity.dart';
import '../../../domain/entities/entrepreneur_certification_result_entity.dart';

enum EntrepreneurCertificationStatus { initial, loading, questionsLoaded, submitting, success, failure }

class EntrepreneurCertificationState extends Equatable {
  final EntrepreneurCertificationStatus status;
  final List<CertificationQuestionEntity> questions;
  final Map<String, String> answers;
  final EntrepreneurCertificationResultEntity? result;
  final String? errorMessage;
  final bool isEligible;
  final String? ineligibilityReason;

  const EntrepreneurCertificationState({
    this.status = EntrepreneurCertificationStatus.initial,
    this.questions = const [],
    this.answers = const {},
    this.result,
    this.errorMessage,
    this.isEligible = true,
    this.ineligibilityReason,
  });

  EntrepreneurCertificationState copyWith({
    EntrepreneurCertificationStatus? status,
    List<CertificationQuestionEntity>? questions,
    Map<String, String>? answers,
    EntrepreneurCertificationResultEntity? result,
    String? errorMessage,
    bool? isEligible,
    String? ineligibilityReason,
  }) {
    return EntrepreneurCertificationState(
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
