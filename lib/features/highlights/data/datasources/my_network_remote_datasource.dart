import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../models/network_member_model.dart';
import '../models/network_stats_model.dart';

abstract class MyNetworkRemoteDataSource {
  Future<NetworkStatsModel> getNetworkStats();
  Future<List<NetworkMemberModel>> getNetworkMembers({int page = 1});
  Future<NetworkStatsModel> generateInviteCode();
}

class MyNetworkRemoteDataSourceImpl implements MyNetworkRemoteDataSource {
  final DioClient dioClient;
  const MyNetworkRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<NetworkStatsModel> getNetworkStats() async {
    final response = await dioClient.dio.get(ApiEndpoints.referralsStats);
    final data = response.data['data'] as Map<String, dynamic>? ?? {};
    return NetworkStatsModel.fromJson(data);
  }

  @override
  Future<List<NetworkMemberModel>> getNetworkMembers({int page = 1}) async {
    List<dynamic> items = [];
    try {
      final response = await dioClient.dio.get(
        ApiEndpoints.referralMembers,
        queryParameters: {'page': page},
      );
      final data = response.data['data'];
      if (data is Map<String, dynamic> && data['items'] is List) {
        items = data['items'] as List;
      } else if (data is List) {
        items = data;
      }
    } catch (_) {
      // Fallback to stats
    }

    if (items.isEmpty) {
      try {
        final statsResponse = await dioClient.dio.get(ApiEndpoints.referralsStats);
        final statsData = statsResponse.data['data'] as Map<String, dynamic>? ?? {};
        final given = statsData['referrals_given'];
        final received = statsData['referrals_received'];
        if (given is Map<String, dynamic> && given['data'] is List) {
          for (final item in given['data']) {
            if (item is Map<String, dynamic>) {
              final copy = Map<String, dynamic>.from(item);
              copy['is_given'] = true;
              items.add(copy);
            }
          }
        }
        if (received is Map<String, dynamic> && received['data'] is List) {
          for (final item in received['data']) {
            if (item is Map<String, dynamic>) {
              final copy = Map<String, dynamic>.from(item);
              copy['is_received'] = true;
              items.add(copy);
            }
          }
        }
      } catch (_) {}
    }

    return items
        .whereType<Map<String, dynamic>>()
        .map((e) => NetworkMemberModel.fromJson(e))
        .toList();
  }

  @override
  Future<NetworkStatsModel> generateInviteCode() async {
    final response = await dioClient.dio.post(ApiEndpoints.generateReferralCode);
    final data = response.data['data'] as Map<String, dynamic>? ?? {};
    return NetworkStatsModel.fromJson(data);
  }
}
