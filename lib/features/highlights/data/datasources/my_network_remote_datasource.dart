import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../models/network_member_model.dart';
import '../models/network_stats_model.dart';

abstract class MyNetworkRemoteDataSource {
  Future<NetworkStatsModel> getNetworkStats();
  Future<NetworkMembersResult> getNetworkMembers({int page = 1});
  Future<NetworkStatsModel> generateInviteCode();
}

/// Carries both the member list and the real total from pagination.
class NetworkMembersResult {
  final List<NetworkMemberModel> members;
  final int total;

  const NetworkMembersResult({required this.members, required this.total});
}

class MyNetworkRemoteDataSourceImpl implements MyNetworkRemoteDataSource {
  final DioClient dioClient;
  const MyNetworkRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<NetworkStatsModel> getNetworkStats() async {
    Map<String, dynamic> combined = {};
    try {
      final response = await dioClient.dio.get(ApiEndpoints.referralsStats);
      final data = response.data['data'] as Map<String, dynamic>? ?? {};
      combined.addAll(data);
    } catch (_) {}

    try {
      final validateResponse =
          await dioClient.dio.get(ApiEndpoints.referralsValidate);
      final validateData =
          validateResponse.data['data'] as Map<String, dynamic>? ?? {};
      if (validateData.containsKey('referral_code')) {
        combined['referral_code'] = validateData['referral_code'];
      }
      if (validateData.containsKey('referral_link')) {
        combined['referral_link'] = validateData['referral_link'];
      }
    } catch (_) {}

    return NetworkStatsModel.fromJson(combined);
  }

  @override
  Future<NetworkMembersResult> getNetworkMembers({int page = 1}) async {
    try {
      final response = await dioClient.dio.get(
        ApiEndpoints.referralMembers,
        queryParameters: {'per_page': 20, 'page': page},
      );
      final data = response.data['data'];
      List<dynamic> items = [];
      int total = 0;

      if (data is Map<String, dynamic>) {
        if (data['items'] is List) {
          items = data['items'] as List;
        }
        // Parse pagination.total for accurate count
        final pagination = data['pagination'] as Map<String, dynamic>?;
        if (pagination != null) {
          total = (pagination['total'] as num?)?.toInt() ?? items.length;
        } else {
          total = items.length;
        }
      } else if (data is List) {
        items = data;
        total = items.length;
      }

      final members = items
          .whereType<Map<String, dynamic>>()
          .map((e) => NetworkMemberModel.fromJson(e))
          .toList();

      return NetworkMembersResult(members: members, total: total);
    } catch (_) {
      return const NetworkMembersResult(members: [], total: 0);
    }
  }

  @override
  Future<NetworkStatsModel> generateInviteCode() async {
    try {
      final response = await dioClient.dio.get(ApiEndpoints.referralsValidate);
      final data = response.data['data'] as Map<String, dynamic>? ?? {};
      if (data.isNotEmpty) {
        return NetworkStatsModel.fromJson(data);
      }
    } catch (_) {}

    final response =
        await dioClient.dio.post(ApiEndpoints.generateReferralCode);
    final data = response.data['data'] as Map<String, dynamic>? ?? {};
    return NetworkStatsModel.fromJson(data);
  }
}
