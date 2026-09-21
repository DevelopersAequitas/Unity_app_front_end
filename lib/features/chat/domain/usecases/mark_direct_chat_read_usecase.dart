import '../repositories/chat_repository.dart';

class MarkDirectChatReadUseCase {
  final ChatRepository repository;

  MarkDirectChatReadUseCase(this.repository);

  Future<bool> call(String chatId) {
    return repository.markDirectChatRead(chatId);
  }
}
