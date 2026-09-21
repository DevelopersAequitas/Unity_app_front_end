import '../repositories/chat_repository.dart';

class MarkLeadershipMessagesReadUseCase {
  final ChatRepository repository;

  MarkLeadershipMessagesReadUseCase(this.repository);

  Future<bool> call(String circleId, List<String> messageIds) {
    return repository.markLeadershipMessagesRead(circleId, messageIds);
  }
}
