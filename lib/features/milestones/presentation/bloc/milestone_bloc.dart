import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_latest_milestone_usecase.dart';
import '../../domain/usecases/get_milestone_history_usecase.dart';
import 'milestone_event.dart';
import 'milestone_state.dart';

class MilestoneBloc extends Bloc<MilestoneEvent, MilestoneState> {
  final GetLatestMilestoneUseCase getLatestMilestoneUseCase;
  final GetMilestoneHistoryUseCase getMilestoneHistoryUseCase;

  MilestoneBloc({
    required this.getLatestMilestoneUseCase,
    required this.getMilestoneHistoryUseCase,
  }) : super(const MilestoneState()) {
    on<FetchMilestonesEvent>(_onFetchMilestones);
  }

  Future<void> _onFetchMilestones(
    FetchMilestonesEvent event,
    Emitter<MilestoneState> emit,
  ) async {
    if (!event.isRefresh) {
      emit(state.copyWith(status: MilestoneStatus.loading));
    }

    try {
      final results = await Future.wait([
        getLatestMilestoneUseCase.execute(
          event.userId,
          forceRefresh: event.isRefresh,
        ),
        getMilestoneHistoryUseCase.execute(
          event.userId,
          forceRefresh: event.isRefresh,
        ),
      ]);

      final latest = results[0] as dynamic;
      final historyList = results[1] as dynamic;

      emit(
        state.copyWith(
          status: MilestoneStatus.success,
          latestMilestone: latest,
          history: historyList,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: MilestoneStatus.failure,
          errorMessage: e.toString().replaceAll('Exception: ', ''),
        ),
      );
    }
  }
}
