import '../entities/event_registration_entity.dart';
import '../repositories/events_repository.dart';

class RegisterEventUseCase {
  final EventsRepository repository;

  const RegisterEventUseCase(this.repository);

  Future<EventRegistrationEntity> call({
    required String eventId,
    required String occurrenceId,
    String? couponCode,
    String? reason,
    String? categoryId,
  }) {
    return repository.registerEvent(
      eventId: eventId,
      occurrenceId: occurrenceId,
      couponCode: couponCode,
      reason: reason,
      categoryId: categoryId,
    );
  }
}
