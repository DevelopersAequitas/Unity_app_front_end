import '../repositories/chat_repository.dart';

class DeleteLeadershipMessageUseCase {
  final ChatRepository repository;

  DeleteLeadershipMessageUseCase(this.repository);

  Future<bool> call(
    String circleId,
    String messageId, {
    required bool forEveryone,
  }) {
    return repository.deleteLeadershipMessage(
      circleId,
      messageId,
      forEveryone: forEveryone,
    );
  }
}
