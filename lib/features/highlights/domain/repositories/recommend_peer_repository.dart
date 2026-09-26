import '../entities/peer_recommendation_entity.dart';

abstract class RecommendPeerRepository {
  Future<void> submitPeerRecommendation(PeerRecommendationEntity recommendation);
  Future<List<PeerRecommendationEntity>> getPeerRecommendationsHistory();
}
