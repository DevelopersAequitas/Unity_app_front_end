import '../entities/event_entity.dart';
import '../repositories/events_repository.dart';

class GetEventDetailUseCase {
  final EventsRepository repository;

  const GetEventDetailUseCase(this.repository);

  Future<EventEntity> call({
    required String eventId,
    required String occurrenceId,
  }) {
    return repository.getEventOccurrenceDetail(
      eventId: eventId,
      occurrenceId: occurrenceId,
    );
  }
}
