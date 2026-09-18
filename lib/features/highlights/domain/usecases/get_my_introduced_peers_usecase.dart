import '../entities/introduced_peer_entity.dart';
import '../repositories/top_builders_repository.dart';

class GetMyIntroducedPeersUseCase {
  final TopBuildersRepository repository;
  const GetMyIntroducedPeersUseCase(this.repository);

  Future<List<IntroducedPeerEntity>> call() => repository.getMyIntroducedPeers();
}
