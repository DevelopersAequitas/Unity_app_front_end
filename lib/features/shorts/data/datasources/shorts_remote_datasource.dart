import 'package:dio/dio.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../models/intro_video_model.dart';

/// Holds paginated results from the intro-videos API.
class ShortsVideosResult {
  final List<IntroVideoModel> videos;
  final int? total;

  const ShortsVideosResult({required this.videos, this.total});
}

abstract class ShortsRemoteDataSource {
  Future<ShortsVideosResult> getIntroVideos({
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
  Future<ShortsVideosResult> getIntroVideos({
    int page = 1,
    int perPage = 10,
  }) async {
    final response = await _dio.get(
      ApiEndpoints.introVideos,
      queryParameters: {'page': page, 'per_page': perPage},
    );

    final data = response.data;
    List? rawList;
    int? totalCount;

    if (data is Map<String, dynamic>) {
      final inner = data['data'];
      final meta = data['meta'] as Map<String, dynamic>?;
      totalCount = (meta?['total'] as num?)?.toInt();

      if (inner is List) {
        rawList = inner;
      } else if (inner is Map<String, dynamic>) {
        rawList = (inner['data'] ?? inner['items']) as List?;
        final innerMeta = inner['meta'] ?? inner['pagination'];
        if (innerMeta is Map<String, dynamic>) {
          totalCount ??= (innerMeta['total'] as num?)?.toInt();
        }
      }
    } else if (data is List) {
      rawList = data;
    }

    final videos = rawList == null
        ? <IntroVideoModel>[]
        : rawList
            .whereType<Map<String, dynamic>>()
            .map((json) => IntroVideoModel.fromJson(json))
            .toList();

    return ShortsVideosResult(videos: videos, total: totalCount);
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
