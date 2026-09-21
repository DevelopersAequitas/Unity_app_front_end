import '../entities/life_impact_history_entity.dart';
import '../repositories/life_impact_repository.dart';

class GetLifeImpactHistoryUseCase {
  final LifeImpactRepository repository;
  const GetLifeImpactHistoryUseCase(this.repository);

  Future<LifeImpactHistoryEntity> call() =>
      repository.getLifeImpactHistory();
}
