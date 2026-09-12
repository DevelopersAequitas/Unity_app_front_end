import 'package:dio/dio.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../models/brand_partner_model.dart';
import '../models/timeline_feed_response_model.dart';

abstract class HomeRemoteDataSource {
  Future<TimelineFeedResponseModel> getTimelineFeed({
    int page = 1,
    int perPage = 20,
    String? filter,
  });

  Future<List<BrandPartnerModel>> getBrandPartners();

  Future<void> likePost(String postId);

  Future<void> unlikePost(String postId);

  Future<void> toggleSavePost(String postId);
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final DioClient dioClient;

  HomeRemoteDataSourceImpl({required this.dioClient});

  Dio get _dio => dioClient.dio;

  @override
  Future<TimelineFeedResponseModel> getTimelineFeed({
    int page = 1,
    int perPage = 20,
    String? filter,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'per_page': perPage,
    };
    if (filter != null && filter.isNotEmpty && filter != 'All') {
      queryParams['filter'] = filter.toLowerCase();
    }

    final response = await _dio.get(
      ApiEndpoints.timelineFeed,
      queryParameters: queryParams,
    );

    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300 &&
        response.data is Map<String, dynamic>) {
      return TimelineFeedResponseModel.fromJson(
        response.data as Map<String, dynamic>,
      );
    }
    throw Exception('Failed to load timeline feed.');
  }

  @override
  Future<List<BrandPartnerModel>> getBrandPartners() async {
    try {
      final response = await _dio.get(ApiEndpoints.brandPartners);
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300 &&
          response.data is Map<String, dynamic>) {
        final data = response.data['data'];
        List? rawList;
        if (data is Map<String, dynamic>) {
          rawList = (data['data'] ?? data['items']) as List?;
        } else if (data is List) {
          rawList = data;
        }

        if (rawList != null) {
          return rawList
              .whereType<Map<String, dynamic>>()
              .map((e) => BrandPartnerModel.fromJson(e))
              .toList();
        }
      }
      return const [];
    } catch (_) {
      return const [];
    }
  }

  @override
  Future<void> likePost(String postId) async {
    await _dio.post(ApiEndpoints.postLike(postId));
  }

  @override
  Future<void> unlikePost(String postId) async {
    await _dio.delete(ApiEndpoints.postLike(postId));
  }

  @override
  Future<void> toggleSavePost(String postId) async {
    await _dio.post(ApiEndpoints.postSave(postId));
  }
}
