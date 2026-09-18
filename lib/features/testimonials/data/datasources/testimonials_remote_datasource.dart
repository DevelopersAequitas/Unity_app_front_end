import 'package:dio/dio.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../../domain/entities/create_testimonial_params.dart';
import '../models/paginated_testimonials_model.dart';
import '../models/testimonial_model.dart';

class ProMembershipRequiredException implements Exception {
  final String message;
  const ProMembershipRequiredException([this.message = 'Pro membership required to give testimonials.']);

  @override
  String toString() => message;
}

abstract class TestimonialsRemoteDataSource {
  Future<PaginatedTestimonialsModel> getUserTestimonials(
    String userId, {
    int page = 1,
    int perPage = 10,
  });
  Future<PaginatedTestimonialsModel> getReceivedTestimonials({
    int page = 1,
    int perPage = 10,
  });
  Future<PaginatedTestimonialsModel> getGivenTestimonials({
    int page = 1,
    int perPage = 10,
  });
  Future<TestimonialModel> createTestimonial(CreateTestimonialParams params);
}

class TestimonialsRemoteDataSourceImpl implements TestimonialsRemoteDataSource {
  final DioClient dioClient;

  TestimonialsRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<PaginatedTestimonialsModel> getUserTestimonials(
    String userId, {
    int page = 1,
    int perPage = 10,
  }) async {
    final response = await dioClient.dio.get(
      ApiEndpoints.userTestimonials(userId),
      queryParameters: {
        'page': page,
        'per_page': perPage,
      },
    );
    return PaginatedTestimonialsModel.fromJson(response.data);
  }

  @override
  Future<PaginatedTestimonialsModel> getReceivedTestimonials({
    int page = 1,
    int perPage = 10,
  }) async {
    try {
      final response = await dioClient.dio.get(
        ApiEndpoints.receivedTestimonials,
        queryParameters: {
          'page': page,
          'per_page': perPage,
        },
      );
      return PaginatedTestimonialsModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        final fallbackResponse = await dioClient.dio.get(
          ApiEndpoints.testimonialsReceived,
          queryParameters: {
            'page': page,
            'per_page': perPage,
          },
        );
        return PaginatedTestimonialsModel.fromJson(fallbackResponse.data);
      }
      rethrow;
    }
  }

  @override
  Future<PaginatedTestimonialsModel> getGivenTestimonials({
    int page = 1,
    int perPage = 10,
  }) async {
    try {
      final response = await dioClient.dio.get(
        ApiEndpoints.givenTestimonials,
        queryParameters: {
          'page': page,
          'per_page': perPage,
        },
      );
      return PaginatedTestimonialsModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        final fallbackResponse = await dioClient.dio.get(
          ApiEndpoints.testimonialsGiven,
          queryParameters: {
            'page': page,
            'per_page': perPage,
          },
        );
        return PaginatedTestimonialsModel.fromJson(fallbackResponse.data);
      }
      rethrow;
    }
  }

  @override
  Future<TestimonialModel> createTestimonial(CreateTestimonialParams params) async {
    try {
      final response = await dioClient.dio.post(
        ApiEndpoints.testimonials,
        data: params.toJson(),
      );
      final data = response.data;
      if (data is Map<String, dynamic>) {
        if (data['requires_pro'] == true ||
            data['error_code'] == 'PRO_MEMBERSHIP_REQUIRED') {
          throw ProMembershipRequiredException(
            data['message']?.toString() ?? 'Pro membership required to give testimonials.',
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
        if (data['impacts_earned'] != null && itemData['impacts_earned'] == null) {
          itemData['impacts_earned'] = data['impacts_earned'];
        }
        return TestimonialModel.fromJson(itemData);
      }
      throw Exception('Failed to create testimonial');
    } on DioException catch (e) {
      final resData = e.response?.data;
      if (resData is Map<String, dynamic>) {
        if (resData['requires_pro'] == true ||
            resData['error_code'] == 'PRO_MEMBERSHIP_REQUIRED' ||
            e.response?.statusCode == 403) {
          throw ProMembershipRequiredException(
            resData['message']?.toString() ?? 'Pro membership required to give testimonials.',
          );
        }
        if (resData['message'] != null) {
          throw Exception(resData['message'].toString());
        }
      }
      rethrow;
    }
  }
}
