import '../repositories/notifications_repository.dart';

class MarkNotificationReadUseCase {
  final NotificationsRepository repository;

  MarkNotificationReadUseCase(this.repository);

  Future<bool> call(String id) {
    return repository.markNotificationRead(id);
  }
}
