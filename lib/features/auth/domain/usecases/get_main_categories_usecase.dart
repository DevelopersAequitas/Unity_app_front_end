import '../entities/category_item_entity.dart';
import '../repositories/auth_repository.dart';

class GetMainCategoriesUseCase {
  final AuthRepository repository;

  const GetMainCategoriesUseCase(this.repository);

  Future<List<CategoryItemEntity>> call() {
    return repository.getMainCategories();
  }
}
