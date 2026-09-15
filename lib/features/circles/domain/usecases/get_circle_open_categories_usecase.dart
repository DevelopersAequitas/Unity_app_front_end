import '../entities/circle_open_category_entity.dart';
import '../repositories/circles_repository.dart';

class GetCircleOpenCategoriesUseCase {
  final CirclesRepository repository;

  GetCircleOpenCategoriesUseCase(this.repository);

  Future<List<CircleOpenCategoryEntity>> call(String circleId) {
    return repository.getCircleOpenCategories(circleId);
  }
}
