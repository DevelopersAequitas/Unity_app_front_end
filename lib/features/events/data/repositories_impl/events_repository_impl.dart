import '../../domain/entities/event_entity.dart';
import '../../domain/entities/event_registration_entity.dart';
import '../../domain/repositories/events_repository.dart';
import '../datasources/events_remote_datasource.dart';

class EventsRepositoryImpl implements EventsRepository {
  final EventsRemoteDataSource remoteDataSource;

  const EventsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Map<String, List<EventEntity>>> getAllEvents({
    String? circleId,
    String? status,
  }) async {
    return remoteDataSource.getAllEvents(
      circleId: circleId,
      status: status,
    );
  }

  @override
  Future<EventEntity> getEventOccurrenceDetail({
    required String eventId,
    required String occurrenceId,
  }) async {
    return remoteDataSource.getEventOccurrenceDetail(
      eventId: eventId,
      occurrenceId: occurrenceId,
    );
  }

  @override
  Future<EventRegistrationEntity> registerEvent({
    required String eventId,
    required String occurrenceId,
    String? couponCode,
    String? reason,
    String? categoryId,
  }) async {
    return remoteDataSource.registerEvent(
      eventId: eventId,
      occurrenceId: occurrenceId,
      couponCode: couponCode,
      reason: reason,
      categoryId: categoryId,
    );
  }

  @override
  Future<EventRegistrationEntity> registerVisitorEvent({
    required String eventId,
    required String occurrenceId,
    required Map<String, dynamic> visitorData,
    String? couponCode,
  }) async {
    return remoteDataSource.registerVisitorEvent(
      eventId: eventId,
      occurrenceId: occurrenceId,
      visitorData: visitorData,
      couponCode: couponCode,
    );
  }

  @override
  Future<EventRegistrationEntity> checkPaymentStatus(String registrationId) async {
    return remoteDataSource.checkPaymentStatus(registrationId);
  }

  @override
  Future<List<EventRegistrationEntity>> getMyEventsWithQr() async {
    return remoteDataSource.getMyEventsWithQr();
  }
}
