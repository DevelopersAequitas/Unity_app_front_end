import '../entities/event_registration_entity.dart';
import '../repositories/events_repository.dart';

class RegisterVisitorEventUseCase {
  final EventsRepository repository;

  const RegisterVisitorEventUseCase(this.repository);

  Future<EventRegistrationEntity> call({
    required String eventId,
    required String occurrenceId,
    required Map<String, dynamic> visitorData,
    String? couponCode,
  }) {
    return repository.registerVisitorEvent(
      eventId: eventId,
      occurrenceId: occurrenceId,
      visitorData: visitorData,
      couponCode: couponCode,
    );
  }
}
