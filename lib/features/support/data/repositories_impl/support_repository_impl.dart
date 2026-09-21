import '../../domain/entities/support_ticket_entity.dart';
import '../../domain/repositories/support_repository.dart';
import '../datasources/support_remote_datasource.dart';

class SupportRepositoryImpl implements SupportRepository {
  final SupportRemoteDataSource remoteDataSource;

  const SupportRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<SupportTicketEntity>> getSupportTickets() async {
    final models = await remoteDataSource.getSupportTickets();
    return models;
  }

  @override
  Future<void> submitTicket({
    required String subject,
    required String description,
    required String department,
    required String priority,
    String? mediaFileId,
  }) async {
    final payload = {
      'subject': subject,
      'description': description,
      'department': department,
      'category': department,
      'priority': priority,
      'message': description,
      'screen_name': 'Support Screen',
      if (mediaFileId != null && mediaFileId.isNotEmpty) ...{
        'media_file_id': mediaFileId,
        'media_type': 'image',
      },
    };
    await remoteDataSource.submitTicket(payload);
  }
}
