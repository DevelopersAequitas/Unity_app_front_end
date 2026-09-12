import '../repositories/peers_repository.dart';

class UnfollowUserUseCase {
  final PeersRepository repository;

  UnfollowUserUseCase(this.repository);

  Future<void> call(String userId) {
    return repository.unfollowUser(userId);
  }
}
