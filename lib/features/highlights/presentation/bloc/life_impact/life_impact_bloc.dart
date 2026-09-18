import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_life_impact_history_usecase.dart';
import '../../../domain/usecases/submit_life_impact_usecase.dart';
import 'life_impact_event.dart';
import 'life_impact_state.dart';

class LifeImpactBloc extends Bloc<LifeImpactEvent, LifeImpactState> {
  final GetLifeImpactHistoryUseCase getLifeImpactHistoryUseCase;
  final SubmitLifeImpactUseCase submitLifeImpactUseCase;

  LifeImpactBloc({
    required this.getLifeImpactHistoryUseCase,
    required this.submitLifeImpactUseCase,
  }) : super(const LifeImpactState()) {
    on<FetchLifeImpactHistoryEvent>(_onFetchHistory);
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
      final items = await getLifeImpactHistoryUseCase();
      emit(state.copyWith(
        status: LifeImpactStatus.success,
        history: items,
        errorMessage: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: LifeImpactStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onSubmitImpact(
    SubmitLifeImpactEvent event,
    Emitter<LifeImpactState> emit,
  ) async {
    emit(state.copyWith(isSubmitting: true, errorMessage: null, successMessage: null));
    try {
      await submitLifeImpactUseCase(
        title: event.title,
        description: event.description,
        category: event.category,
        impactPoints: event.impactPoints,
      );
      final updatedList = await getLifeImpactHistoryUseCase();
      emit(state.copyWith(
        isSubmitting: false,
        history: updatedList,
        successMessage: 'Impact recorded successfully!',
      ));
    } catch (e) {
      emit(state.copyWith(
        isSubmitting: false,
        errorMessage: e.toString(),
      ));
    }
  }
}
