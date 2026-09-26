import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_peer_recommendations_history_usecase.dart';
import '../../../domain/usecases/submit_peer_recommendation_usecase.dart';
import 'recommend_peer_event.dart';
import 'recommend_peer_state.dart';

class RecommendPeerBloc extends Bloc<RecommendPeerEvent, RecommendPeerState> {
  final SubmitPeerRecommendationUseCase submitPeerRecommendationUseCase;
  final GetPeerRecommendationsHistoryUseCase getPeerRecommendationsHistoryUseCase;

  RecommendPeerBloc({
    required this.submitPeerRecommendationUseCase,
    required this.getPeerRecommendationsHistoryUseCase,
  }) : super(const RecommendPeerState()) {
    on<SubmitPeerRecommendationEvent>(_onSubmitRecommendation);
    on<FetchPeerRecommendationsHistoryEvent>(_onFetchHistory);
    on<RefreshPeerRecommendationsHistoryEvent>(_onRefreshHistory);
  }

  Future<void> _onSubmitRecommendation(
    SubmitPeerRecommendationEvent event,
    Emitter<RecommendPeerState> emit,
  ) async {
    emit(state.copyWith(
      status: RecommendPeerStatus.submitting,
      errorMessage: null,
      successMessage: null,
    ));
    try {
      await submitPeerRecommendationUseCase(event.recommendation);
      emit(state.copyWith(
        status: RecommendPeerStatus.success,
        successMessage: 'Peer recommendation submitted successfully!',
      ));
      // Refresh history list automatically after successful submission
      add(const FetchPeerRecommendationsHistoryEvent());
    } catch (e) {
      emit(state.copyWith(
        status: RecommendPeerStatus.failure,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      ));
    }
  }

  Future<void> _onFetchHistory(
    FetchPeerRecommendationsHistoryEvent event,
    Emitter<RecommendPeerState> emit,
  ) async {
    emit(state.copyWith(
      historyStatus: RecommendPeerHistoryStatus.loading,
      historyErrorMessage: null,
    ));
    try {
      final history = await getPeerRecommendationsHistoryUseCase();
      emit(state.copyWith(
        historyStatus: RecommendPeerHistoryStatus.success,
        history: history,
      ));
    } catch (e) {
      emit(state.copyWith(
        historyStatus: RecommendPeerHistoryStatus.failure,
        historyErrorMessage: e.toString().replaceAll('Exception: ', ''),
      ));
    }
  }

  Future<void> _onRefreshHistory(
    RefreshPeerRecommendationsHistoryEvent event,
    Emitter<RecommendPeerState> emit,
  ) async {
    try {
      final history = await getPeerRecommendationsHistoryUseCase();
      emit(state.copyWith(
        historyStatus: RecommendPeerHistoryStatus.success,
        history: history,
      ));
    } catch (e) {
      emit(state.copyWith(
        historyStatus: RecommendPeerHistoryStatus.failure,
        historyErrorMessage: e.toString().replaceAll('Exception: ', ''),
      ));
    }
  }
}
