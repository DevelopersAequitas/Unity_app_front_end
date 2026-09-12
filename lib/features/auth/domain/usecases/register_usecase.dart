import '../entities/auth_token_entity.dart';
import '../entities/register_params.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  const RegisterUseCase(this.repository);

  Future<({UserEntity user, AuthTokenEntity token})> call(
    RegisterParams params,
  ) {
    return repository.register(params);
  }
}
