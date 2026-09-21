import '../entities/submit_life_impact_params.dart';
import '../repositories/life_impact_repository.dart';

class SubmitLifeImpactUseCase {
  final LifeImpactRepository repository;
  const SubmitLifeImpactUseCase(this.repository);

  Future<void> call(SubmitLifeImpactParams params) =>
      repository.submitLifeImpact(params);
}
