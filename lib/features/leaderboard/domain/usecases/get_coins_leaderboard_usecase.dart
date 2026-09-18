import '../entities/leaderboard_entity.dart';
import '../repositories/leaderboard_repository.dart';

class GetCoinsLeaderboardUseCase {
  final LeaderboardRepository repository;

  const GetCoinsLeaderboardUseCase(this.repository);

  Future<LeaderboardEntity> call({bool forceRefresh = false}) {
    return repository.getCoinsLeaderboard(forceRefresh: forceRefresh);
  }

  Future<LeaderboardEntity?> getCached() {
    return repository.getCachedCoinsLeaderboard();
  }
}
