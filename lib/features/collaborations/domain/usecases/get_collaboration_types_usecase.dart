import '../entities/collaboration_type.dart';
import '../repositories/collaborations_repository.dart';

class GetCollaborationTypesUseCase {
  final CollaborationsRepository repository;

  const GetCollaborationTypesUseCase(this.repository);

  Future<List<CollaborationType>> call() async {
    return await repository.getCollaborationTypes();
  }
}
