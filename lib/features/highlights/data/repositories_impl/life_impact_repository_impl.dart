import '../../domain/entities/life_impact_history_entity.dart';
import '../../domain/entities/submit_life_impact_params.dart';
import '../../domain/repositories/life_impact_repository.dart';
import '../datasources/life_impact_remote_datasource.dart';

class LifeImpactRepositoryImpl implements LifeImpactRepository {
  final LifeImpactRemoteDataSource remoteDataSource;

  const LifeImpactRepositoryImpl({required this.remoteDataSource});

  @override
  Future<LifeImpactHistoryEntity> getLifeImpactHistory() async {
    final model = await remoteDataSource.getLifeImpactHistory();
    return model.toEntity();
  }

  @override
  Future<List<String>> getLifeImpactActions() async {
    return await remoteDataSource.getLifeImpactActions();
  }

  @override
  Future<void> submitLifeImpact(SubmitLifeImpactParams params) async {
    await remoteDataSource.submitLifeImpact(params);
  }
}
