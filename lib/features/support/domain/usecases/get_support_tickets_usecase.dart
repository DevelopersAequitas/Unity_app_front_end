import '../entities/support_ticket_entity.dart';
import '../repositories/support_repository.dart';

class GetSupportTicketsUseCase {
  final SupportRepository repository;

  const GetSupportTicketsUseCase(this.repository);

  Future<List<SupportTicketEntity>> call() {
    return repository.getSupportTickets();
  }
}
