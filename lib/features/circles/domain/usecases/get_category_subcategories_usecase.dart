import '../entities/circle_category_entity.dart';
import '../repositories/circles_repository.dart';

class GetCategorySubcategoriesUseCase {
  final CirclesRepository repository;

  const GetCategorySubcategoriesUseCase(this.repository);

  Future<List<CircleCategoryEntity>> call(String categoryId) {
    return repository.getCategorySubcategories(categoryId);
  }
}
