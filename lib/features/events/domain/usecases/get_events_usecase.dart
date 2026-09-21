import '../entities/event_entity.dart';
import '../repositories/events_repository.dart';

class GetEventsUseCase {
  final EventsRepository repository;

  const GetEventsUseCase(this.repository);

  Future<Map<String, List<EventEntity>>> call({
    String? circleId,
    String? status,
  }) {
    return repository.getAllEvents(
      circleId: circleId,
      status: status,
    );
  }
}
