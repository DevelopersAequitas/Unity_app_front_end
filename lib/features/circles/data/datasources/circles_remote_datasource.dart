import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../models/circle_category_model.dart';
import '../models/circle_closed_category_model.dart';
import '../models/circle_join_request_model.dart';
import '../models/circle_member_model.dart';
import '../models/circle_model.dart';
import '../models/circle_open_category_model.dart';
import '../models/circle_package_model.dart';

abstract class CirclesRemoteDataSource {
  Future<List<CircleModel>> getMyCircles();
  Future<List<CircleModel>> getJoinedCircles();
  Future<CirclePackageModel> getCirclePackage(String circleId);
  Future<List<CircleCategoryModel>> getCircleCategories();
  Future<CircleModel> getCircleDetail(String id);
  Future<List<CircleMemberModel>> getCircleMembers(String circleId);
  Future<List<CircleCategoryModel>> getCategorySubcategories(String categoryId);
  Future<List<CircleOpenCategoryModel>> getCircleOpenCategories(
    String circleId,
  );
  Future<List<CircleClosedCategoryModel>> getCircleClosedCategories(
    String circleId,
  );
  Future<CircleJoinRequestModel> submitJoinRequest({
    required String circleId,
    required String reason,
    dynamic categoryId,
    dynamic level4CategoryId,
    bool isOtherCategory = false,
    String? customCategoryName,
  });
  Future<List<CircleJoinRequestModel>> getMyJoinRequests();
  Future<CircleJoinRequestModel> getCircleJoinRequestStatus(String requestId);
  Future<bool> cancelCircleJoinRequest(String requestId);
  Future<String> getCircleCheckoutUrl(String circleId);
  Future<CircleJoinRequestModel> markCircleJoinRequestPaid(String requestId);
  Future<bool> leaveCircle(String circleId);
}

class CirclesRemoteDataSourceImpl implements CirclesRemoteDataSource {
  final DioClient dioClient;

  CirclesRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<List<CircleModel>> getMyCircles() async {
    final response = await dioClient.dio.get(ApiEndpoints.myCircles);
    final data = response.data;
    List<dynamic> list = [];
    if (data is List) {
      list = data;
    } else if (data is Map<String, dynamic>) {
      if (data['data'] is List) {
        list = data['data'] as List;
      } else if (data['data'] is Map<String, dynamic>) {
        final nested = data['data'] as Map<String, dynamic>;
        if (nested['items'] is List) {
          list = nested['items'] as List;
        } else if (nested['circles'] is List) {
          list = nested['circles'] as List;
        }
      } else if (data['items'] is List) {
        list = data['items'] as List;
      } else if (data['circles'] is List) {
        list = data['circles'] as List;
      }
    }
    return list
        .whereType<Map<String, dynamic>>()
        .map((json) => CircleModel.fromJson(json))
        .toList();
  }

  @override
  Future<List<CircleModel>> getJoinedCircles() async {
    final response = await dioClient.dio.get(ApiEndpoints.joinedCircles);
    final data = response.data;
    List<dynamic> list = [];
    if (data is List) {
      list = data;
    } else if (data is Map<String, dynamic>) {
      if (data['data'] is List) {
        list = data['data'] as List;
      } else if (data['data'] is Map<String, dynamic>) {
        final nested = data['data'] as Map<String, dynamic>;
        list = nested['items'] ?? nested['circles'] ?? [];
      } else if (data['items'] is List) {
        list = data['items'] as List;
      } else if (data['circles'] is List) {
        list = data['circles'] as List;
      }
    }
    return list
        .whereType<Map<String, dynamic>>()
        .map((json) => CircleModel.fromJson(json))
        .toList();
  }

  @override
  Future<CirclePackageModel> getCirclePackage(String circleId) async {
    final response = await dioClient.dio.get(
      ApiEndpoints.circlePackage(circleId),
    );
    final data = response.data;
    if (data is Map<String, dynamic>) {
      final json = data['data'] is Map<String, dynamic>
          ? data['data'] as Map<String, dynamic>
          : data;
      return CirclePackageModel.fromJson(json);
    }
    throw Exception('Failed to load circle package');
  }

  @override
  Future<List<CircleCategoryModel>> getCircleCategories() async {
    final response = await dioClient.dio.get(ApiEndpoints.circleCategories);
    final data = response.data;
    List<dynamic> list = [];
    if (data is List) {
      list = data;
    } else if (data is Map<String, dynamic>) {
      if (data['data'] is List) {
        list = data['data'] as List;
      } else if (data['data'] is Map<String, dynamic>) {
        final nested = data['data'] as Map<String, dynamic>;
        if (nested['items'] is List) {
          list = nested['items'] as List;
        } else if (nested['categories'] is List) {
          list = nested['categories'] as List;
        }
      } else if (data['items'] is List) {
        list = data['items'] as List;
      } else if (data['categories'] is List) {
        list = data['categories'] as List;
      }
    }
    return list
        .whereType<Map<String, dynamic>>()
        .map((json) => CircleCategoryModel.fromJson(json))
        .toList();
  }

  @override
  Future<CircleModel> getCircleDetail(String id) async {
    final response = await dioClient.dio.get(ApiEndpoints.circleDetail(id));
    final data = response.data;
    if (data is Map<String, dynamic>) {
      final circleJson = data['data'] is Map<String, dynamic>
          ? data['data'] as Map<String, dynamic>
          : data;
      return CircleModel.fromJson(circleJson);
    }
    throw Exception('Invalid circle detail response format');
  }

  @override
  Future<List<CircleMemberModel>> getCircleMembers(String circleId) async {
    final response = await dioClient.dio.get(
      ApiEndpoints.circleMembers(circleId),
    );
    final data = response.data;
    List<dynamic> list = [];
    if (data is List) {
      list = data;
    } else if (data is Map<String, dynamic>) {
      if (data['data'] is List) {
        list = data['data'] as List;
      } else if (data['members'] is List) {
        list = data['members'] as List;
      } else if (data['items'] is List) {
        list = data['items'] as List;
      }
    }
    return list
        .whereType<Map<String, dynamic>>()
        .map((json) => CircleMemberModel.fromJson(json))
        .toList();
  }

  @override
  Future<List<CircleCategoryModel>> getCategorySubcategories(
    String categoryId,
  ) async {
    final response = await dioClient.dio.get(
      '${ApiEndpoints.circleCategories}/$categoryId',
    );
    final data = response.data;
    List<dynamic> list = [];
    if (data is Map<String, dynamic>) {
      if (data['data'] is Map<String, dynamic>) {
        final nested = data['data'] as Map<String, dynamic>;
        list =
            nested['level4_categories'] ??
            nested['categories'] ??
            nested['items'] ??
            [];
      } else if (data['data'] is List) {
        list = data['data'] as List;
      } else if (data['level4_categories'] is List) {
        list = data['level4_categories'] as List;
      }
    } else if (data is List) {
      list = data;
    }
    return list
        .whereType<Map<String, dynamic>>()
        .map((json) => CircleCategoryModel.fromJson(json))
        .toList();
  }

  @override
  Future<List<CircleOpenCategoryModel>> getCircleOpenCategories(
    String circleId,
  ) async {
    final response = await dioClient.dio.get(
      ApiEndpoints.circleOpenCategories(circleId),
    );
    final data = response.data;
    List<dynamic> list = [];
    if (data is Map<String, dynamic>) {
      if (data['data'] is Map<String, dynamic>) {
        final nested = data['data'] as Map<String, dynamic>;
        list =
            nested['open_categories'] ??
            nested['categories'] ??
            nested['items'] ??
            [];
      } else if (data['data'] is List) {
        list = data['data'] as List;
      } else if (data['open_categories'] is List) {
        list = data['open_categories'] as List;
      }
    } else if (data is List) {
      list = data;
    }
    return list
        .whereType<Map<String, dynamic>>()
        .map((json) => CircleOpenCategoryModel.fromJson(json))
        .toList();
  }

  @override
  Future<List<CircleClosedCategoryModel>> getCircleClosedCategories(
    String circleId,
  ) async {
    final response = await dioClient.dio.get(
      ApiEndpoints.circleClosedCategories(circleId),
    );
    final data = response.data;
    List<dynamic> list = [];
    if (data is Map<String, dynamic>) {
      if (data['data'] is Map<String, dynamic>) {
        final nested = data['data'] as Map<String, dynamic>;
        list =
            nested['closed_categories'] ??
            nested['categories'] ??
            nested['items'] ??
            [];
      } else if (data['data'] is List) {
        list = data['data'] as List;
      } else if (data['closed_categories'] is List) {
        list = data['closed_categories'] as List;
      }
    } else if (data is List) {
      list = data;
    }
    return list
        .whereType<Map<String, dynamic>>()
        .map((json) => CircleClosedCategoryModel.fromJson(json))
        .toList();
  }

  @override
  Future<CircleJoinRequestModel> submitJoinRequest({
    required String circleId,
    required String reason,
    dynamic categoryId,
    dynamic level4CategoryId,
    bool isOtherCategory = false,
    String? customCategoryName,
  }) async {
    final cleanCircleId = circleId.trim();
    final isCircleUuid = RegExp(
      r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
    ).hasMatch(cleanCircleId);

    dynamic parsedCatId = categoryId;
    if (parsedCatId is String) {
      parsedCatId = int.tryParse(parsedCatId) ?? parsedCatId;
    }

    dynamic parsedL4 = level4CategoryId;
    if (parsedL4 is String) {
      parsedL4 = int.tryParse(parsedL4) ?? parsedL4;
    }

    dynamic effectiveCatId = parsedCatId;
    if (effectiveCatId == null && !isCircleUuid && cleanCircleId.isNotEmpty) {
      effectiveCatId = int.tryParse(cleanCircleId) ?? cleanCircleId;
    }

    final body = <String, dynamic>{
      'reason_for_joining': reason,
      'reason': reason,
      'subject': reason.length > 50 ? '${reason.substring(0, 47)}...' : reason,
      'description': reason,
    };

    if (effectiveCatId != null) {
      body['category_id'] = effectiveCatId;
      body['level1_category_id'] = effectiveCatId;
    }

    if (parsedL4 != null) {
      body['level4_category_id'] = parsedL4;
      if (body['category_id'] == null) {
        body['category_id'] = parsedL4;
      }
    }

    if (isOtherCategory) {
      body['is_other_category'] = true;
      if (customCategoryName != null && customCategoryName.trim().isNotEmpty) {
        body['other_category_name'] = customCategoryName.trim();
        body['custom_category_name'] = customCategoryName.trim();
      }
    }

    if (isCircleUuid) {
      body['circle_id'] = cleanCircleId;
    }

    final response = await dioClient.dio.post(
      ApiEndpoints.circleJoinRequests,
      data: body,
    );
    final data = response.data;
    if (data is Map<String, dynamic>) {
      final json = data['data'] is Map<String, dynamic> ? data['data'] : data;
      return CircleJoinRequestModel.fromJson(json as Map<String, dynamic>);
    }
    throw Exception('Failed to submit join request');
  }

  @override
  Future<List<CircleJoinRequestModel>> getMyJoinRequests() async {
    final response = await dioClient.dio.get(ApiEndpoints.myCircleJoinRequests);
    final data = response.data;
    List<dynamic> list = [];
    if (data is List) {
      list = data;
    } else if (data is Map<String, dynamic>) {
      if (data['data'] is List) {
        list = data['data'] as List;
      } else if (data['data'] is Map<String, dynamic>) {
        final nested = data['data'] as Map<String, dynamic>;
        list = nested['items'] ?? [];
      } else if (data['items'] is List) {
        list = data['items'] as List;
      }
    }
    return list
        .whereType<Map<String, dynamic>>()
        .map((json) => CircleJoinRequestModel.fromJson(json))
        .toList();
  }

  @override
  Future<CircleJoinRequestModel> getCircleJoinRequestStatus(
    String requestId,
  ) async {
    final response = await dioClient.dio.get(
      ApiEndpoints.circleJoinRequestStatus(requestId),
    );
    final data = response.data;
    if (data is Map<String, dynamic>) {
      final json = data['data'] is Map<String, dynamic> ? data['data'] : data;
      return CircleJoinRequestModel.fromJson(json as Map<String, dynamic>);
    }
    throw Exception('Failed to check join request status');
  }

  @override
  Future<bool> cancelCircleJoinRequest(String requestId) async {
    try {
      final response = await dioClient.dio.delete(
        ApiEndpoints.cancelCircleJoinRequest(requestId),
      );
      if (response.statusCode == 200 || response.statusCode == 204) return true;
    } catch (e) {
      try {
        final postResp = await dioClient.dio.post(
          '/circle-join-requests/$requestId/cancel',
        );
        if (postResp.statusCode == 200 ||
            postResp.statusCode == 201 ||
            postResp.statusCode == 204) {
          return true;
        }
      } catch (_) {
        try {
          final postResp2 = await dioClient.dio.post(
            '/circle-join-requests/cancel',
            data: {'request_id': requestId, 'id': requestId},
          );
          if (postResp2.statusCode == 200 ||
              postResp2.statusCode == 201 ||
              postResp2.statusCode == 204) {
            return true;
          }
        } catch (_) {
          rethrow;
        }
      }
    }
    return true;
  }

  @override
  Future<String> getCircleCheckoutUrl(String circleId) async {
    final response = await dioClient.dio.post(
      ApiEndpoints.circleCheckout(circleId),
      data: <String, dynamic>{},
    );
    final data = response.data;
    if (data is Map<String, dynamic>) {
      final nested = data['data'] is Map<String, dynamic>
          ? data['data'] as Map<String, dynamic>
          : data;
      final checkoutUrl =
          nested['checkout_url']?.toString() ??
          nested['payment_url']?.toString() ??
          nested['url']?.toString();
      if (checkoutUrl != null && checkoutUrl.isNotEmpty) {
        return checkoutUrl;
      }
    }
    throw Exception('Failed to generate circle checkout URL');
  }

  @override
  Future<CircleJoinRequestModel> markCircleJoinRequestPaid(
    String requestId,
  ) async {
    try {
      final response = await dioClient.dio.patch(
        ApiEndpoints.circleJoinRequestMarkPaid(requestId),
        data: <String, dynamic>{},
      );
      final data = response.data;
      if (data is Map<String, dynamic>) {
        final json = data['data'] is Map<String, dynamic> ? data['data'] : data;
        return CircleJoinRequestModel.fromJson(json as Map<String, dynamic>);
      }
    } catch (_) {
      try {
        final response2 = await dioClient.dio.post(
          ApiEndpoints.circleJoinRequestMarkPaid(requestId),
          data: <String, dynamic>{},
        );
        final data2 = response2.data;
        if (data2 is Map<String, dynamic>) {
          final json2 =
              data2['data'] is Map<String, dynamic> ? data2['data'] : data2;
          return CircleJoinRequestModel.fromJson(json2 as Map<String, dynamic>);
        }
      } catch (_) {
        rethrow;
      }
    }
    throw Exception('Failed to mark join request as paid');
  }

  @override
  Future<bool> leaveCircle(String circleId) async {
    final response = await dioClient.dio.post(
      ApiEndpoints.leaveCircle(circleId),
      data: <String, dynamic>{},
    );
    return response.statusCode == 200 ||
        response.statusCode == 201 ||
        response.statusCode == 204;
  }
}
