import '../../domain/entities/peer_recommendation_entity.dart';
import '../../domain/repositories/recommend_peer_repository.dart';
import '../datasources/recommend_peer_remote_datasource.dart';
import '../models/peer_recommendation_model.dart';

class RecommendPeerRepositoryImpl implements RecommendPeerRepository {
  final RecommendPeerRemoteDataSource remoteDataSource;

  const RecommendPeerRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> submitPeerRecommendation(PeerRecommendationEntity recommendation) async {
    final model = PeerRecommendationModel.fromEntity(recommendation);
    await remoteDataSource.submitPeerRecommendation(model);
  }

  @override
  Future<List<PeerRecommendationEntity>> getPeerRecommendationsHistory() async {
    return await remoteDataSource.getPeerRecommendationsHistory();
  }
}
