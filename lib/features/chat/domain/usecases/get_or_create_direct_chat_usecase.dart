import '../entities/chat_conversation_entity.dart';
import '../repositories/chat_repository.dart';

class GetOrCreateDirectChatUseCase {
  final ChatRepository repository;

  GetOrCreateDirectChatUseCase(this.repository);

  Future<ChatConversationEntity> call(String userId) {
    return repository.getOrCreateDirectChat(userId);
  }
}
