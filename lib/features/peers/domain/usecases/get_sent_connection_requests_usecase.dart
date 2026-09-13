import '../entities/peer_request_entity.dart';
import '../repositories/peers_repository.dart';

class GetSentConnectionRequestsUseCase {
  final PeersRepository repository;

  GetSentConnectionRequestsUseCase(this.repository);

  Future<List<PeerRequestEntity>> call({int page = 1, int limit = 20}) {
    return repository.getSentConnectionRequests(page: page, limit: limit);
  }

  Future<List<PeerRequestEntity>> getCached() {
    return repository.getCachedSentConnectionRequests();
  }
}
