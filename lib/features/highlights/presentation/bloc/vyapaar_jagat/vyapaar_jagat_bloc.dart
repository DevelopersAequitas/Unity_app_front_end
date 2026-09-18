import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_vyapaar_jagat_story_status_usecase.dart';
import '../../../domain/usecases/submit_vyapaar_jagat_story_usecase.dart';
import 'vyapaar_jagat_event.dart';
import 'vyapaar_jagat_state.dart';

class VyapaarJagatBloc extends Bloc<VyapaarJagatEvent, VyapaarJagatState> {
  final SubmitVyapaarJagatStoryUseCase submitStoryUseCase;
  final GetVyapaarJagatStoryStatusUseCase getStoryStatusUseCase;

  VyapaarJagatBloc({
    required this.submitStoryUseCase,
    required this.getStoryStatusUseCase,
  }) : super(const VyapaarJagatState()) {
    on<FetchStoryStatusEvent>(_onFetchStatus);
    on<SubmitStoryEvent>(_onSubmitStory);
    on<ResetVyapaarJagatStateEvent>(_onResetState);
  }

  Future<void> _onFetchStatus(
    FetchStoryStatusEvent event,
    Emitter<VyapaarJagatState> emit,
  ) async {
    emit(state.copyWith(status: VyapaarJagatStatus.loading));
    try {
      final status = await getStoryStatusUseCase();
      emit(state.copyWith(
        status: VyapaarJagatStatus.initial,
        storyStatus: status,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: VyapaarJagatStatus.error,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      ));
    }
  }

  Future<void> _onSubmitStory(
    SubmitStoryEvent event,
    Emitter<VyapaarJagatState> emit,
  ) async {
    emit(state.copyWith(status: VyapaarJagatStatus.submitting));
    try {
      final msg = await submitStoryUseCase(event.entity);
      emit(state.copyWith(
        status: VyapaarJagatStatus.success,
        successMessage: msg,
      ));
      add(const FetchStoryStatusEvent());
    } catch (e) {
      emit(state.copyWith(
        status: VyapaarJagatStatus.error,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      ));
    }
  }

  void _onResetState(
    ResetVyapaarJagatStateEvent event,
    Emitter<VyapaarJagatState> emit,
  ) {
    emit(state.copyWith(
      status: VyapaarJagatStatus.initial,
      errorMessage: null,
      successMessage: null,
    ));
  }
}
