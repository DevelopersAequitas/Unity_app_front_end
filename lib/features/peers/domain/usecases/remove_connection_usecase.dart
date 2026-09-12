import '../repositories/peers_repository.dart';

class RemoveConnectionUseCase {
  final PeersRepository repository;

  const RemoveConnectionUseCase(this.repository);

  Future<void> call(String memberId) {
    return repository.removeConnection(memberId);
  }
}
