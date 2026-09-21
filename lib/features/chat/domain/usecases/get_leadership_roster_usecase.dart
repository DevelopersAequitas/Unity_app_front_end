import '../entities/leadership_roster_entity.dart';
import '../repositories/chat_repository.dart';

class GetLeadershipRosterUseCase {
  final ChatRepository repository;

  GetLeadershipRosterUseCase(this.repository);

  Future<LeadershipRosterEntity> call(String circleId) {
    return repository.getLeadershipRoster(circleId);
  }
}
