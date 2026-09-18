import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_mentor_submissions_usecase.dart';
import '../../../domain/usecases/submit_mentor_application_usecase.dart';
import 'mentor_event.dart';
import 'mentor_state.dart';

class MentorBloc extends Bloc<MentorEvent, MentorState> {
  final SubmitMentorApplicationUseCase submitMentorApplicationUseCase;
  final GetMentorSubmissionsUseCase getMentorSubmissionsUseCase;

  MentorBloc({
    required this.submitMentorApplicationUseCase,
    required this.getMentorSubmissionsUseCase,
  }) : super(const MentorState()) {
    on<FetchMentorHistoryEvent>(_onFetchHistory);
    on<SubmitMentorApplicationEvent>(_onSubmitApplication);
    on<ResetMentorStateEvent>(_onResetState);
  }

  Future<void> _onFetchHistory(
    FetchMentorHistoryEvent event,
    Emitter<MentorState> emit,
  ) async {
    emit(state.copyWith(status: MentorStatus.loading));
    try {
      final list = await getMentorSubmissionsUseCase();
      emit(state.copyWith(
        status: MentorStatus.success,
        submissions: list,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: MentorStatus.error,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      ));
    }
  }

  Future<void> _onSubmitApplication(
    SubmitMentorApplicationEvent event,
    Emitter<MentorState> emit,
  ) async {
    emit(state.copyWith(status: MentorStatus.submitting));
    try {
      final msg = await submitMentorApplicationUseCase(event.entity);
      emit(state.copyWith(
        status: MentorStatus.success,
        successMessage: msg,
      ));
      add(const FetchMentorHistoryEvent());
    } catch (e) {
      emit(state.copyWith(
        status: MentorStatus.error,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      ));
    }
  }

  void _onResetState(
    ResetMentorStateEvent event,
    Emitter<MentorState> emit,
  ) {
    emit(state.copyWith(
      status: MentorStatus.initial,
      errorMessage: null,
      successMessage: null,
    ));
  }
}
