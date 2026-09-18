import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_entrepreneur_certification_questions_usecase.dart';
import '../../../domain/usecases/submit_entrepreneur_certification_usecase.dart';
import 'entrepreneur_certification_event.dart';
import 'entrepreneur_certification_state.dart';

class EntrepreneurCertificationBloc extends Bloc<EntrepreneurCertificationEvent, EntrepreneurCertificationState> {
  final GetEntrepreneurCertificationQuestionsUseCase getQuestionsUseCase;
  final SubmitEntrepreneurCertificationUseCase submitCertificationUseCase;

  EntrepreneurCertificationBloc({
    required this.getQuestionsUseCase,
    required this.submitCertificationUseCase,
  }) : super(const EntrepreneurCertificationState()) {
    on<LoadEntrepreneurQuestionsEvent>(_onLoadQuestions);
    on<AnswerEntrepreneurQuestionEvent>(_onAnswerQuestion);
    on<SubmitEntrepreneurCertificationEvent>(_onSubmitCertification);
  }

  Future<void> _onLoadQuestions(
    LoadEntrepreneurQuestionsEvent event,
    Emitter<EntrepreneurCertificationState> emit,
  ) async {
    emit(state.copyWith(status: EntrepreneurCertificationStatus.loading));
    try {
      final questions = await getQuestionsUseCase();
      emit(state.copyWith(
        status: EntrepreneurCertificationStatus.questionsLoaded,
        questions: questions,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: EntrepreneurCertificationStatus.failure,
        errorMessage: 'Failed to load entrepreneur questions',
      ));
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
      emit(state.copyWith(
        status: EntrepreneurCertificationStatus.success,
        result: result,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: EntrepreneurCertificationStatus.failure,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      ));
    }
  }
}
