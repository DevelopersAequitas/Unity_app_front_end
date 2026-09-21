import '../entities/collaboration.dart';
import '../repositories/collaborations_repository.dart';

class GetCollaborationHistoryUseCase {
  final CollaborationsRepository repository;

  const GetCollaborationHistoryUseCase(this.repository);

  Future<List<Collaboration>> call() async {
    return await repository.getCollaborationHistory();
  }
}
