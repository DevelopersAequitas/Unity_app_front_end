import '../repositories/peers_repository.dart';

class GetPeerBlockStatusUseCase {
  final PeersRepository repository;

  GetPeerBlockStatusUseCase(this.repository);

  Future<bool> call(String peerId) {
    return repository.getPeerBlockStatus(peerId);
  }
}
