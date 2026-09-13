import '../entities/notifications_response_entity.dart';
import '../repositories/notifications_repository.dart';

class GetNotificationsUseCase {
  final NotificationsRepository repository;

  GetNotificationsUseCase(this.repository);

  Future<NotificationsResponseEntity> call({int page = 1}) {
    return repository.getNotifications(page: page);
  }
}
