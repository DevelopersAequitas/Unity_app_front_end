import 'package:equatable/equatable.dart';
import '../../../domain/entities/certification_question_entity.dart';
import '../../../domain/entities/entrepreneur_certification_result_entity.dart';

enum EntrepreneurCertificationStatus {
  initial,
  loading,
  loaded,
  submitting,
  success,
  failure,
}

class EntrepreneurCertificationState extends Equatable {
  final EntrepreneurCertificationStatus status;
  final int selectedTab;
  final List<CertificationQuestionEntity> questions;
  final Map<String, String> answers;
  final int currentStep;
  final List<EntrepreneurCertificationResultEntity> submissions;
  final int submissionsPage;
  final int submissionsLastPage;
  final int submissionsTotal;
  final bool isLoadingSubmissions;
  final EntrepreneurCertificationResultEntity? latestApprovedCertificate;
  final EntrepreneurCertificationResultEntity? latestSubmission;
  final bool isRetaking;
  final EntrepreneurCertificationResultEntity? result;
  final String? errorMessage;

  const EntrepreneurCertificationState({
    this.status = EntrepreneurCertificationStatus.initial,
    this.selectedTab = 0,
    this.questions = const [],
    this.answers = const {},
    this.currentStep = 0,
    this.submissions = const [],
    this.submissionsPage = 1,
    this.submissionsLastPage = 1,
    this.submissionsTotal = 0,
    this.isLoadingSubmissions = false,
    this.latestApprovedCertificate,
    this.latestSubmission,
    this.isRetaking = false,
    this.result,
    this.errorMessage,
  });

  bool get hasApprovedCertificate => latestApprovedCertificate != null;

  bool get isUnderReview =>
      !hasApprovedCertificate &&
      latestSubmission != null &&
      (latestSubmission!.status.toLowerCase() == 'new' ||
          latestSubmission!.status.toLowerCase() == 'pending' ||
          latestSubmission!.status.toLowerCase() == 'under_review' ||
          latestSubmission!.status.toLowerCase() == 'in_review');

  bool get isRejected =>
      !hasApprovedCertificate &&
      latestSubmission != null &&
      (latestSubmission!.status.toLowerCase() == 'rejected' ||
          latestSubmission!.status.toLowerCase() == 'reject' ||
          latestSubmission!.status.toLowerCase() == 'failed' ||
          latestSubmission!.status.toLowerCase() == 'declined');

  bool get canTakeAssessment =>
      (!hasApprovedCertificate && !isUnderReview) || isRetaking;

  EntrepreneurCertificationState copyWith({
    EntrepreneurCertificationStatus? status,
    int? selectedTab,
    List<CertificationQuestionEntity>? questions,
    Map<String, String>? answers,
    int? currentStep,
    List<EntrepreneurCertificationResultEntity>? submissions,
    int? submissionsPage,
    int? submissionsLastPage,
    int? submissionsTotal,
    bool? isLoadingSubmissions,
    EntrepreneurCertificationResultEntity? latestApprovedCertificate,
    bool clearApprovedCertificate = false,
    EntrepreneurCertificationResultEntity? latestSubmission,
    bool clearLatestSubmission = false,
    bool? isRetaking,
    EntrepreneurCertificationResultEntity? result,
    String? errorMessage,
  }) {
    return EntrepreneurCertificationState(
      status: status ?? this.status,
      selectedTab: selectedTab ?? this.selectedTab,
      questions: questions ?? this.questions,
      answers: answers ?? this.answers,
      currentStep: currentStep ?? this.currentStep,
      submissions: submissions ?? this.submissions,
      submissionsPage: submissionsPage ?? this.submissionsPage,
      submissionsLastPage: submissionsLastPage ?? this.submissionsLastPage,
      submissionsTotal: submissionsTotal ?? this.submissionsTotal,
      isLoadingSubmissions: isLoadingSubmissions ?? this.isLoadingSubmissions,
      latestApprovedCertificate: clearApprovedCertificate
          ? null
          : (latestApprovedCertificate ?? this.latestApprovedCertificate),
      latestSubmission: clearLatestSubmission
          ? null
          : (latestSubmission ?? this.latestSubmission),
      isRetaking: isRetaking ?? this.isRetaking,
      result: result ?? this.result,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    selectedTab,
    questions,
    answers,
    currentStep,
    submissions,
    submissionsPage,
    submissionsLastPage,
    submissionsTotal,
    isLoadingSubmissions,
    latestApprovedCertificate,
    latestSubmission,
    isRetaking,
    result,
    errorMessage,
  ];
}
