import 'package:equatable/equatable.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/entities/notification_pagination_entity.dart';

enum NotificationsStatus { initial, loading, success, error }

class NotificationsState extends Equatable {
  final NotificationsStatus status;
  final List<NotificationEntity> notifications;
  final NotificationPaginationEntity pagination;
  final int unreadCount;
  final bool isLoadingMore;
  final String activeFilter;
  final String? errorMessage;

  const NotificationsState({
    this.status = NotificationsStatus.initial,
    this.notifications = const [],
    this.pagination = const NotificationPaginationEntity(),
    this.unreadCount = 0,
    this.isLoadingMore = false,
    this.activeFilter = 'all',
    this.errorMessage,
  });

  List<NotificationEntity> get filteredNotifications {
    if (activeFilter == 'unread') {
      return notifications.where((n) => !n.isRead).toList();
    }
    return notifications;
  }

  NotificationsState copyWith({
    NotificationsStatus? status,
    List<NotificationEntity>? notifications,
    NotificationPaginationEntity? pagination,
    int? unreadCount,
    bool? isLoadingMore,
    String? activeFilter,
    String? errorMessage,
    bool clearError = false,
  }) {
    return NotificationsState(
      status: status ?? this.status,
      notifications: notifications ?? this.notifications,
      pagination: pagination ?? this.pagination,
      unreadCount: unreadCount ?? this.unreadCount,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      activeFilter: activeFilter ?? this.activeFilter,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
        status,
        notifications,
        pagination,
        unreadCount,
        isLoadingMore,
        activeFilter,
        errorMessage,
      ];
}
