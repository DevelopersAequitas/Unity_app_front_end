import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_gratitude_script_usecase.dart';
import '../../../domain/usecases/save_gratitude_script_usecase.dart';
import 'gratitude_script_event.dart';
import 'gratitude_script_state.dart';

class GratitudeScriptBloc extends Bloc<GratitudeScriptEvent, GratitudeScriptState> {
  final GetGratitudeScriptUseCase getGratitudeScriptUseCase;
  final SaveGratitudeScriptUseCase saveGratitudeScriptUseCase;

  GratitudeScriptBloc({
    required this.getGratitudeScriptUseCase,
    required this.saveGratitudeScriptUseCase,
  }) : super(const GratitudeScriptState()) {
    on<FetchGratitudeScriptEvent>(_onFetch);
    on<SaveGratitudeScriptEvent>(_onSave);
  }

  Future<void> _onFetch(
    FetchGratitudeScriptEvent event,
    Emitter<GratitudeScriptState> emit,
  ) async {
    if (!event.isRefresh && state.status == GratitudeScriptStatus.initial) {
      emit(state.copyWith(status: GratitudeScriptStatus.loading));
    }
    try {
      final script = await getGratitudeScriptUseCase();
      emit(state.copyWith(
        status: GratitudeScriptStatus.success,
        script: script,
        errorMessage: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: GratitudeScriptStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onSave(
    SaveGratitudeScriptEvent event,
    Emitter<GratitudeScriptState> emit,
  ) async {
    emit(state.copyWith(isSaving: true, errorMessage: null, successMessage: null));
    try {
      final updated = await saveGratitudeScriptUseCase(
        progressWord: event.progressWord,
        nextMonthGoal: event.nextMonthGoal,
        experienceStory: event.experienceStory,
      );
      emit(state.copyWith(
        isSaving: false,
        script: updated,
        successMessage: 'Impact script updated successfully!',
      ));
    } catch (e) {
      emit(state.copyWith(
        isSaving: false,
        errorMessage: e.toString(),
      ));
    }
  }
}
