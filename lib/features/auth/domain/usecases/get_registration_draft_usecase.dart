import '../entities/register_params.dart';
import '../repositories/auth_repository.dart';

class GetRegistrationDraftUseCase {
  final AuthRepository repository;

  const GetRegistrationDraftUseCase(this.repository);

  Future<RegisterParams?> call() {
    return repository.getRegistrationDraft();
  }
}
