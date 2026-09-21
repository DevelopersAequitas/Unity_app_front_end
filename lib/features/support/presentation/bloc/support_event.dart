import 'package:equatable/equatable.dart';

abstract class SupportEvent extends Equatable {
  const SupportEvent();

  @override
  List<Object?> get props => [];
}

class SupportTicketsFetchRequested extends SupportEvent {
  const SupportTicketsFetchRequested();
}

class SupportTicketSubmitRequested extends SupportEvent {
  final String subject;
  final String description;
  final String department;
  final String priority;
  final String? mediaFileId;

  const SupportTicketSubmitRequested({
    required this.subject,
    required this.description,
    required this.department,
    required this.priority,
    this.mediaFileId,
  });

  @override
  List<Object?> get props => [
        subject,
        description,
        department,
        priority,
        mediaFileId,
      ];
}
