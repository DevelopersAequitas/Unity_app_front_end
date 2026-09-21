import '../entities/life_impact_history_entity.dart';
import '../entities/submit_life_impact_params.dart';

abstract class LifeImpactRepository {
  Future<LifeImpactHistoryEntity> getLifeImpactHistory();
  Future<List<String>> getLifeImpactActions();
  Future<void> submitLifeImpact(SubmitLifeImpactParams params);
}
