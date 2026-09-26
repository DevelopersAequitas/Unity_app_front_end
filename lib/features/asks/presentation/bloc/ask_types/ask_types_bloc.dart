import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_ask_types_usecase.dart';
import 'ask_types_event.dart';
import 'ask_types_state.dart';

class AskTypesBloc extends Bloc<AskTypesEvent, AskTypesState> {
  final GetAskTypesUseCase getAskTypesUseCase;

  AskTypesBloc({required this.getAskTypesUseCase})
      : super(const AskTypesState()) {
    on<AskTypesFetchRequested>(_onFetchRequested);
    on<AskTypesRefreshRequested>(_onRefreshRequested);
  }

  Future<void> _onFetchRequested(
    AskTypesFetchRequested event,
    Emitter<AskTypesState> emit,
  ) async {
    if (state.types.isEmpty) {
      emit(state.copyWith(status: AskTypesStatus.loading));
    }
    try {
      final types = await getAskTypesUseCase(event.flowIdOrCode);
      emit(state.copyWith(
        status: AskTypesStatus.success,
        types: types,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AskTypesStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onRefreshRequested(
    AskTypesRefreshRequested event,
    Emitter<AskTypesState> emit,
  ) async {
    try {
      final types = await getAskTypesUseCase(event.flowIdOrCode);
      emit(state.copyWith(
        status: AskTypesStatus.success,
        types: types,
      ));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }
}
