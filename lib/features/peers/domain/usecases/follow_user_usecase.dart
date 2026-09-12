import '../repositories/peers_repository.dart';

class FollowUserUseCase {
  final PeersRepository repository;

  FollowUserUseCase(this.repository);

  Future<void> call(String userId) {
    return repository.followUser(userId);
  }
}
