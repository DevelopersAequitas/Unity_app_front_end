import '../repositories/peers_repository.dart';

class AcceptConnectionRequestUseCase {
  final PeersRepository repository;

  AcceptConnectionRequestUseCase(this.repository);

  Future<void> call(String requesterId) {
    return repository.acceptConnectionRequest(requesterId);
  }
}
