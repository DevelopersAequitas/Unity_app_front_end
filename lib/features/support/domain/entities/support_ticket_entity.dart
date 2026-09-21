import 'package:equatable/equatable.dart';

class SupportTicketEntity extends Equatable {
  final String id;
  final String subject;
  final String description;
  final String status;
  final String department;
  final String priority;
  final String createdAt;
  final String? adminReply;
  final String? mediaUrl;

  const SupportTicketEntity({
    required this.id,
    required this.subject,
    required this.description,
    required this.status,
    this.department = 'General',
    this.priority = 'Medium',
    this.createdAt = '',
    this.adminReply,
    this.mediaUrl,
  });

  @override
  List<Object?> get props => [
        id,
        subject,
        description,
        status,
        department,
        priority,
        createdAt,
        adminReply,
        mediaUrl,
      ];
}
