import '../entities/chat_message_entity.dart';
import '../repositories/chat_repository.dart';

class GetDirectMessagesUseCase {
  final ChatRepository repository;

  GetDirectMessagesUseCase(this.repository);

  Future<List<ChatMessageEntity>> call(
    String chatId, {
    int page = 1,
    int perPage = 50,
  }) {
    return repository.getDirectMessages(
      chatId,
      page: page,
      perPage: perPage,
    );
  }
}
