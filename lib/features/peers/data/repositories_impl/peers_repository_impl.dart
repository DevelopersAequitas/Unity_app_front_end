import '../../domain/entities/geo_peer_entity.dart';
import '../../domain/entities/match_peer_entity.dart';
import '../../domain/entities/peer_entity.dart';
import '../../domain/entities/peer_request_entity.dart';
import '../../domain/repositories/peers_repository.dart';
import '../datasources/peers_local_datasource.dart';
import '../datasources/peers_remote_datasource.dart';

class PeersRepositoryImpl implements PeersRepository {
  final PeersRemoteDataSource remoteDataSource;
  final PeersLocalDataSource? localDataSource;

  PeersRepositoryImpl({
    required this.remoteDataSource,
    this.localDataSource,
  });

  @override
  Future<List<PeerEntity>> getAllPeers({
    int page = 1,
    int limit = 20,
    String? search,
    String? sort,
  }) async {
    try {
      final models = await remoteDataSource.getAllPeers(
        page: page,
        limit: limit,
        search: search,
        sort: sort,
      );
      if (page == 1 && (search == null || search.isEmpty) && localDataSource != null) {
        await localDataSource!.cacheAllPeers(models.map((m) => m.toJson()).toList());
      }
      return models.map((m) => m.toEntity()).toList();
    } catch (_) {
      if (page == 1 && (search == null || search.isEmpty) && localDataSource != null) {
        final cached = await localDataSource!.getCachedAllPeers();
        if (cached.isNotEmpty) {
          return cached.map((m) => m.toEntity()).toList();
        }
      }
      rethrow;
    }
  }

  @override
  Future<List<PeerEntity>> getMyConnections({
    int page = 1,
    int limit = 20,
    String? search,
  }) async {
    try {
      final models = await remoteDataSource.getMyConnections(
        page: page,
        limit: limit,
        search: search,
      );
      if (page == 1 && (search == null || search.isEmpty) && localDataSource != null) {
        await localDataSource!.cacheMyConnections(models.map((m) => m.toJson()).toList());
      }
      return models.map((m) => m.toEntity()).toList();
    } catch (_) {
      if (page == 1 && (search == null || search.isEmpty) && localDataSource != null) {
        final cached = await localDataSource!.getCachedMyConnections();
        if (cached.isNotEmpty) {
          return cached.map((m) => m.toEntity()).toList();
        }
      }
      rethrow;
    }
  }

  @override
  Future<List<PeerRequestEntity>> getConnectionRequests({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final models = await remoteDataSource.getConnectionRequests(
        page: page,
        limit: limit,
      );
      if (page == 1 && localDataSource != null) {
        await localDataSource!.cacheConnectionRequests(models.map((m) => m.toJson()).toList());
      }
      return models.map((m) => m.toEntity()).toList();
    } catch (_) {
      if (page == 1 && localDataSource != null) {
        final cached = await localDataSource!.getCachedConnectionRequests();
        if (cached.isNotEmpty) {
          return cached.map((m) => m.toEntity()).toList();
        }
      }
      rethrow;
    }
  }

  @override
  Future<List<PeerRequestEntity>> getSentConnectionRequests({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final models = await remoteDataSource.getSentConnectionRequests(
        page: page,
        limit: limit,
      );
      if (page == 1 && localDataSource != null) {
        await localDataSource!.cacheSentConnectionRequests(models.map((m) => m.toJson()).toList());
      }
      return models.map((m) => m.toEntity()).toList();
    } catch (_) {
      if (page == 1 && localDataSource != null) {
        final cached = await localDataSource!.getCachedSentConnectionRequests();
        if (cached.isNotEmpty) {
          return cached.map((m) => m.toEntity()).toList();
        }
      }
      rethrow;
    }
  }

  @override
  Future<List<GeoPeerEntity>> getNearbyPeers({
    int page = 1,
    int limit = 20,
    double? radiusKm,
    double? latitude,
    double? longitude,
  }) async {
    final models = await remoteDataSource.getNearbyPeers(
      page: page,
      limit: limit,
      radiusKm: radiusKm,
      latitude: latitude,
      longitude: longitude,
    );
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<MatchPeerEntity>> getMatchPeers() async {
    try {
      final models = await remoteDataSource.getMatchPeers();
      if (localDataSource != null && models.isNotEmpty) {
        await localDataSource!.cacheMatches(models.map((m) => m.peer.toJson()).toList());
      }
      return models.map((m) => m.toEntity()).toList();
    } catch (_) {
      if (localDataSource != null) {
        final cached = await localDataSource!.getCachedMatches();
        if (cached.isNotEmpty) {
          return cached.map((m) => m.toEntity()).toList();
        }
      }
      return [];
    }
  }

  @override
  Future<void> sendConnectionRequest(String memberId) {
    return remoteDataSource.sendConnectionRequest(memberId);
  }

  @override
  Future<void> acceptConnectionRequest(String requesterId) {
    return remoteDataSource.acceptConnectionRequest(requesterId);
  }

  @override
  Future<void> declineConnectionRequest(String memberId) {
    return remoteDataSource.declineConnectionRequest(memberId);
  }

  @override
  Future<void> cancelSentConnectionRequest(String requestId) {
    return remoteDataSource.cancelSentConnectionRequest(requestId);
  }

  @override
  Future<void> togglePeerBookmark(
    String memberId,
    bool isCurrentlyBookmarked,
  ) {
    return remoteDataSource.togglePeerBookmark(
      memberId,
      isCurrentlyBookmarked,
    );
  }
}
