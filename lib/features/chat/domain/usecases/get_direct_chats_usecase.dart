import '../entities/chat_conversation_entity.dart';
import '../repositories/chat_repository.dart';

class GetDirectChatsUseCase {
  final ChatRepository repository;

  GetDirectChatsUseCase(this.repository);

  Future<List<ChatConversationEntity>> call() {
    return repository.getDirectChats();
  }
}
