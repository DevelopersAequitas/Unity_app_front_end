import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_leadership_certification_questions_usecase.dart';
import '../../../domain/usecases/submit_leadership_certification_usecase.dart';
import 'leadership_certification_event.dart';
import 'leadership_certification_state.dart';

class LeadershipCertificationBloc extends Bloc<LeadershipCertificationEvent, LeadershipCertificationState> {
  final GetLeadershipCertificationQuestionsUseCase getQuestionsUseCase;
  final SubmitLeadershipCertificationUseCase submitCertificationUseCase;

  LeadershipCertificationBloc({
    required this.getQuestionsUseCase,
    required this.submitCertificationUseCase,
  }) : super(const LeadershipCertificationState()) {
    on<LoadLeadershipQuestionsEvent>(_onLoadQuestions);
    on<AnswerLeadershipQuestionEvent>(_onAnswerQuestion);
    on<SubmitLeadershipCertificationEvent>(_onSubmitCertification);
  }

  Future<void> _onLoadQuestions(
    LoadLeadershipQuestionsEvent event,
    Emitter<LeadershipCertificationState> emit,
  ) async {
    emit(state.copyWith(status: LeadershipCertificationStatus.loading));
    try {
      final questions = await getQuestionsUseCase();
      emit(state.copyWith(
        status: LeadershipCertificationStatus.questionsLoaded,
        questions: questions,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: LeadershipCertificationStatus.failure,
        errorMessage: 'Failed to load leadership questions',
      ));
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
      emit(state.copyWith(
        status: LeadershipCertificationStatus.success,
        result: result,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: LeadershipCertificationStatus.failure,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      ));
    }
  }
}
