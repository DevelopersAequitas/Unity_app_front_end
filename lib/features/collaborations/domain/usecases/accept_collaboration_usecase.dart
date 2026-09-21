import '../repositories/collaborations_repository.dart';

class AcceptCollaborationUseCase {
  final CollaborationsRepository repository;

  const AcceptCollaborationUseCase(this.repository);

  Future<void> call(String collaborationId) async {
    return await repository.acceptCollaboration(collaborationId);
  }
}
