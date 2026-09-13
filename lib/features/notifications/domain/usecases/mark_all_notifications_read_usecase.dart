import '../repositories/notifications_repository.dart';

class MarkAllNotificationsReadUseCase {
  final NotificationsRepository repository;

  MarkAllNotificationsReadUseCase(this.repository);

  Future<bool> call() {
    return repository.markAllNotificationsRead();
  }
}
