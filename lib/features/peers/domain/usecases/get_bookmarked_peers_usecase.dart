import '../entities/peer_entity.dart';
import '../repositories/peers_repository.dart';

class GetBookmarkedPeersUseCase {
  final PeersRepository repository;

  GetBookmarkedPeersUseCase(this.repository);

  Future<List<PeerEntity>> call({int page = 1, int limit = 20}) {
    return repository.getBookmarkedPeers(page: page, limit: limit);
  }

  Future<List<PeerEntity>> getCached() {
    return repository.getCachedBookmarkedPeers();
  }
}
