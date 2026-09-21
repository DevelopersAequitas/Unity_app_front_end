import '../entities/event_registration_entity.dart';
import '../repositories/events_repository.dart';

class GetMyEventsWithQrUseCase {
  final EventsRepository repository;

  const GetMyEventsWithQrUseCase(this.repository);

  Future<List<EventRegistrationEntity>> call() {
    return repository.getMyEventsWithQr();
  }
}
