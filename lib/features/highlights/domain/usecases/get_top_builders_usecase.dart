import '../entities/top_builder_entity.dart';
import '../repositories/top_builders_repository.dart';

class GetTopBuildersUseCase {
  final TopBuildersRepository repository;
  const GetTopBuildersUseCase(this.repository);

  Future<List<TopBuilderEntity>> call() => repository.getTopBuilders();
}
