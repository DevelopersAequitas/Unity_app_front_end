import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_ask_responses_usecase.dart';
import 'ask_responses_event.dart';
import 'ask_responses_state.dart';

class AskResponsesBloc extends Bloc<AskResponsesEvent, AskResponsesState> {
  final GetAskResponsesUseCase getAskResponsesUseCase;

  AskResponsesBloc({required this.getAskResponsesUseCase})
      : super(const AskResponsesState()) {
    on<AskResponsesFetchRequested>(_onFetchRequested);
    on<AskResponsesFilterChanged>(_onFilterChanged);
  }

  Future<void> _onFetchRequested(
    AskResponsesFetchRequested event,
    Emitter<AskResponsesState> emit,
  ) async {
    emit(state.copyWith(status: AskResponsesStatus.loading));
    try {
      final list = await getAskResponsesUseCase.execute(event.askId);
      emit(state.copyWith(
        status: AskResponsesStatus.success,
        responses: list,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AskResponsesStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onFilterChanged(
    AskResponsesFilterChanged event,
    Emitter<AskResponsesState> emit,
  ) {
    emit(state.copyWith(activeFilter: event.filter));
  }
}
