import '../repositories/chat_repository.dart';

class SetTypingStatusUseCase {
  final ChatRepository repository;

  SetTypingStatusUseCase(this.repository);

  Future<bool> call(String chatId, {required bool isTyping}) {
    return repository.setTypingStatus(chatId, isTyping: isTyping);
  }
}
