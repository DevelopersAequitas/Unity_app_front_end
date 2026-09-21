import '../../../../core/network/dio_client.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../models/requirement_model.dart';

abstract class RequirementsRemoteDataSource {
  Future<List<RequirementModel>> getOpenRequirements();
  Future<List<RequirementModel>> getMyRequirements();
  Future<void> createRequirement({
    required String subject,
    required String description,
    required String category,
    required String regionLabel,
    required String cityName,
    String? mediaId,
  });
  Future<void> completeRequirement(String id);
  Future<void> fulfillRequirement(String id, String message);
}

class RequirementsRemoteDataSourceImpl implements RequirementsRemoteDataSource {
  final DioClient dioClient;

  RequirementsRemoteDataSourceImpl({required this.dioClient});

  List<RequirementModel> _parseList(dynamic data) {
    List items = [];
    if (data is Map<String, dynamic>) {
      final inner = data['data'] ?? data['requirements'] ?? data['items'];
      if (inner is List) {
        items = inner;
      } else if (inner is Map<String, dynamic>) {
        final nested = inner['items'] ?? inner['requirements'];
        if (nested is List) items = nested;
      }
    } else if (data is List) {
      items = data;
    }
    return items
        .whereType<Map<String, dynamic>>()
        .map((json) => RequirementModel.fromJson(json))
        .toList();
  }

  @override
  Future<List<RequirementModel>> getOpenRequirements() async {
    for (final path in [
      ApiEndpoints.timelineRequirements,
      ApiEndpoints.incompletedRequirements,
      ApiEndpoints.activitiesRequirements,
    ]) {
      try {
        final response = await dioClient.dio.get(path);
        final parsed = _parseList(response.data);
        if (parsed.isNotEmpty) return parsed;
      } catch (_) {}
    }
    return [];
  }

  @override
  Future<List<RequirementModel>> getMyRequirements() async {
    final response = await dioClient.dio.get(ApiEndpoints.myRequirements);
    return _parseList(response.data);
  }

  @override
  Future<void> createRequirement({
    required String subject,
    required String description,
    required String category,
    required String regionLabel,
    required String cityName,
    String? mediaId,
  }) async {
    final body = <String, dynamic>{
      'subject': subject,
      'description': description,
      'category': category,
      'region_label': regionLabel,
      'city_name': cityName,
      'status': 'open',
      if (mediaId != null && mediaId.isNotEmpty) 'media_id': mediaId,
    };
    await dioClient.dio.post(ApiEndpoints.activitiesRequirements, data: body);
  }

  @override
  Future<void> completeRequirement(String id) async {
    await dioClient.dio.patch(
      ApiEndpoints.closeRequirement(id),
      data: {'status': 'completed'},
    );
  }

  @override
  Future<void> fulfillRequirement(String id, String message) async {
    await dioClient.dio.post(
      ApiEndpoints.fulfillRequirement(id),
      data: {'message': message},
    );
  }
}
