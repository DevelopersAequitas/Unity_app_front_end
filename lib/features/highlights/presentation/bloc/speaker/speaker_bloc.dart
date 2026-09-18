import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_speaker_submissions_usecase.dart';
import '../../../domain/usecases/submit_speaker_application_usecase.dart';
import 'speaker_event.dart';
import 'speaker_state.dart';

class SpeakerBloc extends Bloc<SpeakerEvent, SpeakerState> {
  final SubmitSpeakerApplicationUseCase submitSpeakerApplicationUseCase;
  final GetSpeakerSubmissionsUseCase getSpeakerSubmissionsUseCase;

  SpeakerBloc({
    required this.submitSpeakerApplicationUseCase,
    required this.getSpeakerSubmissionsUseCase,
  }) : super(const SpeakerState()) {
    on<FetchSpeakerHistoryEvent>(_onFetchHistory);
    on<SubmitSpeakerApplicationEvent>(_onSubmitApplication);
    on<ResetSpeakerStateEvent>(_onResetState);
  }

  Future<void> _onFetchHistory(
    FetchSpeakerHistoryEvent event,
    Emitter<SpeakerState> emit,
  ) async {
    emit(state.copyWith(status: SpeakerStatus.loading));
    try {
      final list = await getSpeakerSubmissionsUseCase();
      emit(state.copyWith(
        status: SpeakerStatus.success,
        submissions: list,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: SpeakerStatus.error,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      ));
    }
  }

  Future<void> _onSubmitApplication(
    SubmitSpeakerApplicationEvent event,
    Emitter<SpeakerState> emit,
  ) async {
    emit(state.copyWith(status: SpeakerStatus.submitting));
    try {
      final msg = await submitSpeakerApplicationUseCase(
        entity: event.entity,
        imageFile: event.imageFile,
      );
      emit(state.copyWith(
        status: SpeakerStatus.success,
        successMessage: msg,
      ));
      add(const FetchSpeakerHistoryEvent());
    } catch (e) {
      emit(state.copyWith(
        status: SpeakerStatus.error,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      ));
    }
  }

  void _onResetState(
    ResetSpeakerStateEvent event,
    Emitter<SpeakerState> emit,
  ) {
    emit(state.copyWith(
      status: SpeakerStatus.initial,
      errorMessage: null,
      successMessage: null,
    ));
  }
}
