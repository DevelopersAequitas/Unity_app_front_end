import '../entities/leaderboard_entity.dart';
import '../repositories/leaderboard_repository.dart';

class GetImpactsLeaderboardUseCase {
  final LeaderboardRepository repository;

  const GetImpactsLeaderboardUseCase(this.repository);

  Future<LeaderboardEntity> call({bool forceRefresh = false}) {
    return repository.getImpactsLeaderboard(forceRefresh: forceRefresh);
  }

  Future<LeaderboardEntity?> getCached() {
    return repository.getCachedImpactsLeaderboard();
  }
}
