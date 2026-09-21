import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../../domain/entities/create_business_deal_params.dart';
import '../models/business_deal_leaderboard_model.dart';
import '../models/business_deal_model.dart';
import '../models/paginated_business_deals_model.dart';

class ProMembershipRequiredException implements Exception {
  final String message;
  const ProMembershipRequiredException([
    this.message = 'Pro membership required to record business deals.',
  ]);

  @override
  String toString() => message;
}

abstract class BusinessDealsRemoteDataSource {
  Future<PaginatedBusinessDealsModel> getUserBusinessDeals(
    String userId, {
    int page = 1,
    int perPage = 20,
  });

  Future<PaginatedBusinessDealsModel> getReceivedBusinessDeals({
    int page = 1,
    int perPage = 20,
  });

  Future<PaginatedBusinessDealsModel> getGivenBusinessDeals({
    int page = 1,
    int perPage = 20,
  });

  Future<List<BusinessDealLeaderboardModel>> getBusinessDealsLeaderboard();

  Future<BusinessDealModel> getBusinessDealDetail(String id);

  Future<BusinessDealModel> createBusinessDeal(CreateBusinessDealParams params);

  Future<void> uploadActivityCreative({
    required String activityId,
    required String postId,
    required File creativeImage,
  });
}

class BusinessDealsRemoteDataSourceImpl
    implements BusinessDealsRemoteDataSource {
  final DioClient dioClient;

  BusinessDealsRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<List<BusinessDealLeaderboardModel>> getBusinessDealsLeaderboard() async {
    final response = await dioClient.dio.get(ApiEndpoints.leaderboardBusinessDeals);
    final data = response.data['data'] ?? response.data;
    List<dynamic> items = [];
    if (data is Map<String, dynamic> && data['items'] is List) {
      items = data['items'] as List;
    } else if (data is List) {
      items = data;
    }
    return items.asMap().entries.map((entry) {
      final item = entry.value as Map<String, dynamic>;
      return BusinessDealLeaderboardModel.fromJson(
        item,
        fallbackRank: entry.key + 1,
      );
    }).toList();
  }

  @override
  Future<PaginatedBusinessDealsModel> getUserBusinessDeals(
    String userId, {
    int page = 1,
    int perPage = 20,
  }) async {
    final response = await dioClient.dio.get(
      ApiEndpoints.userBusinessDeals(userId),
      queryParameters: {'page': page, 'per_page': perPage},
    );
    return PaginatedBusinessDealsModel.fromJson(response.data);
  }

  @override
  Future<PaginatedBusinessDealsModel> getReceivedBusinessDeals({
    int page = 1,
    int perPage = 20,
  }) async {
    final response = await dioClient.dio.get(
      ApiEndpoints.businessDeals,
      queryParameters: {
        'filter': 'received',
        'page': page,
        'per_page': perPage,
      },
    );
    return PaginatedBusinessDealsModel.fromJson(response.data);
  }

  @override
  Future<PaginatedBusinessDealsModel> getGivenBusinessDeals({
    int page = 1,
    int perPage = 20,
  }) async {
    final response = await dioClient.dio.get(
      ApiEndpoints.businessDeals,
      queryParameters: {'filter': 'given', 'page': page, 'per_page': perPage},
    );
    return PaginatedBusinessDealsModel.fromJson(response.data);
  }

  @override
  Future<BusinessDealModel> getBusinessDealDetail(String id) async {
    final response = await dioClient.dio.get(
      ApiEndpoints.singleBusinessDeal(id),
    );
    final data = response.data;
    if (data is Map<String, dynamic>) {
      final itemData = (data['data'] is Map<String, dynamic>)
          ? Map<String, dynamic>.from(data['data'] as Map<String, dynamic>)
          : Map<String, dynamic>.from(data);
      return BusinessDealModel.fromJson(itemData);
    }
    throw Exception('Failed to load business deal detail');
  }

  @override
  Future<BusinessDealModel> createBusinessDeal(
    CreateBusinessDealParams params,
  ) async {
    try {
      final response = await dioClient.dio.post(
        ApiEndpoints.businessDeals,
        data: params.toJson(),
      );
      final data = response.data;
      if (data is Map<String, dynamic>) {
        if (data['requires_pro'] == true ||
            data['error_code'] == 'PRO_MEMBERSHIP_REQUIRED') {
          throw ProMembershipRequiredException(
            data['message']?.toString() ??
                'Pro membership required to record business deals.',
          );
        }
        final itemData = (data['data'] is Map<String, dynamic>)
            ? Map<String, dynamic>.from(data['data'] as Map<String, dynamic>)
            : Map<String, dynamic>.from(data);
        if (data['coins'] != null && itemData['coins'] == null) {
          itemData['coins'] = data['coins'];
        }
        if (data['impacts'] != null && itemData['impacts'] == null) {
          itemData['impacts'] = data['impacts'];
        }
        if (data['life_impact'] != null && itemData['life_impact'] == null) {
          itemData['life_impact'] = data['life_impact'];
        }
        if (data['coins_earned'] != null && itemData['coins_earned'] == null) {
          itemData['coins_earned'] = data['coins_earned'];
        }
        if (data['impacts_earned'] != null &&
            itemData['impacts_earned'] == null) {
          itemData['impacts_earned'] = data['impacts_earned'];
        }
        return BusinessDealModel.fromJson(itemData);
      }
      throw Exception('Failed to create business deal');
    } on DioException catch (e) {
      final resData = e.response?.data;
      if (resData is Map<String, dynamic>) {
        if (resData['requires_pro'] == true ||
            resData['error_code'] == 'PRO_MEMBERSHIP_REQUIRED' ||
            e.response?.statusCode == 403) {
          throw ProMembershipRequiredException(
            resData['message']?.toString() ??
                'Pro membership required to record business deals.',
          );
        }
        if (resData['message'] != null) {
          throw Exception(resData['message'].toString());
        }
      }
      rethrow;
    }
  }

  @override
  Future<void> uploadActivityCreative({
    required String activityId,
    required String postId,
    required File creativeImage,
  }) async {
    final fileName = creativeImage.path.split(RegExp(r'[\\/]')).last;
    final effectivePostId = postId.isNotEmpty ? postId : activityId;
    final effectiveActivityId = activityId.isNotEmpty
        ? activityId
        : effectivePostId;

    final endpoints = [ApiEndpoints.activityCreatives, '/activity-creatives'];

    dynamic lastError;
    for (final endpoint in endpoints) {
      try {
        final formData = FormData.fromMap({
          'activity_type': 'business_deal',
          'activity_id': effectiveActivityId,
          'post_id': effectivePostId,
          'title': 'Business Deal Creative',
          'description': 'Creative generated from Flutter',
          'meta[template]': 'business_deal_creative',
          'meta[source]': 'flutter',
          'media_type': 'image',
          'creative_image': await MultipartFile.fromFile(
            creativeImage.path,
            filename: fileName,
          ),
          'creative_media': await MultipartFile.fromFile(
            creativeImage.path,
            filename: fileName,
          ),
        });

        final response = await dioClient.dio.post(endpoint, data: formData);

        if (response.statusCode == 200 || response.statusCode == 201) {
          debugPrint('✅ BD uploadActivityCreative SUCCESS via $endpoint');
          return;
        }
      } catch (e) {
        lastError = e;
      }
    }

    if (lastError != null) {
      debugPrint('⚠️ BD uploadActivityCreative error: $lastError');
    }
  }
}
