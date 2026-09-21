import '../entities/event_entity.dart';
import '../entities/event_registration_entity.dart';

abstract class EventsRepository {
  Future<Map<String, List<EventEntity>>> getAllEvents({
    String? circleId,
    String? status,
  });

  Future<EventEntity> getEventOccurrenceDetail({
    required String eventId,
    required String occurrenceId,
  });

  Future<EventRegistrationEntity> registerEvent({
    required String eventId,
    required String occurrenceId,
    String? couponCode,
    String? reason,
    String? categoryId,
  });

  Future<EventRegistrationEntity> registerVisitorEvent({
    required String eventId,
    required String occurrenceId,
    required Map<String, dynamic> visitorData,
    String? couponCode,
  });

  Future<EventRegistrationEntity> checkPaymentStatus(String registrationId);

  Future<List<EventRegistrationEntity>> getMyEventsWithQr();
}
