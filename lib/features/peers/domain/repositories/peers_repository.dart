import '../../../home/domain/entities/timeline_item_entity.dart';
import '../../../profile/domain/entities/profile_entity.dart';
import '../entities/geo_peer_entity.dart';
import '../entities/match_peer_entity.dart';
import '../entities/peer_entity.dart';
import '../entities/peer_request_entity.dart';

abstract class PeersRepository {
  Future<List<PeerEntity>> getAllPeers({
    int page = 1,
    int limit = 20,
    String? search,
    String? sort,
  });

  Future<List<PeerEntity>> getMyConnections({
    int page = 1,
    int limit = 20,
    String? search,
  });

  Future<List<PeerRequestEntity>> getConnectionRequests({
    int page = 1,
    int limit = 20,
  });

  Future<List<PeerRequestEntity>> getSentConnectionRequests({
    int page = 1,
    int limit = 20,
  });

  Future<List<GeoPeerEntity>> getNearbyPeers({
    int page = 1,
    int limit = 20,
    double? radiusKm,
    double? latitude,
    double? longitude,
  });

  Future<List<MatchPeerEntity>> getMatchPeers();

  Future<ProfileEntity> getMemberProfile(String memberId);

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
