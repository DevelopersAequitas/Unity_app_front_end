import '../entities/chat_message_entity.dart';
import '../repositories/chat_repository.dart';

class SendDirectMessageUseCase {
  final ChatRepository repository;

  SendDirectMessageUseCase(this.repository);

  Future<ChatMessageEntity> call(
    String chatId, {
    required String content,
    String? filePath,
    String? fileType,
  }) {
    return repository.sendDirectMessage(
      chatId,
      content: content,
      filePath: filePath,
      fileType: fileType,
    );
  }
}
