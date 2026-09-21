import '../entities/milestone_entity.dart';
import '../repositories/milestone_repository.dart';

class GetMilestoneHistoryUseCase {
  final MilestoneRepository repository;

  const GetMilestoneHistoryUseCase(this.repository);

  Future<List<MilestoneItemEntity>> execute(
    String userId, {
    bool forceRefresh = false,
  }) {
    return repository.getMilestoneHistory(userId, forceRefresh: forceRefresh);
  }
}
