import '../entities/event_registration_entity.dart';
import '../repositories/events_repository.dart';

class CheckPaymentStatusUseCase {
  final EventsRepository repository;

  const CheckPaymentStatusUseCase(this.repository);

  Future<EventRegistrationEntity> call(String registrationId) {
    return repository.checkPaymentStatus(registrationId);
  }
}
