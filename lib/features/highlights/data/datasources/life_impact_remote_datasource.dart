import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../models/life_impact_model.dart';

abstract class LifeImpactRemoteDataSource {
  Future<List<LifeImpactModel>> getLifeImpactHistory();
  Future<void> submitLifeImpact({
    required String title,
    required String description,
    required String category,
    required int impactPoints,
  });
}

class LifeImpactRemoteDataSourceImpl implements LifeImpactRemoteDataSource {
  final DioClient dioClient;
  const LifeImpactRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<List<LifeImpactModel>> getLifeImpactHistory() async {
    final response = await dioClient.dio.get(ApiEndpoints.lifeImpactHistory);
    final data = response.data['data'];
    List<dynamic> items = [];
    if (data is Map<String, dynamic> && data['items'] is List) {
      items = data['items'] as List;
    } else if (data is List) {
      items = data;
    }
    return items
        .whereType<Map<String, dynamic>>()
        .map((e) => LifeImpactModel.fromJson(e))
        .toList();
  }

  @override
  Future<void> submitLifeImpact({
    required String title,
    required String description,
    required String category,
    required int impactPoints,
  }) async {
    await dioClient.dio.post(
      ApiEndpoints.lifeImpact,
      data: {
        'title': title,
        'description': description,
        'category': category,
        'impact_value': impactPoints,
      },
    );
  }
}
