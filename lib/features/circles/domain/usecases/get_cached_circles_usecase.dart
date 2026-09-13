import '../entities/circle_category_entity.dart';
import '../entities/circle_entity.dart';
import '../repositories/circles_repository.dart';

class GetCachedCirclesUseCase {
  final CirclesRepository repository;

  GetCachedCirclesUseCase(this.repository);

  Future<List<CircleEntity>> getMyCircles() =>
      repository.getCachedMyCircles();

  Future<List<CircleCategoryEntity>> getCategories() =>
      repository.getCachedCircleCategories();
}
