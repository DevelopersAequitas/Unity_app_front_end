import '../../domain/entities/leaderboard_entity.dart';
import '../../domain/repositories/leaderboard_repository.dart';
import '../datasources/leaderboard_local_datasource.dart';
import '../datasources/leaderboard_remote_datasource.dart';

class LeaderboardRepositoryImpl implements LeaderboardRepository {
  final LeaderboardRemoteDataSource remoteDataSource;
  final LeaderboardLocalDataSource localDataSource;

  LeaderboardRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<LeaderboardEntity?> getCachedCoinsLeaderboard() {
    return localDataSource.getCachedCoinsLeaderboard();
  }

  @override
  Future<LeaderboardEntity> getCoinsLeaderboard({bool forceRefresh = false}) async {
    try {
      final remoteLeaderboard = await remoteDataSource.getCoinsLeaderboard();
      final rawData = remoteDataSource.lastRawLeaderboardData;
      if (rawData != null) {
        await localDataSource.cacheCoinsLeaderboard(rawData);
      }
      return remoteLeaderboard;
    } catch (e) {
      final cached = await localDataSource.getCachedCoinsLeaderboard();
      if (cached != null && cached.entries.isNotEmpty) {
        return cached;
      }
      rethrow;
    }
  }

  @override
  Future<LeaderboardEntity?> getCachedImpactsLeaderboard() {
    return localDataSource.getCachedImpactsLeaderboard();
  }

  @override
  Future<LeaderboardEntity> getImpactsLeaderboard({bool forceRefresh = false}) async {
    try {
      final remoteLeaderboard = await remoteDataSource.getImpactsLeaderboard();
      final rawData = remoteDataSource.lastRawImpactsLeaderboardData;
      if (rawData != null) {
        await localDataSource.cacheImpactsLeaderboard(rawData);
      }
      return remoteLeaderboard;
    } catch (e) {
      final cached = await localDataSource.getCachedImpactsLeaderboard();
      if (cached != null && cached.entries.isNotEmpty) {
        return cached;
      }
      rethrow;
    }
  }
}
