import '../entities/post_ask_entity.dart';
import '../repositories/post_ask_repository.dart';

class GetMyAsksUseCase {
  final PostAskRepository repository;

  const GetMyAsksUseCase(this.repository);

  Future<List<PostAskEntity>> call() async {
    return repository.getMyAsks();
  }
}
