import '../repositories/chat_repository.dart';

class DeleteDirectMessageUseCase {
  final ChatRepository repository;

  DeleteDirectMessageUseCase(this.repository);

  Future<bool> call(String messageId, {required bool forEveryone}) {
    return repository.deleteDirectMessage(
      messageId,
      forEveryone: forEveryone,
    );
  }
}
