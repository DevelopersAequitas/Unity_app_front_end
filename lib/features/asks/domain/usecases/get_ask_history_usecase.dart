import '../entities/ask_history_item_entity.dart';
import '../repositories/asks_repository.dart';

class GetAskHistoryUseCase {
  final AsksRepository repository;

  GetAskHistoryUseCase(this.repository);

  Future<List<AskHistoryItemEntity>> call(String askId) {
    return repository.getAskHistory(askId);
  }
}
