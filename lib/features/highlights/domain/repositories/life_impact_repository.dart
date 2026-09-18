import '../entities/life_impact_entity.dart';

abstract class LifeImpactRepository {
  Future<List<LifeImpactEntity>> getLifeImpactHistory();
  Future<void> submitLifeImpact({
    required String title,
    required String description,
    required String category,
    required int impactPoints,
  });
}
