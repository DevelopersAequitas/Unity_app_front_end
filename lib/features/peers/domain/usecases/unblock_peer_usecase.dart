import '../repositories/peers_repository.dart';

class UnblockPeerUseCase {
  final PeersRepository repository;

  UnblockPeerUseCase(this.repository);

  Future<bool> call(String peerId) {
    return repository.unblockPeer(peerId);
  }
}
