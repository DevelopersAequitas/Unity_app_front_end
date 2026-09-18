import '../repositories/life_impact_repository.dart';

class SubmitLifeImpactUseCase {
  final LifeImpactRepository repository;
  const SubmitLifeImpactUseCase(this.repository);

  Future<void> call({
    required String title,
    required String description,
    required String category,
    required int impactPoints,
  }) =>
      repository.submitLifeImpact(
        title: title,
        description: description,
        category: category,
        impactPoints: impactPoints,
      );
}
