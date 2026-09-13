import '../entities/circle_category_entity.dart';
import '../repositories/circles_repository.dart';

class GetCircleCategoriesUseCase {
  final CirclesRepository repository;

  GetCircleCategoriesUseCase(this.repository);

  Future<List<CircleCategoryEntity>> call() =>
      repository.getCircleCategories();
}
