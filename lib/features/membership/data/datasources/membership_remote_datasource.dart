import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../models/checkout_session_model.dart';
import '../models/membership_plan_model.dart';
import '../models/subscription_history_model.dart';
import '../models/subscription_status_model.dart';

abstract class MembershipRemoteDataSource {
  Future<List<MembershipPlanModel>> getMembershipPlans();
  Future<CheckoutSessionModel> initiatePlanCheckout(String planCode);
  Future<SubscriptionStatusModel> verifyCheckoutStatus(String hostedPageId);
  Future<List<SubscriptionHistoryModel>> getSubscriptionHistory();
}

class MembershipRemoteDataSourceImpl implements MembershipRemoteDataSource {
  final DioClient dioClient;

  MembershipRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<List<MembershipPlanModel>> getMembershipPlans() async {
    try {
      dynamic responseData;
      try {
        final response = await dioClient.dio.get(ApiEndpoints.zohoPlans);
        responseData = response.data;
      } catch (_) {
        final response = await dioClient.dio.get(ApiEndpoints.membershipPlans);
        responseData = response.data;
      }

      List<dynamic> list = [];
      if (responseData is List) {
        list = responseData;
      } else if (responseData is Map<String, dynamic>) {
        if (responseData['data'] is List) {
          list = responseData['data'] as List;
        } else if (responseData['data'] is Map<String, dynamic>) {
          final map = responseData['data'] as Map<String, dynamic>;
          if (map['plans'] is List) {
            list = map['plans'] as List;
          } else if (map['items'] is List) {
            list = map['items'] as List;
          }
        } else if (responseData['plans'] is List) {
          list = responseData['plans'] as List;
        }
      }

      final parsed = list
          .whereType<Map<String, dynamic>>()
          .map((m) => MembershipPlanModel.fromJson(m))
          .toList();

      if (parsed.isNotEmpty) {
        return parsed;
      }
      return MembershipPlanModel.fallbackPlans;
    } catch (_) {
      return MembershipPlanModel.fallbackPlans;
    }
  }

  @override
  Future<CheckoutSessionModel> initiatePlanCheckout(String planCode) async {
    final response = await dioClient.dio.post(
      ApiEndpoints.billingCheckout,
      data: {'plan_code': planCode},
    );

    final data = response.data;
    if (data is Map<String, dynamic>) {
      if (data['data'] is Map<String, dynamic>) {
        return CheckoutSessionModel.fromJson(data['data'] as Map<String, dynamic>);
      }
      return CheckoutSessionModel.fromJson(data);
    }
    throw Exception('Failed to initiate checkout session');
  }

  @override
  Future<SubscriptionStatusModel> verifyCheckoutStatus(String hostedPageId) async {
    // 1. First trigger the hosted page membership sync endpoint which updates the database
    try {
      final syncResponse = await dioClient.dio.get(
        ApiEndpoints.billingHostedPageSync(hostedPageId),
      );
      final syncData = syncResponse.data;
      if (syncData is Map<String, dynamic>) {
        final payload = (syncData['data'] is Map<String, dynamic>)
            ? syncData['data'] as Map<String, dynamic>
            : syncData;
        final model = SubscriptionStatusModel.fromJson(payload);
        if (model.isSuccessful) {
          return model;
        }
      }
    } catch (_) {}

    // 2. Direct checkout status check without /status suffix
    try {
      final response = await dioClient.dio.get(
        ApiEndpoints.billingCheckoutDetail(hostedPageId),
      );
      final data = response.data;
      if (data is Map<String, dynamic>) {
        final payload = (data['data'] is Map<String, dynamic>)
            ? data['data'] as Map<String, dynamic>
            : data;
        return SubscriptionStatusModel.fromJson(payload);
      }
    } catch (_) {}

    // 3. Fallback to status path if needed
    final response = await dioClient.dio.get(
      ApiEndpoints.billingCheckoutStatus(hostedPageId),
    );
    final data = response.data;
    if (data is Map<String, dynamic>) {
      if (data['data'] is Map<String, dynamic>) {
        return SubscriptionStatusModel.fromJson(data['data'] as Map<String, dynamic>);
      }
      return SubscriptionStatusModel.fromJson(data);
    }
    throw Exception('Failed to verify checkout status');
  }

  @override
  Future<List<SubscriptionHistoryModel>> getSubscriptionHistory() async {
    final response = await dioClient.dio.get(ApiEndpoints.subscriptionsHistory);
    final data = response.data;
    List<dynamic> list = [];
    if (data is List) {
      list = data;
    } else if (data is Map<String, dynamic>) {
      if (data['data'] is List) {
        list = data['data'] as List;
      } else if (data['items'] is List) {
        list = data['items'] as List;
      }
    }

    return list
        .whereType<Map<String, dynamic>>()
        .map((m) => SubscriptionHistoryModel.fromJson(m))
        .toList();
  }
}
