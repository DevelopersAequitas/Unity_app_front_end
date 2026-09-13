import '../../domain/entities/notifications_response_entity.dart';
import 'notification_model.dart';
import 'notification_pagination_model.dart';

class NotificationsResponseModel {
  final List<NotificationModel> notifications;
  final NotificationPaginationModel pagination;
  final int unreadCount;

  const NotificationsResponseModel({
    this.notifications = const [],
    this.pagination = const NotificationPaginationModel(),
    this.unreadCount = 0,
  });

  factory NotificationsResponseModel.fromJson(Map<String, dynamic> json) {
    final dynamic data = json['data'] ?? json;
    List<NotificationModel> notifs = [];
    NotificationPaginationModel pag = const NotificationPaginationModel();
    int unread = 0;

    if (data is Map<String, dynamic>) {
      final rawList = data['notifications'] ?? data['items'] ?? data['data'];
      if (rawList is List) {
        notifs = rawList
            .whereType<Map<String, dynamic>>()
            .map((item) => NotificationModel.fromJson(item))
            .toList();
      }

      final rawPagination = data['pagination'];
      if (rawPagination is Map<String, dynamic>) {
        pag = NotificationPaginationModel.fromJson(rawPagination);
      } else {
        pag = NotificationPaginationModel(
          currentPage: (data['current_page'] as num?)?.toInt() ?? 1,
          lastPage: (data['last_page'] as num?)?.toInt() ?? 1,
          perPage: (data['per_page'] as num?)?.toInt() ?? 20,
          total: (data['total'] as num?)?.toInt() ?? notifs.length,
        );
      }

      unread = (data['unread_count'] as num?)?.toInt() ??
          (json['unread_count'] as num?)?.toInt() ??
          (data['unreadCount'] as num?)?.toInt() ??
          0;
    } else if (data is List) {
      notifs = data
          .whereType<Map<String, dynamic>>()
          .map((item) => NotificationModel.fromJson(item))
          .toList();
      pag = NotificationPaginationModel(
        currentPage: 1,
        lastPage: 1,
        perPage: notifs.length,
        total: notifs.length,
      );
      unread = (json['unread_count'] as num?)?.toInt() ?? 0;
    }

    return NotificationsResponseModel(
      notifications: notifs,
      pagination: pag,
      unreadCount: unread,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': {
        'notifications': notifications.map((n) => n.toJson()).toList(),
        'pagination': pagination.toJson(),
        'unread_count': unreadCount,
      },
    };
  }

  NotificationsResponseEntity toEntity() {
    return NotificationsResponseEntity(
      notifications: notifications.map((n) => n.toEntity()).toList(),
      pagination: pagination.toEntity(),
      unreadCount: unreadCount,
    );
  }
}
