import '../entities/p2p_meeting_leaderboard_entity.dart';
import '../repositories/p2p_meetings_repository.dart';

class GetP2pMeetingsLeaderboardUseCase {
  final P2pMeetingsRepository repository;

  GetP2pMeetingsLeaderboardUseCase(this.repository);

  Future<List<P2pMeetingLeaderboardEntity>> call() {
    return repository.getP2pMeetingsLeaderboard();
  }
}
