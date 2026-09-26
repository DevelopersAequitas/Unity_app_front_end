import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_ask_matches_usecase.dart';
import 'ask_matches_event.dart';
import 'ask_matches_state.dart';

class AskMatchesBloc extends Bloc<AskMatchesEvent, AskMatchesState> {
  final GetAskMatchesUseCase getAskMatchesUseCase;

  AskMatchesBloc({required this.getAskMatchesUseCase})
      : super(const AskMatchesState()) {
    on<AskMatchesFetchRequested>(_onFetchRequested);
  }

  Future<void> _onFetchRequested(
    AskMatchesFetchRequested event,
    Emitter<AskMatchesState> emit,
  ) async {
    emit(state.copyWith(status: AskMatchesStatus.loading));
    try {
      final matches = await getAskMatchesUseCase.execute(event.askId);
      emit(state.copyWith(
        status: AskMatchesStatus.loaded,
        matches: matches,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AskMatchesStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }
}
