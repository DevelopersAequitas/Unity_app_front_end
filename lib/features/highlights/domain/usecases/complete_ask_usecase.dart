import '../repositories/post_ask_repository.dart';

class CompleteAskUseCase {
  final PostAskRepository repository;

  const CompleteAskUseCase(this.repository);

  Future<void> call(String id, {String? subject}) async {
    return repository.completeAsk(id, subject: subject);
  }
}
