import '../entities/peer_entity.dart';
import '../repositories/peers_repository.dart';

class GetAllPeersUseCase {
  final PeersRepository repository;

  GetAllPeersUseCase(this.repository);

  Future<List<PeerEntity>> call({
    int page = 1,
    int limit = 20,
    String? search,
    String? sort,
  }) {
    return repository.getAllPeers(
      page: page,
      limit: limit,
      search: search,
      sort: sort,
    );
  }
}
