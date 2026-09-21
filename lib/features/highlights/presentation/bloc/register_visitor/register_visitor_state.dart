import 'package:equatable/equatable.dart';
import '../../../domain/entities/event_item_entity.dart';
import '../../../domain/entities/register_visitor_entity.dart';

enum RegisterVisitorStatus { initial, loading, success, failure, submitting }

class RegisterVisitorState extends Equatable {
  final RegisterVisitorStatus status;
  final List<RegisterVisitorEntity> submissions;
  final List<EventItemEntity> events;
  final RegisterVisitorStatus eventsStatus;
  final String? errorMessage;
  final String? successMessage;

  const RegisterVisitorState({
    this.status = RegisterVisitorStatus.initial,
    this.submissions = const [],
    this.events = const [],
    this.eventsStatus = RegisterVisitorStatus.initial,
    this.errorMessage,
    this.successMessage,
  });

  RegisterVisitorState copyWith({
    RegisterVisitorStatus? status,
    List<RegisterVisitorEntity>? submissions,
    List<EventItemEntity>? events,
    RegisterVisitorStatus? eventsStatus,
    String? errorMessage,
    String? successMessage,
  }) {
    return RegisterVisitorState(
      status: status ?? this.status,
      submissions: submissions ?? this.submissions,
      events: events ?? this.events,
      eventsStatus: eventsStatus ?? this.eventsStatus,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        submissions,
        events,
        eventsStatus,
        errorMessage,
        successMessage,
      ];
}
