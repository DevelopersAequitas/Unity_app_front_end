import 'package:dio/dio.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../home/data/models/timeline_item_model.dart';
import '../../../home/domain/entities/timeline_item_entity.dart';
import '../../../profile/data/models/profile_model.dart';
import '../../../../core/network/dio_client.dart';
import '../models/geo_peer_model.dart';
import '../models/match_peer_model.dart';
import '../models/peer_model.dart';
import '../models/peer_request_model.dart';

abstract class PeersRemoteDataSource {
  Future<List<PeerModel>> getAllPeers({
    int page = 1,
    int limit = 20,
    String? search,
    String? sort,
  });

  Future<List<PeerModel>> getMyConnections({
    int page = 1,
    int limit = 20,
    String? search,
  });

  Future<List<PeerRequestModel>> getConnectionRequests({
    int page = 1,
    int limit = 20,
  });

  Future<List<PeerRequestModel>> getSentConnectionRequests({
    int page = 1,
    int limit = 20,
  });

  Future<List<GeoPeerModel>> getNearbyPeers({
    int page = 1,
    int limit = 20,
    double? radiusKm,
    double? latitude,
    double? longitude,
  });

  Future<List<MatchPeerModel>> getMatchPeers();

  Future<ProfileModel> getMemberProfile(String memberId);

  Future<List<TimelineItemEntity>> getMemberPosts(String memberId, {int page = 1});

  Future<void> followUser(String userId);

  Future<void> unfollowUser(String userId);

  Future<void> sendConnectionRequest(String memberId);

  Future<void> acceptConnectionRequest(String requesterId);

  Future<void> declineConnectionRequest(String memberId);

  Future<void> removeConnection(String memberId);

  Future<void> cancelSentConnectionRequest(String requestId);

  Future<void> togglePeerBookmark(String memberId, bool isCurrentlyBookmarked);
}

class PeersRemoteDataSourceImpl implements PeersRemoteDataSource {
  final DioClient dioClient;

  PeersRemoteDataSourceImpl({required this.dioClient});

  Dio get _dio => dioClient.dio;

  @override
  Future<List<PeerModel>> getAllPeers({
    int page = 1,
    int limit = 20,
    String? search,
    String? sort,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'per_page': limit,
    };
    if (search != null && search.trim().isNotEmpty) {
      queryParams['search'] = search.trim();
      queryParams['q'] = search.trim();
    } else {
      queryParams['is_connected'] = false;
    }
    if (sort != null && sort.isNotEmpty) {
      queryParams['sort'] = sort;
    }

    final response = await _dio.get(
      ApiEndpoints.membersLimited,
      queryParameters: queryParams,
    );

    return _extractPeerList(response.data);
  }

  @override
  Future<List<PeerModel>> getMyConnections({
    int page = 1,
    int limit = 20,
    String? search,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'per_page': limit,
    };
    if (search != null && search.trim().isNotEmpty) {
      queryParams['search'] = search.trim();
    }

    final response = await _dio.get(
      ApiEndpoints.connections,
      queryParameters: queryParams,
    );

    final peers = _extractPeerList(response.data);
    return peers.map((p) => p.copyWith(connectionStatus: 'connected')).toList();
  }

  @override
  Future<List<PeerRequestModel>> getConnectionRequests({
    int page = 1,
    int limit = 20,
  }) async {
    final response = await _dio.get(
      ApiEndpoints.connectionRequests,
      queryParameters: {'page': page, 'per_page': limit},
    );

    return _extractRequestList(response.data, isSent: false);
  }

  @override
  Future<List<PeerRequestModel>> getSentConnectionRequests({
    int page = 1,
    int limit = 20,
  }) async {
    final response = await _dio.get(
      ApiEndpoints.sentConnectionRequests,
      queryParameters: {'page': page, 'per_page': limit},
    );

    return _extractRequestList(response.data, isSent: true);
  }

  @override
  Future<List<GeoPeerModel>> getNearbyPeers({
    int page = 1,
    int limit = 20,
    double? radiusKm,
    double? latitude,
    double? longitude,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'per_page': limit,
    };
    if (radiusKm != null) queryParams['radius'] = radiusKm;
    if (latitude != null) queryParams['latitude'] = latitude;
    if (longitude != null) queryParams['longitude'] = longitude;

    final response = await _dio.get(
      ApiEndpoints.geoNearbyPeers,
      queryParameters: queryParams,
    );

    return _extractGeoPeerList(response.data);
  }

  @override
  Future<List<MatchPeerModel>> getMatchPeers() async {
    try {
      final response = await _dio.get(
        ApiEndpoints.membersLimited,
        queryParameters: {'page': 1, 'per_page': 30},
      );

      final members = _extractPeerList(response.data);
      return members.map((p) {
        return MatchPeerModel(
          peer: p,
          matchPercentage: (80 + (p.id.hashCode.abs() % 19)), // 80% to 98%
          matchReasons: [
            if (p.category != null) 'Shared Domain Focus: ${p.category}',
            if (p.city != null) 'Based in ${p.city}',
            'High Collaborative Compatibility',
          ],
        );
      }).toList();
    } catch (_) {
      return [];
    }
  }

  @override
  Future<ProfileModel> getMemberProfile(String memberId) async {
    final response = await _dio.get(ApiEndpoints.member(memberId));
    final data = response.data;
    if (data is Map<String, dynamic> && data['data'] != null) {
      final inner = data['data'];
      if (inner is Map<String, dynamic>) {
        return ProfileModel.fromJson(inner);
      }
    }
    if (data is Map<String, dynamic>) {
      return ProfileModel.fromJson(data);
    }
    throw Exception('Failed to load member profile');
  }

  @override
  Future<List<TimelineItemEntity>> getMemberPosts(String memberId, {int page = 1}) async {
    try {
      dynamic data;
      // 1. Primary: /users/{memberId}/posts
      try {
        final response = await _dio.get(
          ApiEndpoints.userPosts(memberId),
          queryParameters: {'page': page, 'per_page': 10},
        );
        if (response.statusCode == 200 || response.statusCode == 201) {
          data = response.data;
        }
      } catch (_) {}

      // 2. Fallback only if primary failed: /members/{memberId}/posts
      if (data == null) {
        try {
          final response = await _dio.get(
            '/members/$memberId/posts',
            queryParameters: {'page': page, 'per_page': 10},
          );
          if (response.statusCode == 200 || response.statusCode == 201) {
            data = response.data;
          }
        } catch (_) {}
      }

      if (data != null) {
        List? rawList;
        if (data is Map<String, dynamic>) {
          final inner = data['data'];
          if (inner is List) {
            rawList = inner;
          } else if (inner is Map<String, dynamic>) {
            rawList = (inner['items'] ?? inner['posts'] ?? inner['data']) as List?;
          } else if (data['items'] is List) {
            rawList = data['items'] as List?;
          } else if (data['posts'] is List) {
            rawList = data['posts'] as List?;
          }
        } else if (data is List) {
          rawList = data;
        }

        if (rawList != null) {
          return rawList
              .whereType<Map<String, dynamic>>()
              .map((json) => TimelineItemModel.fromJson(json).toEntity())
              .toList();
        }
      }
      return [];
    } catch (_) {
      return [];
    }
  }

  @override
  Future<void> followUser(String userId) async {
    try {
      await _dio.post(ApiEndpoints.followUser(userId));
    } catch (_) {
      try {
        await _dio.post(ApiEndpoints.memberFollow(userId));
      } catch (e) {
        rethrow;
      }
    }
  }

  @override
  Future<void> unfollowUser(String userId) async {
    try {
      final res = await _dio.post(ApiEndpoints.unfollowUser(userId));
      if (res.data is Map && res.data['status'] == true) return;
    } catch (_) {}
    try {
      await _dio.delete(ApiEndpoints.unfollowUser(userId));
    } catch (_) {
      try {
        await _dio.delete(ApiEndpoints.followUser(userId));
      } catch (_) {
        try {
          await _dio.delete(ApiEndpoints.memberUnfollow(userId));
        } catch (_) {
          try {
            await _dio.delete(ApiEndpoints.memberFollow(userId));
          } catch (e) {
            rethrow;
          }
        }
      }
    }
  }

  @override
  Future<void> sendConnectionRequest(String memberId) async {
    await _dio.post(ApiEndpoints.memberConnections(memberId));
  }

  @override
  Future<void> acceptConnectionRequest(String requesterId) async {
    await _dio.post(ApiEndpoints.acceptConnection(requesterId));
  }

  @override
  Future<void> declineConnectionRequest(String memberId) async {
    await _dio.delete(ApiEndpoints.memberConnections(memberId));
  }

  @override
  Future<void> removeConnection(String memberId) async {
    await _dio.delete(ApiEndpoints.memberConnections(memberId));
  }

  @override
  Future<void> cancelSentConnectionRequest(String requestId) async {
    try {
      await _dio.delete(ApiEndpoints.cancelSentConnection(requestId));
    } catch (_) {
      try {
        await _dio.delete(ApiEndpoints.memberConnections(requestId));
      } catch (e) {
        rethrow;
      }
    }
  }

  @override
  Future<void> togglePeerBookmark(
    String memberId,
    bool isCurrentlyBookmarked,
  ) async {
    if (isCurrentlyBookmarked) {
      await _dio.delete(ApiEndpoints.memberBookmark(memberId));
    } else {
      await _dio.post(ApiEndpoints.memberBookmark(memberId));
    }
  }

  List<PeerModel> _extractPeerList(dynamic data) {
    if (data == null) return [];
    List? rawList;
    if (data is Map<String, dynamic>) {
      final inner = data['data'];
      if (inner is List) {
        rawList = inner;
      } else if (inner is Map<String, dynamic>) {
        rawList = (inner['data'] ?? inner['items'] ?? inner['members']) as List?;
      } else if (data['items'] is List) {
        rawList = data['items'] as List?;
      }
    } else if (data is List) {
      rawList = data;
    }

    if (rawList != null) {
      return rawList
          .whereType<Map<String, dynamic>>()
          .map((e) => PeerModel.fromJson(e))
          .toList();
    }
    return [];
  }

  List<PeerRequestModel> _extractRequestList(dynamic data, {bool isSent = false}) {
    if (data == null) return [];
    List? rawList;
    if (data is Map<String, dynamic>) {
      final inner = data['data'];
      if (inner is List) {
        rawList = inner;
      } else if (inner is Map<String, dynamic>) {
        rawList = (inner['data'] ?? inner['items']) as List?;
      } else if (data['items'] is List) {
        rawList = data['items'] as List?;
      }
    } else if (data is List) {
      rawList = data;
    }

    if (rawList != null) {
      return rawList
          .whereType<Map<String, dynamic>>()
          .map((e) => PeerRequestModel.fromJson(e, isSent: isSent))
          .toList();
    }
    return [];
  }

  List<GeoPeerModel> _extractGeoPeerList(dynamic data) {
    if (data == null) return [];
    List? rawList;
    if (data is Map<String, dynamic>) {
      final inner = data['data'];
      if (inner is List) {
        rawList = inner;
      } else if (inner is Map<String, dynamic>) {
        rawList = (inner['items'] ?? inner['data'] ?? inner['peers']) as List?;
      } else if (data['items'] is List) {
        rawList = data['items'] as List?;
      } else if (data['peers'] is List) {
        rawList = data['peers'] as List?;
      }
    } else if (data is List) {
      rawList = data;
    }

    if (rawList != null) {
      return rawList
          .whereType<Map<String, dynamic>>()
          .map((e) => GeoPeerModel.fromJson(e))
          .toList();
    }
    return [];
  }
}
