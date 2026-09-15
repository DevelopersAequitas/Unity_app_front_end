import '../entities/circle_closed_category_entity.dart';
import '../repositories/circles_repository.dart';

class GetCircleClosedCategoriesUseCase {
  final CirclesRepository repository;

  GetCircleClosedCategoriesUseCase(this.repository);

  Future<List<CircleClosedCategoryEntity>> call(String circleId) {
    return repository.getCircleClosedCategories(circleId);
  }
}
