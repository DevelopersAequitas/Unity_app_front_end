import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/entrepreneur_certification_result_entity.dart';
import '../../../domain/usecases/get_entrepreneur_certification_questions_usecase.dart';
import '../../../domain/usecases/get_entrepreneur_certification_submissions_usecase.dart';
import '../../../domain/usecases/submit_entrepreneur_certification_usecase.dart';
import 'entrepreneur_certification_event.dart';
import 'entrepreneur_certification_state.dart';

class EntrepreneurCertificationBloc
    extends
        Bloc<EntrepreneurCertificationEvent, EntrepreneurCertificationState> {
  final GetEntrepreneurCertificationQuestionsUseCase getQuestionsUseCase;
  final GetEntrepreneurCertificationSubmissionsUseCase getSubmissionsUseCase;
  final SubmitEntrepreneurCertificationUseCase submitCertificationUseCase;

  EntrepreneurCertificationBloc({
    required this.getQuestionsUseCase,
    required this.getSubmissionsUseCase,
    required this.submitCertificationUseCase,
  }) : super(const EntrepreneurCertificationState()) {
    on<LoadEntrepreneurInitialDataEvent>(_onLoadInitialData);
    on<LoadEntrepreneurQuestionsEvent>(_onLoadQuestions);
    on<LoadEntrepreneurSubmissionsEvent>(_onLoadSubmissions);
    on<AnswerEntrepreneurQuestionEvent>(_onAnswerQuestion);
    on<SetEntrepreneurQuestionnaireStepEvent>(_onSetStep);
    on<SelectEntrepreneurTabEvent>(_onSelectTab);
    on<RetakeEntrepreneurAssessmentEvent>(_onRetakeAssessment);
    on<SubmitEntrepreneurCertificationEvent>(_onSubmitCertification);
  }

  Future<void> _onLoadInitialData(
    LoadEntrepreneurInitialDataEvent event,
    Emitter<EntrepreneurCertificationState> emit,
  ) async {
    emit(state.copyWith(status: EntrepreneurCertificationStatus.loading));
    try {
      final submissionsRes = await getSubmissionsUseCase(page: 1);
      EntrepreneurCertificationResultEntity? approved;
      EntrepreneurCertificationResultEntity? latest;

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
          status: EntrepreneurCertificationStatus.loaded,
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
            status: EntrepreneurCertificationStatus.loaded,
            questions: questions,
            answers: const {},
            currentStep: 0,
          ),
        );
      } catch (e) {
        emit(
          state.copyWith(
            status: EntrepreneurCertificationStatus.failure,
            errorMessage: 'Failed to load entrepreneur certification details.',
          ),
        );
      }
    }
  }

  Future<void> _onLoadQuestions(
    LoadEntrepreneurQuestionsEvent event,
    Emitter<EntrepreneurCertificationState> emit,
  ) async {
    if (state.questions.isNotEmpty) return;
    emit(state.copyWith(status: EntrepreneurCertificationStatus.loading));
    try {
      final questions = await getQuestionsUseCase();
      emit(
        state.copyWith(
          status: EntrepreneurCertificationStatus.loaded,
          questions: questions,
          answers: const {},
          currentStep: 0,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: EntrepreneurCertificationStatus.failure,
          errorMessage: 'Failed to load questions.',
        ),
      );
    }
  }

  Future<void> _onLoadSubmissions(
    LoadEntrepreneurSubmissionsEvent event,
    Emitter<EntrepreneurCertificationState> emit,
  ) async {
    emit(state.copyWith(isLoadingSubmissions: true));
    try {
      final response = await getSubmissionsUseCase(page: event.page);
      final List<EntrepreneurCertificationResultEntity> updatedItems =
          event.page == 1
              ? response.items
              : [...state.submissions, ...response.items];

      EntrepreneurCertificationResultEntity? latest;
      EntrepreneurCertificationResultEntity? approved;

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
    AnswerEntrepreneurQuestionEvent event,
    Emitter<EntrepreneurCertificationState> emit,
  ) {
    final updated = Map<String, String>.from(state.answers);
    updated[event.field] = event.answer;
    emit(state.copyWith(answers: updated));
  }

  void _onSetStep(
    SetEntrepreneurQuestionnaireStepEvent event,
    Emitter<EntrepreneurCertificationState> emit,
  ) {
    if (event.step >= 0 && event.step < state.questions.length) {
      emit(state.copyWith(currentStep: event.step));
    }
  }

  void _onSelectTab(
    SelectEntrepreneurTabEvent event,
    Emitter<EntrepreneurCertificationState> emit,
  ) {
    emit(state.copyWith(selectedTab: event.tabIndex));
    if (event.tabIndex == 1) {
      add(const LoadEntrepreneurSubmissionsEvent(page: 1, isRefresh: true));
    }
  }

  Future<void> _onRetakeAssessment(
    RetakeEntrepreneurAssessmentEvent event,
    Emitter<EntrepreneurCertificationState> emit,
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
      add(const LoadEntrepreneurQuestionsEvent());
    }
  }

  Future<void> _onSubmitCertification(
    SubmitEntrepreneurCertificationEvent event,
    Emitter<EntrepreneurCertificationState> emit,
  ) async {
    emit(state.copyWith(status: EntrepreneurCertificationStatus.submitting));
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
          status: EntrepreneurCertificationStatus.success,
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
          status: EntrepreneurCertificationStatus.failure,
          errorMessage: e.toString().replaceAll('Exception: ', ''),
        ),
      );
    }
  }
}
