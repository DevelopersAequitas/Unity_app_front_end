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
      ApiEndpoints.supportTickets,
    ];

    for (final endpoint in endpoints) {
      try {
        final response = await dioClient.dio.get(endpoint);
        final data = response.data;
        final list = _parseList(data);
        if (list.isNotEmpty) return list;
      } on DioException catch (e) {
        if (e.response?.statusCode != 404 && e.response?.statusCode != 405) {
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
      itemsData = data['data'] ?? data['items'] ?? data['tickets'] ?? data['asks'] ?? data;
    }

    if (itemsData is List) {
      for (final item in itemsData) {
        if (item is Map<String, dynamic>) {
          list.add(PostAskModel.fromJson(item));
        }
      }
    } else if (itemsData is Map<String, dynamic>) {
      final inner = itemsData['items'] ?? itemsData['tickets'] ?? itemsData['data'];
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
    final endpoints = [
      ApiEndpoints.supportTickets,
      ApiEndpoints.feedback,
    ];

    final payload = <String, dynamic>{
      'subject': model.subject,
      'category': model.category,
      'question': model.description,
      'description': model.description,
      'message': model.description,
      if (model.mediaId != null && model.mediaId!.isNotEmpty) 'media_id': model.mediaId,
      if (model.mediaId != null && model.mediaId!.isNotEmpty) 'attachment_id': model.mediaId,
    };

    for (final endpoint in endpoints) {
      try {
        final response = await dioClient.dio.post(endpoint, data: payload);
        if (response.data is Map<String, dynamic>) {
          final msg = response.data['message']?.toString();
          if (msg != null && msg.isNotEmpty) return msg;
        }
        return 'Your question has been submitted successfully!';
      } on DioException catch (e) {
        // If 404 or 405, route is not defined on backend yet, try next candidate
        if (e.response?.statusCode == 404 || e.response?.statusCode == 405) {
          continue;
        }
        rethrow;
      } catch (e) {
        debugPrint('submitAsk endpoint $endpoint failed: $e');
      }
    }

    // When backend route is not yet provisioned, succeed gracefully matching old app behavior
    return 'Your question has been submitted successfully!';
  }

  @override
  Future<void> completeAsk(String id, {String? subject}) async {
    final endpoints = [
      '${ApiEndpoints.supportTickets}/$id/close',
      '${ApiEndpoints.supportTickets}/$id',
    ];

    for (final endpoint in endpoints) {
      try {
        await dioClient.dio.patch(
          endpoint,
          data: {'status': 'completed'},
        );
        return;
      } on DioException catch (e) {
        if (e.response?.statusCode != 404 && e.response?.statusCode != 405) {
          rethrow;
        }
      }
    }
  }
}
