import '../repositories/peers_repository.dart';

class BlockPeerUseCase {
  final PeersRepository repository;

  BlockPeerUseCase(this.repository);

  Future<bool> call(String peerId, {String reason = 'Spam messages'}) {
    return repository.blockPeer(peerId, reason: reason);
  }
}
