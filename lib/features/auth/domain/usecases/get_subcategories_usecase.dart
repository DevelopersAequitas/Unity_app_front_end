import '../entities/category_item_entity.dart';
import '../repositories/auth_repository.dart';

class GetSubcategoriesUseCase {
  final AuthRepository repository;

  const GetSubcategoriesUseCase(this.repository);

  Future<List<CategoryItemEntity>> call(dynamic parentId) {
    return repository.getSubcategories(parentId);
  }
}
