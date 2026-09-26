import '../entities/peer_recommendation_entity.dart';
import '../repositories/recommend_peer_repository.dart';

class GetPeerRecommendationsHistoryUseCase {
  final RecommendPeerRepository repository;

  const GetPeerRecommendationsHistoryUseCase(this.repository);

  Future<List<PeerRecommendationEntity>> call() {
    return repository.getPeerRecommendationsHistory();
  }
}
