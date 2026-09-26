import '../entities/ask_response_item_entity.dart';
import '../repositories/asks_repository.dart';

class GetAskResponsesUseCase {
  final AsksRepository repository;

  GetAskResponsesUseCase({required this.repository});

  Future<List<AskResponseItemEntity>> execute(String askId) {
    return repository.getAskResponses(askId);
  }
}
