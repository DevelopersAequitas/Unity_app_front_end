import 'package:equatable/equatable.dart';

abstract class EventDetailEvent extends Equatable {
  const EventDetailEvent();

  @override
  List<Object?> get props => [];
}

class LoadEventDetailEvent extends EventDetailEvent {
  final String eventId;
  final String occurrenceId;
  final bool isRefresh;

  const LoadEventDetailEvent({
    required this.eventId,
    required this.occurrenceId,
    this.isRefresh = false,
  });

  @override
  List<Object?> get props => [eventId, occurrenceId, isRefresh];
}

class AttendEventEvent extends EventDetailEvent {
  final String eventId;
  final String occurrenceId;
  final String? couponCode;
  final String? reason;
  final String? categoryId;

  const AttendEventEvent({
    required this.eventId,
    required this.occurrenceId,
    this.couponCode,
    this.reason,
    this.categoryId,
  });

  @override
  List<Object?> get props => [eventId, occurrenceId, couponCode, reason, categoryId];
}

class RegisterVisitorEventEvent extends EventDetailEvent {
  final String eventId;
  final String occurrenceId;
  final Map<String, dynamic> visitorData;
  final String? couponCode;

  const RegisterVisitorEventEvent({
    required this.eventId,
    required this.occurrenceId,
    required this.visitorData,
    this.couponCode,
  });

  @override
  List<Object?> get props => [eventId, occurrenceId, visitorData, couponCode];
}

class PollPaymentStatusEvent extends EventDetailEvent {
  final String registrationId;

  const PollPaymentStatusEvent(this.registrationId);

  @override
  List<Object?> get props => [registrationId];
}
