import '../entities/ask_item_entity.dart';
import '../repositories/asks_repository.dart';

class GetMyAsksListUseCase {
  final AsksRepository repository;

  GetMyAsksListUseCase(this.repository);

  Future<List<AskItemEntity>> call({
    String? flow,
    String? status,
    int page = 1,
    int perPage = 15,
  }) {
    return repository.getMyAsks(
      flow: flow,
      status: status,
      page: page,
      perPage: perPage,
    );
  }
}
