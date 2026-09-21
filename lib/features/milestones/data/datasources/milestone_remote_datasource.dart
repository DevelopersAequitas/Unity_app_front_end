import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../models/milestone_model.dart';

abstract class MilestoneRemoteDataSource {
  Future<LatestMilestoneModel> getLatestMilestone(
    String userId, {
    bool forceRefresh = false,
  });
  Future<List<MilestoneItemModel>> getMilestoneHistory(
    String userId, {
    bool forceRefresh = false,
  });
}

class MilestoneRemoteDataSourceImpl implements MilestoneRemoteDataSource {
  final DioClient dioClient;

  static final Map<String, LatestMilestoneModel> _cachedLatestMap = {};
  static final Map<String, List<MilestoneItemModel>> _cachedHistoryMap = {};

  static void clearCache() {
    _cachedLatestMap.clear();
    _cachedHistoryMap.clear();
  }

  const MilestoneRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<LatestMilestoneModel> getLatestMilestone(
    String userId, {
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh && _cachedLatestMap.containsKey(userId)) {
      return _cachedLatestMap[userId]!;
    }

    final response = await dioClient.dio.get(
      ApiEndpoints.latestMilestone(userId),
    );

    final dynamic data = response.data;
    if (data is Map<String, dynamic> && data['data'] != null) {
      final model = LatestMilestoneModel.fromJson(
        data['data'] as Map<String, dynamic>,
      );
      _cachedLatestMap[userId] = model;
      return model;
    } else if (data is Map<String, dynamic>) {
      final model = LatestMilestoneModel.fromJson(data);
      _cachedLatestMap[userId] = model;
      return model;
    }
    throw Exception('Invalid data format for latest milestone');
  }

  @override
  Future<List<MilestoneItemModel>> getMilestoneHistory(
    String userId, {
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh && _cachedHistoryMap.containsKey(userId)) {
      return _cachedHistoryMap[userId]!;
    }

    final response = await dioClient.dio.get(
      ApiEndpoints.milestoneHistory(userId),
    );

    final dynamic data = response.data;
    List<dynamic> dataList = [];
    if (data is Map<String, dynamic> && data['data'] is List) {
      dataList = data['data'] as List<dynamic>;
    } else if (data is List) {
      dataList = data;
    }

    final list = dataList
        .whereType<Map<String, dynamic>>()
        .map((item) => MilestoneItemModel.fromJson(item))
        .toList();
    _cachedHistoryMap[userId] = list;
    return list;
  }
}
