import '../entities/notifications_response_entity.dart';
import '../repositories/notifications_repository.dart';

class GetCachedNotificationsUseCase {
  final NotificationsRepository repository;

  GetCachedNotificationsUseCase(this.repository);

  Future<NotificationsResponseEntity?> call() {
    return repository.getCachedNotifications();
  }
}
