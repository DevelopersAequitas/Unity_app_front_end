import '../entities/match_peer_entity.dart';
import '../repositories/peers_repository.dart';

class GetMatchPeersUseCase {
  final PeersRepository repository;

  GetMatchPeersUseCase(this.repository);

  Future<List<MatchPeerEntity>> call() {
    return repository.getMatchPeers();
  }

  Future<List<MatchPeerEntity>> getCached() {
    return repository.getCachedMatches();
  }
}
