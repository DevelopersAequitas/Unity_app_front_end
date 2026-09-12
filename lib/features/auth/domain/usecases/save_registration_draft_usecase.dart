import '../entities/register_params.dart';
import '../repositories/auth_repository.dart';

class SaveRegistrationDraftUseCase {
  final AuthRepository repository;

  const SaveRegistrationDraftUseCase(this.repository);

  Future<void> call(RegisterParams params) {
    return repository.saveRegistrationDraft(params);
  }
}
