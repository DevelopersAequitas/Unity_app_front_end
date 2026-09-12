import '../entities/auth_token_entity.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class GetCachedAuthUseCase {
  final AuthRepository _repository;

  const GetCachedAuthUseCase(this._repository);

  Future<({UserEntity? user, AuthTokenEntity? token})> call() {
    return _repository.getCachedAuth();
  }
}
