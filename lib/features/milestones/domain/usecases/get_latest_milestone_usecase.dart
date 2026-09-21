import '../entities/milestone_entity.dart';
import '../repositories/milestone_repository.dart';

class GetLatestMilestoneUseCase {
  final MilestoneRepository repository;

  const GetLatestMilestoneUseCase(this.repository);

  Future<LatestMilestoneEntity> execute(
    String userId, {
    bool forceRefresh = false,
  }) {
    return repository.getLatestMilestone(userId, forceRefresh: forceRefresh);
  }
}
