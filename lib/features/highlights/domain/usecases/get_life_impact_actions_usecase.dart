import '../repositories/life_impact_repository.dart';

class GetLifeImpactActionsUseCase {
  final LifeImpactRepository repository;
  const GetLifeImpactActionsUseCase(this.repository);

  Future<List<String>> call() => repository.getLifeImpactActions();
}
