import '../entities/peer_request_entity.dart';
import '../repositories/peers_repository.dart';

class GetConnectionRequestsUseCase {
  final PeersRepository repository;

  GetConnectionRequestsUseCase(this.repository);

  Future<List<PeerRequestEntity>> call({int page = 1, int limit = 20}) {
    return repository.getConnectionRequests(page: page, limit: limit);
  }
}
