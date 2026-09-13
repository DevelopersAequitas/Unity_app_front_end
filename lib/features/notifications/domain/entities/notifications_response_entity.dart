import 'package:equatable/equatable.dart';
import 'notification_entity.dart';
import 'notification_pagination_entity.dart';

class NotificationsResponseEntity extends Equatable {
  final List<NotificationEntity> notifications;
  final NotificationPaginationEntity pagination;
  final int unreadCount;

  const NotificationsResponseEntity({
    this.notifications = const [],
    this.pagination = const NotificationPaginationEntity(),
    this.unreadCount = 0,
  });

  @override
  List<Object?> get props => [notifications, pagination, unreadCount];
}
