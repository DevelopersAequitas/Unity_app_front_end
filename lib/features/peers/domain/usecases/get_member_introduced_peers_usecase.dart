import '../../../highlights/domain/entities/introduced_peer_entity.dart';
import '../repositories/peers_repository.dart';

class GetMemberIntroducedPeersUseCase {
  final PeersRepository repository;

  const GetMemberIntroducedPeersUseCase(this.repository);

  Future<List<IntroducedPeerEntity>> call(String memberId) =>
      repository.getMemberIntroducedPeers(memberId);
}
