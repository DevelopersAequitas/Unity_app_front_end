import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_ask_flows_usecase.dart';
import 'ask_flows_event.dart';
import 'ask_flows_state.dart';

class AskFlowsBloc extends Bloc<AskFlowsEvent, AskFlowsState> {
  final GetAskFlowsUseCase getAskFlowsUseCase;

  AskFlowsBloc({required this.getAskFlowsUseCase})
      : super(const AskFlowsState()) {
    on<AskFlowsFetchRequested>(_onFetchRequested);
    on<AskFlowsRefreshRequested>(_onRefreshRequested);
  }

  Future<void> _onFetchRequested(
    AskFlowsFetchRequested event,
    Emitter<AskFlowsState> emit,
  ) async {
    if (state.flows.isEmpty) {
      emit(state.copyWith(status: AskFlowsStatus.loading));
    }
    try {
      final flows = await getAskFlowsUseCase();
      emit(state.copyWith(
        status: AskFlowsStatus.success,
        flows: flows,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AskFlowsStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onRefreshRequested(
    AskFlowsRefreshRequested event,
    Emitter<AskFlowsState> emit,
  ) async {
    try {
      final flows = await getAskFlowsUseCase();
      emit(state.copyWith(
        status: AskFlowsStatus.success,
        flows: flows,
      ));
    } catch (e) {
      // Keep existing flows on refresh failure
      emit(state.copyWith(
        errorMessage: e.toString(),
      ));
    }
  }
}
