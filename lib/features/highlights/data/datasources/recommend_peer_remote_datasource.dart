import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../models/peer_recommendation_model.dart';

abstract class RecommendPeerRemoteDataSource {
  Future<void> submitPeerRecommendation(PeerRecommendationModel model);
}

class RecommendPeerRemoteDataSourceImpl implements RecommendPeerRemoteDataSource {
  final DioClient dioClient;

  const RecommendPeerRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<void> submitPeerRecommendation(PeerRecommendationModel model) async {
    await dioClient.dio.post(ApiEndpoints.recommendPeer, data: model.toJson());
  }
}
