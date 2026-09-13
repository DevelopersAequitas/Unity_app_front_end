import '../entities/peer_entity.dart';
import '../repositories/peers_repository.dart';

class GetMyConnectionsUseCase {
  final PeersRepository repository;

  GetMyConnectionsUseCase(this.repository);

  Future<List<PeerEntity>> call({
    int page = 1,
    int limit = 20,
    String? search,
  }) {
    return repository.getMyConnections(
      page: page,
      limit: limit,
      search: search,
    );
  }

  Future<List<PeerEntity>> getCached() {
    return repository.getCachedMyConnections();
  }
}
