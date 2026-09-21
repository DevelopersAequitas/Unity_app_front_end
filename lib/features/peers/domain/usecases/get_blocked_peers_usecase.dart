import '../repositories/peers_repository.dart';

class GetBlockedPeersUseCase {
  final PeersRepository repository;

  GetBlockedPeersUseCase(this.repository);

  Future<List<Map<String, dynamic>>> call() {
    return repository.getBlockedPeers();
  }
}
