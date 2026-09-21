import '../entities/collaboration_params.dart';
import '../repositories/collaborations_repository.dart';

class SubmitCollaborationUseCase {
  final CollaborationsRepository repository;

  const SubmitCollaborationUseCase(this.repository);

  Future<void> call(CollaborationParams params) async {
    return await repository.submitCollaboration(params);
  }
}
