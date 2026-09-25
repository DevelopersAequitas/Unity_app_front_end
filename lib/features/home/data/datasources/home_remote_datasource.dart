import 'dart:io';
import 'package:dio/dio.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../core/network/dio_client.dart';
import '../models/brand_partner_model.dart';
import '../models/post_comment_model.dart';
import '../models/post_like_model.dart';
import '../models/timeline_feed_response_model.dart';
import '../../domain/entities/post_report_reason_entity.dart';

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

  Future<List<PostLikeModel>> getPostLikes(String postId, {int page = 1});

  Future<List<PostCommentModel>> getPostComments(String postId, {int page = 1});

  Future<PostCommentModel> addPostComment(String postId, String content);

  Future<String> uploadFile(File file, {void Function(double progress)? onProgress});

  Future<void> createPost({
    required String contentText,
    String visibility = 'public',
    List<Map<String, String>> media = const [],
    List<Map<String, dynamic>> mentions = const [],
  });

  Future<void> deletePost(String postId);

  Future<void> updatePost(String postId, {required String contentText});

  Future<List<PostReportReasonEntity>> getPostReportReasons();

  Future<void> reportPost(String postId, int reasonId);
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

  @override
  Future<List<PostLikeModel>> getPostLikes(String postId, {int page = 1}) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.postLikes(postId),
        queryParameters: {'page': page},
      );
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300 &&
          response.data != null) {
        final data = response.data;
        List? rawList;
        if (data is Map<String, dynamic>) {
          final inner = data['data'];
          if (inner is List) {
            rawList = inner;
          } else if (inner is Map<String, dynamic>) {
            rawList = (inner['items'] ?? inner['likes'] ?? inner['data']) as List?;
          } else if (data['items'] is List) {
            rawList = data['items'] as List?;
          } else if (data['likes'] is List) {
            rawList = data['likes'] as List?;
          }
        } else if (data is List) {
          rawList = data;
        }
        if (rawList != null) {
          return rawList
              .whereType<Map<String, dynamic>>()
              .map((e) => PostLikeModel.fromJson(e))
              .toList();
        }
      }
      return const [];
    } catch (_) {
      return const [];
    }
  }

  @override
  Future<List<PostCommentModel>> getPostComments(String postId, {int page = 1}) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.postComments(postId),
        queryParameters: {'page': page},
      );
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300 &&
          response.data != null) {
        final data = response.data;
        List? rawList;
        if (data is Map<String, dynamic>) {
          final inner = data['data'];
          if (inner is List) {
            rawList = inner;
          } else if (inner is Map<String, dynamic>) {
            rawList = (inner['items'] ?? inner['comments'] ?? inner['data']) as List?;
          } else if (data['items'] is List) {
            rawList = data['items'] as List?;
          } else if (data['comments'] is List) {
            rawList = data['comments'] as List?;
          }
        } else if (data is List) {
          rawList = data;
        }
        if (rawList != null) {
          return rawList
              .whereType<Map<String, dynamic>>()
              .map((e) => PostCommentModel.fromJson(e))
              .toList();
        }
      }
      return const [];
    } catch (_) {
      return const [];
    }
  }

  @override
  Future<PostCommentModel> addPostComment(String postId, String content) async {
    final response = await _dio.post(
      ApiEndpoints.postComments(postId),
      data: {'content': content},
    );
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300 &&
        response.data != null) {
      final data = response.data;
      Map<String, dynamic>? commentMap;
      if (data is Map<String, dynamic>) {
        final inner = data['data'];
        if (inner is Map<String, dynamic>) {
          commentMap = inner;
        } else {
          commentMap = data;
        }
      }
      if (commentMap != null) {
        return PostCommentModel.fromJson(commentMap);
      }
    }
    return PostCommentModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: '',
      displayName: 'You',
      content: content,
      createdAt: DateTime.now().toIso8601String(),
    );
  }

  @override
  Future<String> uploadFile(File file, {void Function(double progress)? onProgress}) async {
    try {
      final fileName = file.path.split(RegExp(r'[/\\]')).last;
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          file.path,
          filename: fileName,
        ),
      });

      final response = await _dio.post(
        ApiEndpoints.fileUpload,
        data: formData,
        options: Options(
          sendTimeout: const Duration(minutes: 5),
          receiveTimeout: const Duration(minutes: 5),
        ),
        onSendProgress: (sent, total) {
          if (total > 0 && onProgress != null) {
            onProgress(sent / total);
          }
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        if (data is Map<String, dynamic>) {
          final fileId = data['data']?['id'] ?? data['id'] ?? data['file_id'] ?? data['data']?['file_id'];
          if (fileId != null) {
            return fileId.toString();
          }
        }
        throw const ApiException(message: 'File uploaded but ID missing');
      }
      throw ApiException(
        message: response.statusMessage ?? 'Failed to upload file',
        statusCode: response.statusCode,
      );
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(message: e.toString());
    }
  }

  @override
  Future<void> createPost({
    required String contentText,
    String visibility = 'public',
    List<Map<String, String>> media = const [],
    List<Map<String, dynamic>> mentions = const [],
  }) async {
    final payload = <String, dynamic>{
      'content_text': contentText,
      'visibility': visibility,
    };
    if (media.isNotEmpty) {
      payload['media'] = media;
    }
    if (mentions.isNotEmpty) {
      payload['mentions'] = mentions;
      payload['tagged_peer_ids'] = mentions.map((m) => m['id']).whereType<String>().toList();
    }

    final response = await _dio.post(
      ApiEndpoints.createPost,
      data: payload,
    );

    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return;
    }
    throw ApiException(
      message: response.statusMessage ?? 'Failed to create post',
      statusCode: response.statusCode,
    );
  }

  @override
  Future<void> deletePost(String postId) async {
    try {
      final response = await _dio.delete(ApiEndpoints.postDetail(postId));
      if (response.statusCode != null &&
          ((response.statusCode! >= 200 && response.statusCode! < 300) ||
              response.statusCode == 404)) {
        return;
      }
      throw ApiException(
        message: response.statusMessage ?? 'Failed to delete post',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return;
      }
      rethrow;
    }
  }

  @override
  Future<void> updatePost(String postId, {required String contentText}) async {
    final response = await _dio.put(
      ApiEndpoints.postDetail(postId),
      data: {'content_text': contentText},
    );
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return;
    }
    throw ApiException(
      message: response.statusMessage ?? 'Failed to update post',
      statusCode: response.statusCode,
    );
  }

  @override
  Future<List<PostReportReasonEntity>> getPostReportReasons() async {
    try {
      final response = await _dio.get(ApiEndpoints.postReportReasons);
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300 &&
          response.data != null) {
        final data = response.data;
        List? rawList;
        if (data is Map<String, dynamic>) {
          final inner = data['data'];
          if (inner is Map<String, dynamic>) {
            rawList = inner['items'] as List?;
          } else if (inner is List) {
            rawList = inner;
          } else if (data['items'] is List) {
            rawList = data['items'] as List?;
          }
        } else if (data is List) {
          rawList = data;
        }
        if (rawList != null) {
          return rawList
              .whereType<Map<String, dynamic>>()
              .map((e) => PostReportReasonEntity.fromJson(e))
              .toList();
        }
      }
      return const [];
    } catch (_) {
      return const [];
    }
  }

  @override
  Future<void> reportPost(String postId, int reasonId) async {
    final response = await _dio.post(
      ApiEndpoints.postReport(postId),
      data: {'reason_id': reasonId},
    );
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return;
    }
    throw ApiException(
      message: response.statusMessage ?? 'Failed to report post',
      statusCode: response.statusCode,
    );
  }
}
