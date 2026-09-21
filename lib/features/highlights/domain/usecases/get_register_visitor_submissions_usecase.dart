import '../entities/register_visitor_entity.dart';
import '../repositories/register_visitor_repository.dart';

class GetRegisterVisitorSubmissionsUseCase {
  final RegisterVisitorRepository repository;
  const GetRegisterVisitorSubmissionsUseCase(this.repository);

  Future<List<RegisterVisitorEntity>> call() =>
      repository.getRegisterVisitorSubmissions();
}
