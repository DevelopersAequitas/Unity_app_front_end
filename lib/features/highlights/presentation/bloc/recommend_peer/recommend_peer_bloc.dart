import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/submit_peer_recommendation_usecase.dart';
import 'recommend_peer_event.dart';
import 'recommend_peer_state.dart';

class RecommendPeerBloc extends Bloc<RecommendPeerEvent, RecommendPeerState> {
  final SubmitPeerRecommendationUseCase submitPeerRecommendationUseCase;

  RecommendPeerBloc({required this.submitPeerRecommendationUseCase})
      : super(const RecommendPeerState()) {
    on<SubmitPeerRecommendationEvent>(_onSubmitRecommendation);
  }

  Future<void> _onSubmitRecommendation(
    SubmitPeerRecommendationEvent event,
    Emitter<RecommendPeerState> emit,
  ) async {
    emit(state.copyWith(status: RecommendPeerStatus.submitting));
    try {
      await submitPeerRecommendationUseCase(event.recommendation);
      emit(state.copyWith(
        status: RecommendPeerStatus.success,
        successMessage: 'Peer recommendation submitted successfully!',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: RecommendPeerStatus.failure,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      ));
    }
  }
}
