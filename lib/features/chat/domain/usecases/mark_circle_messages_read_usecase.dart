import '../repositories/chat_repository.dart';

class MarkCircleMessagesReadUseCase {
  final ChatRepository repository;

  MarkCircleMessagesReadUseCase(this.repository);

  Future<bool> call(String circleId, List<String> messageIds) {
    return repository.markCircleMessagesRead(circleId, messageIds);
  }
}
