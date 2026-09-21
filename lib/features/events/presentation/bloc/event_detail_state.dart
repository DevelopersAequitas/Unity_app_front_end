import 'package:equatable/equatable.dart';
import '../../domain/entities/event_entity.dart';
import '../../domain/entities/event_registration_entity.dart';

enum EventDetailStatus { initial, loading, success, failure, registering, registered, paymentRequired }

class EventDetailState extends Equatable {
  final EventDetailStatus status;
  final EventEntity? event;
  final EventRegistrationEntity? registration;
  final String? errorMessage;
  final String? successMessage;

  const EventDetailState({
    this.status = EventDetailStatus.initial,
    this.event,
    this.registration,
    this.errorMessage,
    this.successMessage,
  });

  bool get isLoading => status == EventDetailStatus.loading;
  bool get isRegistering => status == EventDetailStatus.registering;
  bool get hasQrCode => registration?.qrToken != null || registration?.qrCodeUrl != null;

  EventDetailState copyWith({
    EventDetailStatus? status,
    EventEntity? event,
    EventRegistrationEntity? registration,
    bool clearRegistration = false,
    String? errorMessage,
    String? successMessage,
  }) {
    return EventDetailState(
      status: status ?? this.status,
      event: event ?? this.event,
      registration: clearRegistration ? null : (registration ?? this.registration),
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        event,
        registration,
        errorMessage,
        successMessage,
      ];
}
