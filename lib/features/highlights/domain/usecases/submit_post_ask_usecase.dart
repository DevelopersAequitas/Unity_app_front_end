import '../entities/post_ask_entity.dart';
import '../repositories/post_ask_repository.dart';

class SubmitPostAskUseCase {
  final PostAskRepository repository;

  const SubmitPostAskUseCase(this.repository);

  Future<String> call(PostAskEntity ask) async {
    return repository.submitAsk(ask);
  }
}
