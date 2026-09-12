import '../../../../core/cache/app_cache_keys.dart';
import '../../../../core/cache/cache_store.dart';
import '../models/match_peer_model.dart';
import '../models/peer_model.dart';
import '../models/peer_request_model.dart';

abstract class PeersLocalDataSource {
  Future<void> cacheAllPeers(List<Map<String, dynamic>> list);
  Future<List<PeerModel>> getCachedAllPeers();
  Future<void> cacheMyConnections(List<Map<String, dynamic>> list);
  Future<List<PeerModel>> getCachedMyConnections();
  Future<void> cacheConnectionRequests(List<Map<String, dynamic>> list);
  Future<List<PeerRequestModel>> getCachedConnectionRequests();
  Future<void> cacheSentConnectionRequests(List<Map<String, dynamic>> list);
  Future<List<PeerRequestModel>> getCachedSentConnectionRequests();
  Future<void> cacheMatches(List<Map<String, dynamic>> list);
  Future<List<MatchPeerModel>> getCachedMatches();
}

class PeersLocalDataSourceImpl implements PeersLocalDataSource {
  final CacheStore cacheStore;

  PeersLocalDataSourceImpl({required this.cacheStore});

  @override
  Future<void> cacheAllPeers(List<Map<String, dynamic>> list) async {
    await cacheStore.set(AppCacheBoxes.peersBox, AppCacheKeys.allPeers, list);
  }

  @override
  Future<List<PeerModel>> getCachedAllPeers() async {
    final cached = await cacheStore.get<List<dynamic>>(
      AppCacheBoxes.peersBox,
      AppCacheKeys.allPeers,
    );
    if (cached != null) {
      return cached
          .whereType<Map<String, dynamic>>()
          .map((e) => PeerModel.fromJson(e))
          .toList();
    }
    return [];
  }

  @override
  Future<void> cacheMyConnections(List<Map<String, dynamic>> list) async {
    await cacheStore.set(
      AppCacheBoxes.peersBox,
      AppCacheKeys.myConnections,
      list,
    );
  }

  @override
  Future<List<PeerModel>> getCachedMyConnections() async {
    final cached = await cacheStore.get<List<dynamic>>(
      AppCacheBoxes.peersBox,
      AppCacheKeys.myConnections,
    );
    if (cached != null) {
      return cached
          .whereType<Map<String, dynamic>>()
          .map((e) => PeerModel.fromJson(e))
          .toList();
    }
    return [];
  }

  @override
  Future<void> cacheConnectionRequests(List<Map<String, dynamic>> list) async {
    await cacheStore.set(
      AppCacheBoxes.peersBox,
      AppCacheKeys.connectionRequests,
      list,
    );
  }

  @override
  Future<List<PeerRequestModel>> getCachedConnectionRequests() async {
    final cached = await cacheStore.get<List<dynamic>>(
      AppCacheBoxes.peersBox,
      AppCacheKeys.connectionRequests,
    );
    if (cached != null) {
      return cached
          .whereType<Map<String, dynamic>>()
          .map((e) => PeerRequestModel.fromJson(e, isSent: false))
          .toList();
    }
    return [];
  }

  @override
  Future<void> cacheSentConnectionRequests(List<Map<String, dynamic>> list) async {
    await cacheStore.set(
      AppCacheBoxes.peersBox,
      AppCacheKeys.sentConnectionRequests,
      list,
    );
  }

  @override
  Future<List<PeerRequestModel>> getCachedSentConnectionRequests() async {
    final cached = await cacheStore.get<List<dynamic>>(
      AppCacheBoxes.peersBox,
      AppCacheKeys.sentConnectionRequests,
    );
    if (cached != null) {
      return cached
          .whereType<Map<String, dynamic>>()
          .map((e) => PeerRequestModel.fromJson(e, isSent: true))
          .toList();
    }
    return [];
  }

  @override
  Future<void> cacheMatches(List<Map<String, dynamic>> list) async {
    await cacheStore.set(AppCacheBoxes.peersBox, AppCacheKeys.matchPeers, list);
  }

  @override
  Future<List<MatchPeerModel>> getCachedMatches() async {
    final cached = await cacheStore.get<List<dynamic>>(
      AppCacheBoxes.peersBox,
      AppCacheKeys.matchPeers,
    );
    if (cached != null) {
      return cached
          .whereType<Map<String, dynamic>>()
          .map((e) => PeerModel.fromJson(e))
          .map(
            (p) => MatchPeerModel(
              peer: p,
              matchPercentage: 85 + (p.id.hashCode.abs() % 14),
              matchReasons: [
                if (p.category != null) 'Shared Domain Focus: ${p.category}',
                if (p.city != null) 'Based in ${p.city}',
                'High Collaborative Compatibility',
              ],
            ),
          )
          .toList();
    }
    return [];
  }
}
