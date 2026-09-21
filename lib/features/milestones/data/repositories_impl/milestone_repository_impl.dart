import '../../domain/entities/milestone_entity.dart';
import '../../domain/repositories/milestone_repository.dart';
import '../datasources/milestone_remote_datasource.dart';

class MilestoneRepositoryImpl implements MilestoneRepository {
  final MilestoneRemoteDataSource remoteDataSource;

  const MilestoneRepositoryImpl({required this.remoteDataSource});

  @override
  Future<LatestMilestoneEntity> getLatestMilestone(
    String userId, {
    bool forceRefresh = false,
  }) async {
    final model = await remoteDataSource.getLatestMilestone(
      userId,
      forceRefresh: forceRefresh,
    );
    return model.toEntity();
  }

  @override
  Future<List<MilestoneItemEntity>> getMilestoneHistory(
    String userId, {
    bool forceRefresh = false,
  }) async {
    final models = await remoteDataSource.getMilestoneHistory(
      userId,
      forceRefresh: forceRefresh,
    );
    return models.map((m) => m.toEntity()).toList();
  }
}
