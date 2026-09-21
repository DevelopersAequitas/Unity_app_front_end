import '../entities/support_ticket_entity.dart';

abstract class SupportRepository {
  Future<List<SupportTicketEntity>> getSupportTickets();
  Future<void> submitTicket({
    required String subject,
    required String description,
    required String department,
    required String priority,
    String? mediaFileId,
  });
}
