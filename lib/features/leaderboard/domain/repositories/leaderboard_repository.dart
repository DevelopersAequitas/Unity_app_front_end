import '../entities/leaderboard_entity.dart';

abstract class LeaderboardRepository {
  Future<LeaderboardEntity> getCoinsLeaderboard({bool forceRefresh = false});
  Future<LeaderboardEntity?> getCachedCoinsLeaderboard();
  Future<LeaderboardEntity> getImpactsLeaderboard({bool forceRefresh = false});
  Future<LeaderboardEntity?> getCachedImpactsLeaderboard();
}
