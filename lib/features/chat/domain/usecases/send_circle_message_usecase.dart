import '../entities/chat_message_entity.dart';
import '../repositories/chat_repository.dart';

class SendCircleMessageUseCase {
  final ChatRepository repository;

  SendCircleMessageUseCase(this.repository);

  Future<ChatMessageEntity> call(
    String circleId, {
    required String messageText,
    String messageType = 'text',
    String? replyToMessageId,
    String? filePath,
  }) {
    return repository.sendCircleMessage(
      circleId,
      messageText: messageText,
      messageType: messageType,
      replyToMessageId: replyToMessageId,
      filePath: filePath,
    );
  }
}
