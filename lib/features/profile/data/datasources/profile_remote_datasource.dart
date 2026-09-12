import 'dart:io';
import 'package:dio/dio.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../core/network/dio_client.dart';
import '../../../home/data/models/timeline_item_model.dart';
import '../../../home/domain/entities/timeline_item_entity.dart';
import '../models/profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileModel> getProfile();
  Future<ProfileModel> updateProfile(Map<String, dynamic> data);
  Future<List<TimelineItemEntity>> getUserPosts({int page = 1});
  Future<String> uploadFile(File file, {void Function(double progress)? onProgress});
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final DioClient dioClient;

  ProfileRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<ProfileModel> getProfile() async {
    try {
      final response = await dioClient.dio.get(ApiEndpoints.profile);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        if (data is Map<String, dynamic>) {
          return ProfileModel.fromJson(data);
        }
        throw const ApiException(message: 'Invalid profile response format');
      }
      throw ApiException(
        message: 'Failed to fetch profile',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      if (e.error is ApiException) {
        throw e.error as ApiException;
      }
      throw ApiException(message: e.message ?? 'Failed to fetch profile');
    }
  }

  @override
  Future<ProfileModel> updateProfile(Map<String, dynamic> data) async {
    try {
      final response = await dioClient.dio.put(
        ApiEndpoints.profile,
        data: data,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final respData = response.data;
        if (respData is Map<String, dynamic>) {
          if (respData.containsKey('data') && respData['data'] is Map<String, dynamic>) {
            return ProfileModel.fromJson(respData);
          }
          return await getProfile();
        }
        return await getProfile();
      }
      throw ApiException(
        message: 'Failed to update profile',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      if (e.error is ApiException) {
        throw e.error as ApiException;
      }
      throw ApiException(message: e.message ?? 'Failed to update profile');
    }
  }

  @override
  Future<List<TimelineItemEntity>> getUserPosts({int page = 1}) async {
    try {
      final response = await dioClient.dio.get(
        ApiEndpoints.profilePosts,
        queryParameters: {'page': page},
      );
      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map<String, dynamic>) {
          final items = data['data']?['items'] ?? data['items'] ?? data['data'];
          if (items is List) {
            return items
                .whereType<Map<String, dynamic>>()
                .map((json) => TimelineItemModel.fromJson(json).toEntity())
                .toList();
          }
        }
        return [];
      }
      return [];
    } on DioException catch (_) {
      return [];
    }
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

      final response = await dioClient.dio.post(
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
        message: 'Failed to upload file',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      if (e.error is ApiException) {
        throw e.error as ApiException;
      }
      throw ApiException(message: e.message ?? 'Failed to upload file');
    }
  }
}
