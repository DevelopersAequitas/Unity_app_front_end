import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/ask_item_entity.dart';
import '../../../domain/usecases/get_my_asks_usecase.dart';
import '../../../domain/usecases/update_ask_status_usecase.dart';
import 'my_asks_event.dart';
import 'my_asks_state.dart';

class MyAsksBloc extends Bloc<MyAsksEvent, MyAsksState> {
  final GetMyAsksListUseCase getMyAsksUseCase;
  final UpdateAskStatusUseCase? updateAskStatusUseCase;

  MyAsksBloc({
    required this.getMyAsksUseCase,
    this.updateAskStatusUseCase,
  }) : super(const MyAsksState()) {
    on<MyAsksFetchRequested>(_onFetchRequested);
    on<UpdateAskStatusRequested>(_onUpdateStatusRequested);
  }

  Future<void> _onFetchRequested(
    MyAsksFetchRequested event,
    Emitter<MyAsksState> emit,
  ) async {
    final flow = event.flow ?? state.selectedFlow;
    final status = event.status ?? state.selectedStatus;

    emit(state.copyWith(
      status: MyAsksStatus.loading,
      selectedFlow: flow,
      selectedStatus: status,
    ));

    try {
      final asks = await getMyAsksUseCase(
        flow: flow != 'all' ? flow : null,
        status: status != 'all' ? status : null,
      );
      emit(state.copyWith(
        status: MyAsksStatus.success,
        asks: asks,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: MyAsksStatus.error,
        errorMessage: 'Unable to load requests. Please try again.',
      ));
    }
  }

  Future<void> _onUpdateStatusRequested(
    UpdateAskStatusRequested event,
    Emitter<MyAsksState> emit,
  ) async {
    // 1. Optimistic UI update
    final currentAsks = state.asks;
    final index = currentAsks.indexWhere((a) => a.id == event.askId);
    if (index != -1) {
      final old = currentAsks[index];
      final newRaw = Map<String, dynamic>.from(old.rawData);
      if (event.statusId != null) {
        newRaw['status_id'] = event.statusId;
        final label = _statusIdToLabel(event.statusId!, event.status);
        newRaw['status_label'] = label;
      }
      newRaw['status'] = event.status;
      newRaw['is_status_updated'] = true;
      final updated = old.copyWith(
        status: event.status,
        rawData: newRaw,
      );
      final list = List<AskItemEntity>.from(currentAsks);
      list[index] = updated;
      emit(state.copyWith(asks: list));
    }

    // 2. Call backend API
    if (updateAskStatusUseCase != null) {
      await updateAskStatusUseCase!(
        askId: event.askId,
        status: event.status,
        statusId: event.statusId,
        outcomeStatus: event.outcomeStatus,
        approxValue: event.approxValue,
        note: event.note,
        shareStory: event.shareStory,
      );
      add(const MyAsksFetchRequested(refresh: true));
    }
  }

  String _statusIdToLabel(int statusId, String fallback) {
    switch (statusId) {
      case 1:
        return 'Not Contacted Yet';
      case 2:
        return 'Contacted';
      case 3:
        return 'No Response';
      case 4:
        return 'Got The Business';
      case 5:
        return 'Got things done';
      case 6:
        return 'Did Not Get The Business';
      case 7:
        return 'Not a Good Fit';
      case 8:
        return 'Confidential';
      default:
        return fallback;
    }
  }
}
