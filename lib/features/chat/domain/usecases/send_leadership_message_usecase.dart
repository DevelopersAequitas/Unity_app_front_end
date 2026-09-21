import '../entities/chat_message_entity.dart';
import '../repositories/chat_repository.dart';

class SendLeadershipMessageUseCase {
  final ChatRepository repository;

  SendLeadershipMessageUseCase(this.repository);

  Future<ChatMessageEntity> call(
    String circleId, {
    required String messageText,
    String messageType = 'text',
    String? replyToMessageId,
    String? filePath,
  }) {
    return repository.sendLeadershipMessage(
      circleId,
      messageText: messageText,
      messageType: messageType,
      replyToMessageId: replyToMessageId,
      filePath: filePath,
    );
  }
}
