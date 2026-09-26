import '../entities/ask_match_peer_entity.dart';
import '../repositories/asks_repository.dart';

class GetAskMatchesUseCase {
  final AsksRepository repository;

  GetAskMatchesUseCase({required this.repository});

  Future<List<AskMatchPeerEntity>> execute(String askId) {
    return repository.getAskMatches(askId);
  }
}
