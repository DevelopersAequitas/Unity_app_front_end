import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/leadership_certification_result_entity.dart';
import '../../../domain/usecases/get_leadership_certification_questions_usecase.dart';
import '../../../domain/usecases/get_leadership_certification_submissions_usecase.dart';
import '../../../domain/usecases/submit_leadership_certification_usecase.dart';
import 'leadership_certification_event.dart';
import 'leadership_certification_state.dart';

class LeadershipCertificationBloc
    extends Bloc<LeadershipCertificationEvent, LeadershipCertificationState> {
  final GetLeadershipCertificationQuestionsUseCase getQuestionsUseCase;
  final GetLeadershipCertificationSubmissionsUseCase getSubmissionsUseCase;
  final SubmitLeadershipCertificationUseCase submitCertificationUseCase;

  LeadershipCertificationBloc({
    required this.getQuestionsUseCase,
    required this.getSubmissionsUseCase,
    required this.submitCertificationUseCase,
  }) : super(const LeadershipCertificationState()) {
    on<LoadLeadershipInitialDataEvent>(_onLoadInitialData);
    on<LoadLeadershipQuestionsEvent>(_onLoadQuestions);
    on<LoadLeadershipSubmissionsEvent>(_onLoadSubmissions);
    on<AnswerLeadershipQuestionEvent>(_onAnswerQuestion);
    on<SetQuestionnaireStepEvent>(_onSetStep);
    on<SelectLeadershipTabEvent>(_onSelectTab);
    on<RetakeLeadershipAssessmentEvent>(_onRetakeAssessment);
    on<SubmitLeadershipCertificationEvent>(_onSubmitCertification);
  }

  Future<void> _onLoadInitialData(
    LoadLeadershipInitialDataEvent event,
    Emitter<LeadershipCertificationState> emit,
  ) async {
    emit(state.copyWith(status: LeadershipCertificationStatus.loading));
    try {
      final submissionsRes = await getSubmissionsUseCase(page: 1);
      LeadershipCertificationResultEntity? approved;
      LeadershipCertificationResultEntity? latest;

      if (submissionsRes.items.isNotEmpty) {
        latest = submissionsRes.items.first;
        for (final item in submissionsRes.items) {
          final s = item.status.toLowerCase();
          if ((s == 'approved' || s == 'passed' || s == 'success') &&
              item.certificateUrl != null &&
              item.certificateUrl!.isNotEmpty) {
            approved = item;
            break;
          }
        }
      }

      var questions = state.questions;
      final canTake = approved == null &&
          (latest == null ||
              (latest.status.toLowerCase() != 'new' &&
                  latest.status.toLowerCase() != 'pending' &&
                  latest.status.toLowerCase() != 'under_review' &&
                  latest.status.toLowerCase() != 'in_review'));

      if (canTake && questions.isEmpty) {
        questions = await getQuestionsUseCase();
      }

      emit(
        state.copyWith(
          status: LeadershipCertificationStatus.loaded,
          submissions: submissionsRes.items,
          submissionsPage: submissionsRes.currentPage,
          submissionsLastPage: submissionsRes.lastPage,
          submissionsTotal: submissionsRes.total,
          latestApprovedCertificate: approved,
          clearApprovedCertificate: approved == null,
          latestSubmission: latest,
          clearLatestSubmission: latest == null,
          questions: questions,
          answers: canTake ? const {} : state.answers,
          currentStep: canTake ? 0 : state.currentStep,
        ),
      );
    } catch (_) {
      try {
        final questions = await getQuestionsUseCase();
        emit(
          state.copyWith(
            status: LeadershipCertificationStatus.loaded,
            questions: questions,
            answers: const {},
            currentStep: 0,
          ),
        );
      } catch (e) {
        emit(
          state.copyWith(
            status: LeadershipCertificationStatus.failure,
            errorMessage: 'Failed to load leadership certification details.',
          ),
        );
      }
    }
  }

  Future<void> _onLoadQuestions(
    LoadLeadershipQuestionsEvent event,
    Emitter<LeadershipCertificationState> emit,
  ) async {
    if (state.questions.isNotEmpty) return;
    emit(state.copyWith(status: LeadershipCertificationStatus.loading));
    try {
      final questions = await getQuestionsUseCase();
      emit(
        state.copyWith(
          status: LeadershipCertificationStatus.loaded,
          questions: questions,
          answers: const {},
          currentStep: 0,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: LeadershipCertificationStatus.failure,
          errorMessage: 'Failed to load questions.',
        ),
      );
    }
  }

  Future<void> _onLoadSubmissions(
    LoadLeadershipSubmissionsEvent event,
    Emitter<LeadershipCertificationState> emit,
  ) async {
    emit(state.copyWith(isLoadingSubmissions: true));
    try {
      final response = await getSubmissionsUseCase(page: event.page);
      final List<LeadershipCertificationResultEntity> updatedItems =
          event.page == 1
              ? response.items
              : [...state.submissions, ...response.items];

      LeadershipCertificationResultEntity? latest;
      LeadershipCertificationResultEntity? approved;

      if (updatedItems.isNotEmpty) {
        latest = updatedItems.first;
        for (final item in updatedItems) {
          final s = item.status.toLowerCase();
          if ((s == 'approved' || s == 'passed' || s == 'success') &&
              item.certificateUrl != null &&
              item.certificateUrl!.isNotEmpty) {
            approved = item;
            break;
          }
        }
      }

      emit(
        state.copyWith(
          isLoadingSubmissions: false,
          submissions: updatedItems,
          submissionsPage: response.currentPage,
          submissionsLastPage: response.lastPage,
          submissionsTotal: response.total,
          latestApprovedCertificate: approved,
          clearApprovedCertificate: approved == null,
          latestSubmission: latest,
          clearLatestSubmission: latest == null,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoadingSubmissions: false));
    }
  }

  void _onAnswerQuestion(
    AnswerLeadershipQuestionEvent event,
    Emitter<LeadershipCertificationState> emit,
  ) {
    final updated = Map<String, String>.from(state.answers);
    updated[event.field] = event.answer;
    emit(state.copyWith(answers: updated));
  }

  void _onSetStep(
    SetQuestionnaireStepEvent event,
    Emitter<LeadershipCertificationState> emit,
  ) {
    if (event.step >= 0 && event.step < state.questions.length) {
      emit(state.copyWith(currentStep: event.step));
    }
  }

  void _onSelectTab(
    SelectLeadershipTabEvent event,
    Emitter<LeadershipCertificationState> emit,
  ) {
    emit(state.copyWith(selectedTab: event.tabIndex));
    if (event.tabIndex == 1) {
      add(const LoadLeadershipSubmissionsEvent(page: 1, isRefresh: true));
    }
  }

  Future<void> _onRetakeAssessment(
    RetakeLeadershipAssessmentEvent event,
    Emitter<LeadershipCertificationState> emit,
  ) async {
    emit(
      state.copyWith(
        isRetaking: true,
        answers: const {},
        currentStep: 0,
        selectedTab: 0,
      ),
    );
    if (state.questions.isEmpty) {
      add(const LoadLeadershipQuestionsEvent());
    }
  }

  Future<void> _onSubmitCertification(
    SubmitLeadershipCertificationEvent event,
    Emitter<LeadershipCertificationState> emit,
  ) async {
    emit(state.copyWith(status: LeadershipCertificationStatus.submitting));
    try {
      final result = await submitCertificationUseCase(
        fullName: event.fullName,
        businessName: event.businessName,
        email: event.email,
        contactNo: event.contactNo,
        answers: state.answers,
      );
      emit(
        state.copyWith(
          status: LeadershipCertificationStatus.success,
          result: result,
          latestSubmission: result,
          latestApprovedCertificate:
              result.status.toLowerCase() == 'approved' &&
                      result.certificateUrl != null
                  ? result
                  : state.latestApprovedCertificate,
          isRetaking: false,
          answers: const {},
          currentStep: 0,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: LeadershipCertificationStatus.failure,
          errorMessage: e.toString().replaceAll('Exception: ', ''),
        ),
      );
    }
  }
}
