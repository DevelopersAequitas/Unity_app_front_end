import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/utils/app_error_handler.dart';
import '../../../domain/usecases/get_life_impact_actions_usecase.dart';
import '../../../domain/usecases/get_life_impact_history_usecase.dart';
import '../../../domain/usecases/submit_life_impact_usecase.dart';
import 'life_impact_event.dart';
import 'life_impact_state.dart';

class LifeImpactBloc extends Bloc<LifeImpactEvent, LifeImpactState> {
  final GetLifeImpactHistoryUseCase getLifeImpactHistoryUseCase;
  final GetLifeImpactActionsUseCase getLifeImpactActionsUseCase;
  final SubmitLifeImpactUseCase submitLifeImpactUseCase;

  LifeImpactBloc({
    required this.getLifeImpactHistoryUseCase,
    required this.getLifeImpactActionsUseCase,
    required this.submitLifeImpactUseCase,
  }) : super(const LifeImpactState()) {
    on<FetchLifeImpactHistoryEvent>(_onFetchHistory);
    on<FetchLifeImpactActionsEvent>(_onFetchActions);
    on<ChangeLifeImpactFilterEvent>(_onChangeFilter);
    on<SubmitLifeImpactEvent>(_onSubmitImpact);
  }

  Future<void> _onFetchHistory(
    FetchLifeImpactHistoryEvent event,
    Emitter<LifeImpactState> emit,
  ) async {
    if (!event.isRefresh && state.status == LifeImpactStatus.initial) {
      emit(state.copyWith(status: LifeImpactStatus.loading));
    }
    try {
      final result = await getLifeImpactHistoryUseCase();
      emit(
        state.copyWith(
          status: LifeImpactStatus.success,
          totalScore: result.totalLifeImpacted,
          history: result.items,
          errorMessage: null,
        ),
      );
    } catch (e, st) {
      emit(
        state.copyWith(
          status: LifeImpactStatus.failure,
          errorMessage: AppErrorHandler.toUserFriendlyMessage(e, st),
        ),
      );
    }
  }

  Future<void> _onFetchActions(
    FetchLifeImpactActionsEvent event,
    Emitter<LifeImpactState> emit,
  ) async {
    if (state.actionsStatus == LifeImpactStatus.initial) {
      emit(state.copyWith(actionsStatus: LifeImpactStatus.loading));
    }
    try {
      final actions = await getLifeImpactActionsUseCase();
      emit(
        state.copyWith(
          actionsStatus: LifeImpactStatus.success,
          actions: actions,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          actionsStatus: LifeImpactStatus.failure,
          actions: const [
            'p2p_meeting|||P2P Meeting',
            'business_deal|||Business Deal',
            'referral|||Referral',
            'testimonial|||Testimonial',
          ],
        ),
      );
    }
  }

  void _onChangeFilter(
    ChangeLifeImpactFilterEvent event,
    Emitter<LifeImpactState> emit,
  ) {
    emit(state.copyWith(selectedFilter: event.filter));
  }

  Future<void> _onSubmitImpact(
    SubmitLifeImpactEvent event,
    Emitter<LifeImpactState> emit,
  ) async {
    emit(
      state.copyWith(
        isSubmitting: true,
        errorMessage: null,
        successMessage: null,
      ),
    );
    try {
      await submitLifeImpactUseCase(event.params);
      final result = await getLifeImpactHistoryUseCase();
      emit(
        state.copyWith(
          isSubmitting: false,
          totalScore: result.totalLifeImpacted,
          history: result.items,
          successMessage: 'Life impact recorded successfully!',
        ),
      );
    } catch (e, st) {
      emit(
        state.copyWith(
          isSubmitting: false,
          errorMessage: AppErrorHandler.toUserFriendlyMessage(e, st),
        ),
      );
    }
  }
}
