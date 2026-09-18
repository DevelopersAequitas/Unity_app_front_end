import '../entities/peer_recommendation_entity.dart';
import '../repositories/recommend_peer_repository.dart';

class SubmitPeerRecommendationUseCase {
  final RecommendPeerRepository repository;
  const SubmitPeerRecommendationUseCase(this.repository);

  Future<void> call(PeerRecommendationEntity recommendation) {
    return repository.submitPeerRecommendation(recommendation);
  }
}
