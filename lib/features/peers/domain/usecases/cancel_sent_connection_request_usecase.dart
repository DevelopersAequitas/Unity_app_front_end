import '../repositories/peers_repository.dart';

class CancelSentConnectionRequestUseCase {
  final PeersRepository repository;

  CancelSentConnectionRequestUseCase(this.repository);

  Future<void> call(String requestId) {
    return repository.cancelSentConnectionRequest(requestId);
  }
}
