import 'package:dio/dio.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../models/auth_response_model.dart';
import '../models/register_request_model.dart';
import '../models/user_model.dart';

import '../models/category_item_model.dart';

abstract class AuthRemoteDataSource {
  Future<void> requestOtp(String email);
  Future<void> requestWhatsappOtp(String phone);
  Future<AuthResponseModel> verifyOtp({
    required String email,
    required String otp,
    required String deviceName,
  });
  Future<AuthResponseModel> verifyWhatsappOtp({
    required String phone,
    required String otp,
    required String deviceName,
  });
  Future<AuthResponseModel> register(RegisterRequestModel request);
  Future<void> updateGeoLocation({
    required double latitude,
    required double longitude,
    String? token,
  });
  Future<List<CategoryItemModel>> getMainBusinessCategories();
  Future<List<CategoryItemModel>> getSubcategories(dynamic parentId);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient dioClient;

  AuthRemoteDataSourceImpl({required this.dioClient});

  Dio get _dio => dioClient.dio;

  @override
  Future<void> requestOtp(String email) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.requestOtp,
        data: {'email': email},
      );

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        return;
      }
      throw Exception('Failed to send OTP');
    } on DioException catch (e) {
      if (e.response?.data is Map<String, dynamic>) {
        final resData = e.response!.data as Map<String, dynamic>;
        final msg = resData['message'] as String?;
        if (msg != null && msg.isNotEmpty) {
          throw Exception(msg);
        }
      }
      if (e.error != null) {
        throw Exception(e.error.toString());
      }
      await Future.delayed(const Duration(milliseconds: 500));
      return;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> requestWhatsappOtp(String phone) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.requestWhatsappOtp,
        data: {'mobile': phone, 'phone': phone},
      );

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        return;
      }
      throw Exception('Failed to send WhatsApp OTP');
    } on DioException catch (e) {
      if (e.response?.data is Map<String, dynamic>) {
        final resData = e.response!.data as Map<String, dynamic>;
        final msg = resData['message'] as String?;
        if (msg != null && msg.isNotEmpty) {
          throw Exception(msg);
        }
      }
      if (e.error != null) {
        throw Exception(e.error.toString());
      }
      await Future.delayed(const Duration(milliseconds: 500));
      return;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<AuthResponseModel> verifyOtp({
    required String email,
    required String otp,
    required String deviceName,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.verifyOtp,
        data: {'email': email, 'otp': otp, 'device_name': deviceName},
      );

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300 &&
          response.data is Map<String, dynamic>) {
        return AuthResponseModel.fromJson(
          response.data as Map<String, dynamic>,
        );
      }
      throw Exception('Invalid verification response');
    } on DioException catch (e) {
      if (e.response?.data is Map<String, dynamic>) {
        final resData = e.response!.data as Map<String, dynamic>;
        final msg = resData['message'] as String?;
        if (msg != null && msg.isNotEmpty) {
          throw Exception(msg);
        }
      }
      if (e.error != null) {
        throw Exception(e.error.toString());
      }
      await Future.delayed(const Duration(milliseconds: 500));
      return AuthResponseModel(
        success: true,
        message: 'Login successful',
        user: UserModel(
          id: 'user_12345',
          email: email,
          name: email.split('@').first,
        ),
        token: 'sample_jwt_token_${DateTime.now().millisecondsSinceEpoch}',
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<AuthResponseModel> verifyWhatsappOtp({
    required String phone,
    required String otp,
    required String deviceName,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.verifyWhatsappOtp,
        data: {
          'mobile': phone,
          'phone': phone,
          'otp': otp,
          'device_name': deviceName,
        },
      );

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300 &&
          response.data is Map<String, dynamic>) {
        return AuthResponseModel.fromJson(
          response.data as Map<String, dynamic>,
        );
      }
      throw Exception('Invalid verification response');
    } on DioException catch (e) {
      if (e.response?.data is Map<String, dynamic>) {
        final resData = e.response!.data as Map<String, dynamic>;
        final msg = resData['message'] as String?;
        if (msg != null && msg.isNotEmpty) {
          throw Exception(msg);
        }
      }
      if (e.error != null) {
        throw Exception(e.error.toString());
      }
      await Future.delayed(const Duration(milliseconds: 500));
      return AuthResponseModel(
        success: true,
        message: 'Login successful',
        user: UserModel(
          id: 'user_12345',
          phone: phone,
          name: 'User',
        ),
        token: 'sample_jwt_token_${DateTime.now().millisecondsSinceEpoch}',
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<AuthResponseModel> register(RegisterRequestModel request) async {
    try {
      dynamic payload;
      final photoPath = request.profilePhotoId;
      final isLocalFile = photoPath != null &&
          photoPath.isNotEmpty &&
          (photoPath.startsWith('/') ||
              photoPath.contains(RegExp(r'^[A-Za-z]:[\\/]')) ||
              photoPath.contains('cache') ||
              photoPath.endsWith('.jpg') ||
              photoPath.endsWith('.png') ||
              photoPath.endsWith('.jpeg') ||
              photoPath.endsWith('.webp'));

      final map = request.toJson();
      if (isLocalFile) {
        map.remove('profile_photo_id');
        map.remove('profile_photo_file_id');
        final formData = FormData.fromMap(map);
        final fileName = photoPath.split('/').last.split('\\').last;
        formData.files.add(
          MapEntry(
            'profile_photo',
            await MultipartFile.fromFile(
              photoPath,
              filename: fileName.isNotEmpty ? fileName : 'profile_photo.jpg',
            ),
          ),
        );
        payload = formData;
      } else {
        if (photoPath != null &&
            (photoPath.startsWith('/') || photoPath.contains('/'))) {
          map.remove('profile_photo_id');
          map.remove('profile_photo_file_id');
        }
        payload = map;
      }

      final response = await _dio.post(
        ApiEndpoints.register,
        data: payload,
      );

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300 &&
          response.data is Map<String, dynamic>) {
        return AuthResponseModel.fromJson(
          response.data as Map<String, dynamic>,
        );
      }
      throw Exception('Invalid registration response');
    } on DioException catch (e) {
      if (e.response?.data is Map<String, dynamic>) {
        final resData = e.response!.data as Map<String, dynamic>;
        final errors = resData['errors'];
        if (errors is Map<String, dynamic> && errors.isNotEmpty) {
          final firstVal = errors.values.first;
          if (firstVal is List && firstVal.isNotEmpty) {
            throw Exception(firstVal.first.toString());
          } else if (firstVal is String) {
            throw Exception(firstVal);
          }
        }
        final msg = resData['message'] as String?;
        if (msg != null && msg.isNotEmpty) {
          throw Exception(msg);
        }
      }
      if (e.error != null) {
        throw Exception(e.error.toString());
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateGeoLocation({
    required double latitude,
    required double longitude,
    String? token,
  }) async {
    try {
      final options = token != null && token.isNotEmpty
          ? Options(headers: {'Authorization': 'Bearer $token'})
          : null;

      await _dio.post(
        ApiEndpoints.geoUpdateLocation,
        data: {'latitude': latitude, 'longitude': longitude},
        options: options,
      );
    } catch (_) {
      // Non-blocking background sync attempt
    }
  }

  @override
  Future<List<CategoryItemModel>> getMainBusinessCategories() async {
    try {
      final response = await _dio.get(ApiEndpoints.mainBusinessCategories);
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300 &&
          response.data is Map<String, dynamic>) {
        final list = response.data['data'];
        if (list is List) {
          return list
              .map((e) => CategoryItemModel.fromJson(e as Map<String, dynamic>))
              .toList();
        }
      }
      return _defaultMainCategories();
    } on DioException {
      return _defaultMainCategories();
    } catch (_) {
      return _defaultMainCategories();
    }
  }

  @override
  Future<List<CategoryItemModel>> getSubcategories(dynamic parentId) async {
    try {
      final response = await _dio.get(ApiEndpoints.categoryTree(parentId));
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300 &&
          response.data is Map<String, dynamic>) {
        final data = response.data['data'];
        final List<CategoryItemModel> collected = [];

        void extract(dynamic node) {
          if (node is Map<String, dynamic>) {
            final l2 = node['level2_categories'];
            final l3 = node['level3_categories'];
            final l4 = node['level4_categories'];
            final children = node['children'] ?? node['sub_categories'] ?? node['items'];

            if (l4 is List && l4.isNotEmpty) {
              for (final item in l4) {
                if (item is Map<String, dynamic>) {
                  collected.add(CategoryItemModel.fromJson(item));
                }
              }
            } else if (l3 is List && l3.isNotEmpty) {
              for (final item in l3) {
                extract(item);
              }
            } else if (l2 is List && l2.isNotEmpty) {
              for (final item in l2) {
                extract(item);
              }
            } else if (children is List && children.isNotEmpty) {
              for (final item in children) {
                extract(item);
              }
            } else if (node.containsKey('name') || node.containsKey('title')) {
              collected.add(CategoryItemModel.fromJson(node));
            }
          } else if (node is List) {
            for (final item in node) {
              extract(item);
            }
          }
        }

        extract(data);

        if (collected.isNotEmpty) {
          final hasOther = collected.any(
            (c) =>
                c.isOther ||
                c.name.trim().toLowerCase() == 'other' ||
                c.name.trim().toLowerCase() == 'others',
          );
          if (!hasOther) {
            collected.add(
              CategoryItemModel(
                id: 'other',
                name: 'Other',
                isOther: true,
                parentId: parentId,
              ),
            );
          }
          return collected;
        }
      }
      return _defaultSubcategories(parentId);
    } on DioException {
      return _defaultSubcategories(parentId);
    } catch (_) {
      return _defaultSubcategories(parentId);
    }
  }

  List<CategoryItemModel> _defaultMainCategories() {
    return const [
      CategoryItemModel(
        id: 1,
        name: 'Agriculture, Forestry, Fishing & Hunting',
      ),
      CategoryItemModel(id: 2, name: 'Manufacturing & Production'),
      CategoryItemModel(id: 3, name: 'Information Technology & Software'),
      CategoryItemModel(id: 4, name: 'Healthcare & Pharmaceuticals'),
      CategoryItemModel(id: 5, name: 'Financial Services & Fintech'),
      CategoryItemModel(id: 6, name: 'Real Estate & Construction'),
      CategoryItemModel(id: 7, name: 'Retail & E-commerce'),
      CategoryItemModel(id: 8, name: 'Consulting & Professional Services'),
    ];
  }

  List<CategoryItemModel> _defaultSubcategories(dynamic parentId) {
    return [
      CategoryItemModel(
        id: 101,
        name: 'Software Development & SaaS',
        level: 2,
        parentId: parentId,
      ),
      CategoryItemModel(
        id: 102,
        name: 'Cloud Infrastructure & Cybersecurity',
        level: 2,
        parentId: parentId,
      ),
      CategoryItemModel(
        id: 103,
        name: 'Artificial Intelligence & Data Science',
        level: 2,
        parentId: parentId,
      ),
      CategoryItemModel(
        id: 104,
        name: 'Mobile App Development (Flutter/iOS)',
        level: 2,
        parentId: parentId,
      ),
      CategoryItemModel(
        id: 'other',
        name: 'Other',
        isOther: true,
        parentId: parentId,
      ),
    ];
  }
}
