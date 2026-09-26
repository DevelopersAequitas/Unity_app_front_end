import '../entities/ask_item_entity.dart';
import '../repositories/asks_repository.dart';

class GetPeersFeedUseCase {
  final AsksRepository repository;

  GetPeersFeedUseCase(this.repository);

  Future<List<AskItemEntity>> call({
    String? scope,
    int page = 1,
    int perPage = 15,
  }) async {
    return await repository.getPeersFeed(
      scope: scope,
      page: page,
      perPage: perPage,
    );
  }
}
