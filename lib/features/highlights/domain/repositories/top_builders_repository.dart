import '../entities/introduced_peer_entity.dart';
import '../entities/top_builder_entity.dart';

abstract class TopBuildersRepository {
  Future<List<TopBuilderEntity>> getTopBuilders();
  Future<List<IntroducedPeerEntity>> getMyIntroducedPeers();
}
