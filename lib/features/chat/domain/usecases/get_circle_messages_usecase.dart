import '../entities/chat_message_entity.dart';
import '../repositories/chat_repository.dart';

class GetCircleMessagesUseCase {
  final ChatRepository repository;

  GetCircleMessagesUseCase(this.repository);

  Future<List<ChatMessageEntity>> call(
    String circleId, {
    int page = 1,
    int perPage = 20,
    String? beforeMessageId,
  }) {
    return repository.getCircleMessages(
      circleId,
      page: page,
      perPage: perPage,
      beforeMessageId: beforeMessageId,
    );
  }
}
