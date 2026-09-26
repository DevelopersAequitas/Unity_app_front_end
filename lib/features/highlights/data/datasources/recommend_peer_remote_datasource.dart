import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../models/peer_recommendation_model.dart';

abstract class RecommendPeerRemoteDataSource {
  Future<void> submitPeerRecommendation(PeerRecommendationModel model);
  Future<List<PeerRecommendationModel>> getPeerRecommendationsHistory();
}

class RecommendPeerRemoteDataSourceImpl
    implements RecommendPeerRemoteDataSource {
  final DioClient dioClient;

  const RecommendPeerRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<void> submitPeerRecommendation(PeerRecommendationModel model) async {
    await dioClient.dio.post(
      ApiEndpoints.recommendPeer,
      data: model.toJson(),
    );
  }

  @override
  Future<List<PeerRecommendationModel>> getPeerRecommendationsHistory() async {
    final response = await dioClient.dio.get(ApiEndpoints.recommendPeerMy);
    final data = response.data;
    List<dynamic> items = [];
    if (data is Map) {
      final inner = data['data'];
      if (inner is Map && inner['items'] is List) {
        items = inner['items'] as List;
      } else if (inner is List) {
        items = inner;
      } else if (data['items'] is List) {
        items = data['items'] as List;
      }
    } else if (data is List) {
      items = data;
    }
    return items
        .whereType<Map>()
        .map((e) => PeerRecommendationModel.fromJson(
            Map<String, dynamic>.from(e)))
        .toList();
  }
}
