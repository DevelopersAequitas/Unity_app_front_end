import '../entities/industry.dart';
import '../repositories/collaborations_repository.dart';

class GetIndustriesTreeUseCase {
  final CollaborationsRepository repository;

  const GetIndustriesTreeUseCase(this.repository);

  Future<List<IndustryParent>> call() async {
    return await repository.getIndustriesTree();
  }
}
