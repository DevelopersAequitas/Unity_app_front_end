import '../entities/chat_conversation_entity.dart';
import '../repositories/chat_repository.dart';

class GetDirectChatDetailUseCase {
  final ChatRepository repository;

  GetDirectChatDetailUseCase(this.repository);

  Future<ChatConversationEntity> call(String chatId) {
    return repository.getDirectChatDetail(chatId);
  }
}
