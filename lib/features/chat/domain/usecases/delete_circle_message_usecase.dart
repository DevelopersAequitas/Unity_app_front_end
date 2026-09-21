import '../repositories/chat_repository.dart';

class DeleteCircleMessageUseCase {
  final ChatRepository repository;

  DeleteCircleMessageUseCase(this.repository);

  Future<bool> call(
    String circleId,
    String messageId, {
    required bool forEveryone,
  }) {
    return repository.deleteCircleMessage(
      circleId,
      messageId,
      forEveryone: forEveryone,
    );
  }
}
