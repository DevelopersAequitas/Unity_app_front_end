import 'package:dio/dio.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../../domain/entities/create_peer_referral_params.dart';
import '../../domain/entities/create_referral_params.dart';
import '../models/paginated_referrals_model.dart';
import '../models/referral_leaderboard_model.dart';
import '../models/referral_model.dart';
import '../models/referral_stats_model.dart';
import '../models/referral_status_model.dart';

abstract class ReferralsRemoteDataSource {
  Future<ReferralStatsModel> getReferralsStats({int perPage = 15});

  Future<PaginatedReferralsModel> getReceivedReferrals({
    int page = 1,
    int perPage = 15,
  });

  Future<PaginatedReferralsModel> getGivenReferrals({
    int page = 1,
    int perPage = 15,
  });

  Future<List<ReferralStatusModel>> getReferralStatuses();

  Future<ReferralModel> createReferral(CreateReferralParams params);

  Future<ReferralModel> updateReferralStatus(String id, int statusId);

  Future<void> submitPeerReferral(CreatePeerReferralParams params);

  Future<ReferralModel> getReferralDetail(String id);

  Future<List<ReferralLeaderboardModel>> getReferralsLeaderboard({int limit = 50});
}

class ReferralsRemoteDataSourceImpl implements ReferralsRemoteDataSource {
  final DioClient dioClient;

  ReferralsRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<ReferralStatsModel> getReferralsStats({int perPage = 15}) async {
    final response = await dioClient.dio.get(
      ApiEndpoints.referralsStats,
      queryParameters: {'per_page': perPage},
    );
    final data = response.data;
    if (data is Map<String, dynamic>) {
      return ReferralStatsModel.fromJson(data);
    }
    return const ReferralStatsModel();
  }

  @override
  Future<PaginatedReferralsModel> getReceivedReferrals({
    int page = 1,
    int perPage = 15,
  }) async {
    final response = await dioClient.dio.get(
      ApiEndpoints.activitiesReferrals,
      queryParameters: {
        'filter': 'received',
        'page': page,
        'per_page': perPage,
      },
    );
    return PaginatedReferralsModel.fromJson(response.data);
  }

  @override
  Future<PaginatedReferralsModel> getGivenReferrals({
    int page = 1,
    int perPage = 15,
  }) async {
    final response = await dioClient.dio.get(
      ApiEndpoints.activitiesReferrals,
      queryParameters: {
        'filter': 'given',
        'page': page,
        'per_page': perPage,
      },
    );
    return PaginatedReferralsModel.fromJson(response.data);
  }

  @override
  Future<List<ReferralStatusModel>> getReferralStatuses() async {
    final response = await dioClient.dio.get(ApiEndpoints.referralStatuses);
    final data = response.data;
    if (data is Map<String, dynamic>) {
      final inner = data['data'];
      if (inner is List) {
        return inner
            .whereType<Map<String, dynamic>>()
            .map((e) => ReferralStatusModel.fromJson(e))
            .toList();
      }
    } else if (data is List) {
      return data
          .whereType<Map<String, dynamic>>()
          .map((e) => ReferralStatusModel.fromJson(e))
          .toList();
    }
    return [];
  }

  @override
  Future<ReferralModel> createReferral(CreateReferralParams params) async {
    try {
      final response = await dioClient.dio.post(
        ApiEndpoints.activitiesReferrals,
        data: params.toJson(),
      );
      final data = response.data;
      if (data is Map<String, dynamic>) {
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
        return ReferralModel.fromJson(itemData);
      }
      throw Exception('Failed to create referral');
    } on DioException catch (e) {
      final resData = e.response?.data;
      if (resData is Map<String, dynamic> && resData['message'] != null) {
        throw Exception(resData['message'].toString());
      }
      rethrow;
    }
  }

  @override
  Future<ReferralModel> updateReferralStatus(String id, int statusId) async {
    try {
      final response = await dioClient.dio.patch(
        ApiEndpoints.updateReferralStatus(id),
        data: {'status_id': statusId},
      );
      final data = response.data;
      if (data is Map<String, dynamic>) {
        final itemData = (data['data'] is Map<String, dynamic>)
            ? Map<String, dynamic>.from(data['data'] as Map<String, dynamic>)
            : Map<String, dynamic>.from(data);
        return ReferralModel.fromJson(itemData);
      }
      throw Exception('Failed to update referral status');
    } on DioException catch (e) {
      final resData = e.response?.data;
      if (resData is Map<String, dynamic> && resData['message'] != null) {
        throw Exception(resData['message'].toString());
      }
      rethrow;
    }
  }

  @override
  Future<void> submitPeerReferral(CreatePeerReferralParams params) async {
    try {
      await dioClient.dio.post(
        ApiEndpoints.peerReferrals,
        data: params.toJson(),
      );
    } on DioException catch (e) {
      final resData = e.response?.data;
      if (resData is Map<String, dynamic> && resData['message'] != null) {
        throw Exception(resData['message'].toString());
      }
      rethrow;
    }
  }

  @override
  Future<ReferralModel> getReferralDetail(String id) async {
    final response = await dioClient.dio.get('${ApiEndpoints.activitiesReferrals}/$id');
    final data = response.data;
    if (data is Map<String, dynamic>) {
      final itemData = (data['data'] is Map<String, dynamic>)
          ? Map<String, dynamic>.from(data['data'] as Map<String, dynamic>)
          : Map<String, dynamic>.from(data);
      return ReferralModel.fromJson(itemData);
    }
    throw Exception('Failed to load referral detail');
  }

  @override
  Future<List<ReferralLeaderboardModel>> getReferralsLeaderboard({int limit = 50}) async {
    final response = await dioClient.dio.get(
      ApiEndpoints.leaderboardReferrals,
      queryParameters: {'limit': limit},
    );
    final data = response.data;
    List<dynamic> listData = [];
    if (data is List) {
      listData = data;
    } else if (data is Map<String, dynamic>) {
      if (data['data'] is List) {
        listData = data['data'] as List;
      } else if (data['leaderboard'] is List) {
        listData = data['leaderboard'] as List;
      } else if (data['results'] is List) {
        listData = data['results'] as List;
      }
    }
    return listData.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value as Map<String, dynamic>;
      return ReferralLeaderboardModel.fromJson(item, fallbackRank: index + 1);
    }).toList();
  }
}

