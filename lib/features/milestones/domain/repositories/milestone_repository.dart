import '../entities/milestone_entity.dart';

abstract class MilestoneRepository {
  Future<LatestMilestoneEntity> getLatestMilestone(
    String userId, {
    bool forceRefresh = false,
  });
  Future<List<MilestoneItemEntity>> getMilestoneHistory(
    String userId, {
    bool forceRefresh = false,
  });
}
