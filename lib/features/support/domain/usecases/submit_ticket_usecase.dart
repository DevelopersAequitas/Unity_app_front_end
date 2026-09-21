import '../repositories/support_repository.dart';

class SubmitTicketUseCase {
  final SupportRepository repository;

  const SubmitTicketUseCase(this.repository);

  Future<void> call({
    required String subject,
    required String description,
    required String department,
    required String priority,
    String? mediaFileId,
  }) {
    return repository.submitTicket(
      subject: subject,
      description: description,
      department: department,
      priority: priority,
      mediaFileId: mediaFileId,
    );
  }
}
