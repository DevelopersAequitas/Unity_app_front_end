import '../repositories/auth_repository.dart';

class ClearRegistrationDraftUseCase {
  final AuthRepository repository;

  ClearRegistrationDraftUseCase(this.repository);

  Future<void> call() async {
    await repository.clearRegistrationDraft();
  }
}
