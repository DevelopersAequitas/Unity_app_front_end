import '../entities/menu_summary_entity.dart';
import '../repositories/menu_repository.dart';

class GetMenuSummaryUseCase {
  final MenuRepository repository;

  const GetMenuSummaryUseCase(this.repository);

  Future<MenuSummaryEntity> call() async {
    return await repository.getMenuSummary();
  }
}
