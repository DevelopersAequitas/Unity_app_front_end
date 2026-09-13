import '../../domain/entities/notification_pagination_entity.dart';

class NotificationPaginationModel {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  const NotificationPaginationModel({
    this.currentPage = 1,
    this.lastPage = 1,
    this.perPage = 20,
    this.total = 0,
  });

  factory NotificationPaginationModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const NotificationPaginationModel();
    return NotificationPaginationModel(
      currentPage: (json['current_page'] as num?)?.toInt() ??
          (json['currentPage'] as num?)?.toInt() ??
          1,
      lastPage: (json['last_page'] as num?)?.toInt() ??
          (json['lastPage'] as num?)?.toInt() ??
          1,
      perPage: (json['per_page'] as num?)?.toInt() ??
          (json['perPage'] as num?)?.toInt() ??
          20,
      total: (json['total'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_page': currentPage,
      'last_page': lastPage,
      'per_page': perPage,
      'total': total,
    };
  }

  NotificationPaginationEntity toEntity() {
    return NotificationPaginationEntity(
      currentPage: currentPage,
      lastPage: lastPage,
      perPage: perPage,
      total: total,
    );
  }
}
