import '../entities/life_impact_entity.dart';
import '../repositories/life_impact_repository.dart';

class GetLifeImpactHistoryUseCase {
  final LifeImpactRepository repository;
  const GetLifeImpactHistoryUseCase(this.repository);

  Future<List<LifeImpactEntity>> call() =>
      repository.getLifeImpactHistory();
}
