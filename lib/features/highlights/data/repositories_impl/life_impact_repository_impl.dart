import '../../domain/entities/life_impact_entity.dart';
import '../../domain/repositories/life_impact_repository.dart';
import '../datasources/life_impact_remote_datasource.dart';

class LifeImpactRepositoryImpl implements LifeImpactRepository {
  final LifeImpactRemoteDataSource remoteDataSource;

  const LifeImpactRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<LifeImpactEntity>> getLifeImpactHistory() async {
    final models = await remoteDataSource.getLifeImpactHistory();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> submitLifeImpact({
    required String title,
    required String description,
    required String category,
    required int impactPoints,
  }) {
    return remoteDataSource.submitLifeImpact(
      title: title,
      description: description,
      category: category,
      impactPoints: impactPoints,
    );
  }
}
