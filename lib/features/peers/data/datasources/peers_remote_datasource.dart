import 'package:dio/dio.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../highlights/data/models/introduced_peer_model.dart';
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

  Future<List<TimelineItemEntity>> getMemberPosts(
    String memberId, {
    int page = 1,
  });

  Future<void> followUser(String userId);

  Future<void> unfollowUser(String userId);

  Future<void> sendConnectionRequest(String memberId);

  Future<void> acceptConnectionRequest(String requesterId);

  Future<void> declineConnectionRequest(String memberId);

  Future<void> removeConnection(String memberId);

  Future<void> cancelSentConnectionRequest(String requestId);

  Future<void> togglePeerBookmark(String memberId, bool isCurrentlyBookmarked);

  Future<List<PeerModel>> getBookmarkedPeers({int page = 1, int limit = 20});

  Future<List<IntroducedPeerModel>> getMemberIntroducedPeers(String memberId);

  Future<bool> blockPeer(String peerId, {String reason = 'Spam messages'});

  Future<bool> unblockPeer(String peerId);

  Future<List<Map<String, dynamic>>> getBlockedPeers();

  Future<bool> getPeerBlockStatus(String peerId);
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
    final queryParams = <String, dynamic>{'page': page, 'per_page': limit};
    if (search != null && search.trim().isNotEmpty) {
      queryParams['search'] = search.trim();
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
    final queryParams = <String, dynamic>{'page': page, 'per_page': limit};
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
    final queryParams = <String, dynamic>{'page': page, 'per_page': limit};
    if (radiusKm != null && radiusKm > 0) {
      queryParams['radius_km'] = radiusKm;
      queryParams['radius'] = radiusKm;
    }
    if (latitude != null && latitude != 0) queryParams['latitude'] = latitude;
    if (longitude != null && longitude != 0) {
      queryParams['longitude'] = longitude;
    }

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
          matchPercentage: (50 + (p.id.hashCode.abs() % 49)), // 50% to 99%
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
  Future<List<TimelineItemEntity>> getMemberPosts(
    String memberId, {
    int page = 1,
  }) async {
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
            rawList =
                (inner['items'] ?? inner['posts'] ?? inner['data']) as List?;
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

  @override
  Future<List<PeerModel>> getBookmarkedPeers({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.bookmarkedPeers,
        queryParameters: {'page': page, 'per_page': limit},
      );
      final list = _extractPeerList(response.data);
      return list.map((p) => p.copyWith(isBookmarked: true)).toList();
    } catch (_) {
      return [];
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
        rawList =
            (inner['data'] ?? inner['items'] ?? inner['members']) as List?;
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

  List<PeerRequestModel> _extractRequestList(
    dynamic data, {
    bool isSent = false,
  }) {
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

  @override
  Future<List<IntroducedPeerModel>> getMemberIntroducedPeers(
    String memberId,
  ) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.memberIntroducedPeers(memberId),
      );
      final data = response.data['data'] ?? response.data;
      List<dynamic> items = [];
      if (data is Map<String, dynamic> && data['items'] is List) {
        items = data['items'] as List;
      } else if (data is List) {
        items = data;
      }
      return items
          .whereType<Map<String, dynamic>>()
          .map((e) => IntroducedPeerModel.fromJson(e))
          .toList();
    } catch (_) {
      return [];
    }
  }

  @override
  Future<bool> blockPeer(
    String peerId, {
    String reason = 'Spam messages',
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.blockPeer(peerId),
        data: {'reason': reason},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        if (data is Map<String, dynamic>) {
          return data['success'] == true || data['status'] == true;
        }
        return true;
      }
    } catch (_) {
      try {
        final response = await _dio.post(
          '/blocked-users',
          data: {'user_id': peerId, 'reason': reason},
        );
        return response.statusCode == 200 || response.statusCode == 201;
      } catch (e) {
        rethrow;
      }
    }
    return false;
  }

  @override
  Future<bool> unblockPeer(String peerId) async {
    try {
      final response = await _dio.delete(ApiEndpoints.unblockPeer(peerId));
      if (response.statusCode == 200 || response.statusCode == 204) {
        final data = response.data;
        if (data is Map<String, dynamic>) {
          return data['success'] == true || data['status'] == true;
        }
        return true;
      }
    } catch (_) {
      try {
        final response = await _dio.delete(ApiEndpoints.unblockUser(peerId));
        return response.statusCode == 200 || response.statusCode == 204;
      } catch (e) {
        rethrow;
      }
    }
    return false;
  }

  @override
  Future<List<Map<String, dynamic>>> getBlockedPeers() async {
    try {
      final response = await _dio.get(ApiEndpoints.blockedPeers);
      final data = response.data;
      List? raw;
      if (data is Map<String, dynamic>) {
        final inner = data['data'];
        if (inner is Map<String, dynamic>) {
          raw =
              inner['items'] as List? ??
              inner['peers'] as List? ??
              inner['users'] as List?;
        } else if (inner is List) {
          raw = inner;
        } else {
          raw = data['items'] as List?;
        }
      } else if (data is List) {
        raw = data;
      }
      if (raw != null) {
        return raw.whereType<Map<String, dynamic>>().toList();
      }
    } catch (_) {
      try {
        final response = await _dio.get(ApiEndpoints.blockedUsers);
        final data = response.data;
        List? raw;
        if (data is Map<String, dynamic>) {
          final inner = data['data'];
          if (inner is Map<String, dynamic>) {
            raw = inner['items'] as List? ?? inner['users'] as List?;
          } else if (inner is List) {
            raw = inner;
          }
        }
        if (raw != null) {
          return raw.whereType<Map<String, dynamic>>().toList();
        }
      } catch (_) {}
    }
    return [];
  }

  @override
  Future<bool> getPeerBlockStatus(String peerId) async {
    try {
      final response = await _dio.get(ApiEndpoints.peerBlockStatus(peerId));
      final data = response.data;
      if (data is Map<String, dynamic>) {
        final inner = data['data'] ?? data;
        if (inner is Map<String, dynamic>) {
          return inner['is_blocked_by_me'] == true ||
              inner['cannot_interact'] == true ||
              inner['is_blocked'] == true ||
              inner['blocked'] == true;
        }
      }
    } catch (_) {}
    return false;
  }
}
