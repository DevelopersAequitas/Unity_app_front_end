import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../models/introduced_peer_model.dart';
import '../models/top_builder_model.dart';

abstract class TopBuildersRemoteDataSource {
  Future<List<TopBuilderModel>> getTopBuilders();
  Future<List<IntroducedPeerModel>> getMyIntroducedPeers();
}

class TopBuildersRemoteDataSourceImpl implements TopBuildersRemoteDataSource {
  final DioClient dioClient;
  const TopBuildersRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<List<TopBuilderModel>> getTopBuilders() async {
    final response = await dioClient.dio.get(ApiEndpoints.topIntroducers);
    final data = response.data['data'];
    List<dynamic> items = [];
    if (data is Map<String, dynamic> && data['items'] is List) {
      items = data['items'] as List;
    } else if (data is List) {
      items = data;
    }
    return items.asMap().entries.map((entry) {
      final item = entry.value as Map<String, dynamic>;
      return TopBuilderModel.fromJson(item, rank: entry.key + 1);
    }).toList();
  }

  @override
  Future<List<IntroducedPeerModel>> getMyIntroducedPeers() async {
    final response = await dioClient.dio.get(ApiEndpoints.introducedPeers);
    final data = response.data['data'];
    List<dynamic> items = [];
    if (data is Map<String, dynamic> && data['items'] is List) {
      items = data['items'] as List;
    } else if (data is List) {
      items = data;
    }
    return items
        .whereType<Map<String, dynamic>>()
        .map((e) => IntroducedPeerModel.fromJson(e))
        .toList();
  }
}
