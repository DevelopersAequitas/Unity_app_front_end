import '../repositories/peers_repository.dart';

class DeclineConnectionRequestUseCase {
  final PeersRepository repository;

  DeclineConnectionRequestUseCase(this.repository);

  Future<void> call(String memberId) {
    return repository.declineConnectionRequest(memberId);
  }
}
