import '../entities/message_reader_entity.dart';
import '../repositories/chat_repository.dart';

class GetCircleMessageReadsUseCase {
  final ChatRepository repository;

  GetCircleMessageReadsUseCase(this.repository);

  Future<List<MessageReaderEntity>> call(
    String circleId,
    String messageId,
  ) {
    return repository.getCircleMessageReads(circleId, messageId);
  }
}
