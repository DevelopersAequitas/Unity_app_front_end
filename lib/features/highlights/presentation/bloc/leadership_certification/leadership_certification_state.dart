import 'package:equatable/equatable.dart';
import '../../../domain/entities/certification_question_entity.dart';
import '../../../domain/entities/leadership_certification_result_entity.dart';

enum LeadershipCertificationStatus {
  initial,
  loading,
  loaded,
  submitting,
  success,
  failure,
}

class LeadershipCertificationState extends Equatable {
  final LeadershipCertificationStatus status;
  final int selectedTab;
  final List<CertificationQuestionEntity> questions;
  final Map<String, String> answers;
  final int currentStep;
  final List<LeadershipCertificationResultEntity> submissions;
  final int submissionsPage;
  final int submissionsLastPage;
  final int submissionsTotal;
  final bool isLoadingSubmissions;
  final LeadershipCertificationResultEntity? latestApprovedCertificate;
  final LeadershipCertificationResultEntity? latestSubmission;
  final bool isRetaking;
  final LeadershipCertificationResultEntity? result;
  final String? errorMessage;

  const LeadershipCertificationState({
    this.status = LeadershipCertificationStatus.initial,
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

  LeadershipCertificationState copyWith({
    LeadershipCertificationStatus? status,
    int? selectedTab,
    List<CertificationQuestionEntity>? questions,
    Map<String, String>? answers,
    int? currentStep,
    List<LeadershipCertificationResultEntity>? submissions,
    int? submissionsPage,
    int? submissionsLastPage,
    int? submissionsTotal,
    bool? isLoadingSubmissions,
    LeadershipCertificationResultEntity? latestApprovedCertificate,
    bool clearApprovedCertificate = false,
    LeadershipCertificationResultEntity? latestSubmission,
    bool clearLatestSubmission = false,
    bool? isRetaking,
    LeadershipCertificationResultEntity? result,
    String? errorMessage,
  }) {
    return LeadershipCertificationState(
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
