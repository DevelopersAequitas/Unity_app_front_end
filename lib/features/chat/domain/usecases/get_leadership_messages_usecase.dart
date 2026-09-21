import '../entities/chat_message_entity.dart';
import '../repositories/chat_repository.dart';

class GetLeadershipMessagesUseCase {
  final ChatRepository repository;

  GetLeadershipMessagesUseCase(this.repository);

  Future<List<ChatMessageEntity>> call(
    String circleId, {
    int page = 1,
    int perPage = 20,
  }) {
    return repository.getLeadershipMessages(
      circleId,
      page: page,
      perPage: perPage,
    );
  }
}
