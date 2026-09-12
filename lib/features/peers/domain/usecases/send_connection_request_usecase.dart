import '../repositories/peers_repository.dart';

class SendConnectionRequestUseCase {
  final PeersRepository repository;

  SendConnectionRequestUseCase(this.repository);

  Future<void> call(String memberId) {
    return repository.sendConnectionRequest(memberId);
  }
}
