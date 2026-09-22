import 'package:dio/dio.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../models/intro_video_model.dart';

abstract class ShortsRemoteDataSource {
  Future<List<IntroVideoModel>> getIntroVideos({
    int page = 1,
    int perPage = 10,
  });
  Future<bool> toggleLike(String introVideoId, bool currentStatus);
  Future<bool> toggleBookmark(String memberId, bool currentStatus);
  Future<bool> toggleFollow(String memberId, bool currentStatus);
}

class ShortsRemoteDataSourceImpl implements ShortsRemoteDataSource {
  final DioClient dioClient;

  ShortsRemoteDataSourceImpl({required this.dioClient});

  Dio get _dio => dioClient.dio;

  @override
  Future<List<IntroVideoModel>> getIntroVideos({
    int page = 1,
    int perPage = 10,
  }) async {
    final response = await _dio.get(
      ApiEndpoints.introVideos,
      queryParameters: {'page': page, 'per_page': perPage},
    );

    final data = response.data;
    List? rawList;
    if (data is Map<String, dynamic>) {
      final inner = data['data'];
      if (inner is List) {
        rawList = inner;
      } else if (inner is Map<String, dynamic>) {
        rawList = (inner['data'] ?? inner['items']) as List?;
      }
    } else if (data is List) {
      rawList = data;
    }

    if (rawList != null) {
      return rawList
          .whereType<Map<String, dynamic>>()
          .map((json) => IntroVideoModel.fromJson(json))
          .toList();
    }
    return [];
  }

  @override
  Future<bool> toggleLike(String introVideoId, bool currentStatus) async {
    try {
      final endpoint = '${ApiEndpoints.introVideos}/$introVideoId/like';
      if (currentStatus) {
        await _dio.delete(endpoint);
        return false;
      } else {
        await _dio.post(endpoint);
        return true;
      }
    } catch (_) {
      try {
        await _dio.post('${ApiEndpoints.introVideos}/$introVideoId/toggle-like');
        return !currentStatus;
      } catch (_) {
        return !currentStatus;
      }
    }
  }

  @override
  Future<bool> toggleBookmark(String memberId, bool currentStatus) async {
    if (currentStatus) {
      await _dio.delete(ApiEndpoints.memberBookmark(memberId));
      return false;
    } else {
      await _dio.post(ApiEndpoints.memberBookmark(memberId));
      return true;
    }
  }

  @override
  Future<bool> toggleFollow(String memberId, bool currentStatus) async {
    if (currentStatus) {
      await _dio.post(ApiEndpoints.unfollowUser(memberId));
      return false;
    } else {
      await _dio.post(ApiEndpoints.followUser(memberId));
      return true;
    }
  }
}
