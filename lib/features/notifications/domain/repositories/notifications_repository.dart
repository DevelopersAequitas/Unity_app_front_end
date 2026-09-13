import '../entities/notifications_response_entity.dart';

abstract class NotificationsRepository {
  Future<NotificationsResponseEntity> getNotifications({int page = 1});
  Future<bool> markNotificationRead(String id);
  Future<bool> markAllNotificationsRead();
  Future<NotificationsResponseEntity?> getCachedNotifications();
}
