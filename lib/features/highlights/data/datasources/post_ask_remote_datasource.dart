import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../models/post_ask_model.dart';

abstract class PostAskRemoteDataSource {
  Future<List<PostAskModel>> getMyAsks();
  Future<String> submitAsk(PostAskModel model);
  Future<void> completeAsk(String id, {String? subject});
}

class PostAskRemoteDataSourceImpl implements PostAskRemoteDataSource {
  final DioClient dioClient;

  const PostAskRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<List<PostAskModel>> getMyAsks() async {
    final endpoints = [
      ApiEndpoints.myRequirements,
      ApiEndpoints.activitiesRequirements,
      '/timeline/requirements',
      ApiEndpoints.incompletedRequirements,
    ];

    for (final endpoint in endpoints) {
      try {
        final response = await dioClient.dio.get(endpoint);
        final data = response.data;
        final list = _parseList(data);
        if (list.isNotEmpty) return list;
      } on DioException catch (e) {
        if (e.response?.statusCode != 404) {
          debugPrint('getMyAsks endpoint $endpoint failed: $e');
        }
      } catch (e) {
        debugPrint('getMyAsks parse error: $e');
      }
    }
    return [];
  }

  List<PostAskModel> _parseList(dynamic data) {
    final list = <PostAskModel>[];
    dynamic itemsData = data;
    if (data is Map<String, dynamic>) {
      itemsData = data['data'] ?? data['items'] ?? data['requirements'] ?? data;
    }

    if (itemsData is List) {
      for (final item in itemsData) {
        if (item is Map<String, dynamic>) {
          list.add(PostAskModel.fromJson(item));
        }
      }
    } else if (itemsData is Map<String, dynamic>) {
      final inner = itemsData['items'] ?? itemsData['requirements'] ?? itemsData['data'];
      if (inner is List) {
        for (final item in inner) {
          if (item is Map<String, dynamic>) {
            list.add(PostAskModel.fromJson(item));
          }
        }
      }
    }
    return list;
  }

  @override
  Future<String> submitAsk(PostAskModel model) async {
    try {
      final response = await dioClient.dio.post(
        ApiEndpoints.activitiesRequirements,
        data: model.toJson(),
      );

      if (response.data is Map<String, dynamic>) {
        final msg = response.data['message']?.toString();
        if (msg != null && msg.isNotEmpty) return msg;
      }
      return 'Your Ask has been submitted successfully!';
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        // Fallback post endpoint
        final fallbackResponse = await dioClient.dio.post(
          ApiEndpoints.createPost,
          data: {
            'title': model.subject,
            'content': model.description,
            'category': model.category,
            'post_type': 'requirement',
            if (model.mediaId != null) 'media_id': model.mediaId,
          },
        );
        if (fallbackResponse.data is Map<String, dynamic>) {
          return fallbackResponse.data['message']?.toString() ??
              'Your Ask has been submitted successfully!';
        }
      }
      rethrow;
    }
  }

  @override
  Future<void> completeAsk(String id, {String? subject}) async {
    try {
      await dioClient.dio.patch(
        ApiEndpoints.closeRequirement(id),
        data: {'status': 'completed'},
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        await dioClient.dio.patch(
          '${ApiEndpoints.activitiesRequirements}/$id',
          data: {'status': 'completed'},
        );
      } else {
        rethrow;
      }
    }
  }
}
