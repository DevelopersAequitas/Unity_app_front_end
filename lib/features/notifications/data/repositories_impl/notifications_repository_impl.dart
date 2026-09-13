import '../../domain/entities/notifications_response_entity.dart';
import '../../domain/repositories/notifications_repository.dart';
import '../datasources/notifications_local_datasource.dart';
import '../datasources/notifications_remote_datasource.dart';

class NotificationsRepositoryImpl implements NotificationsRepository {
  final NotificationsRemoteDataSource remoteDataSource;
  final NotificationsLocalDataSource localDataSource;

  NotificationsRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<NotificationsResponseEntity> getNotifications({int page = 1}) async {
    final responseModel = await remoteDataSource.getNotifications(page: page);
    if (page == 1) {
      await localDataSource.cacheNotifications(responseModel.toJson());
    }
    return responseModel.toEntity();
  }

  @override
  Future<bool> markNotificationRead(String id) {
    return remoteDataSource.markNotificationRead(id);
  }

  @override
  Future<bool> markAllNotificationsRead() {
    return remoteDataSource.markAllNotificationsRead();
  }

  @override
  Future<NotificationsResponseEntity?> getCachedNotifications() async {
    final cached = await localDataSource.getCachedNotifications();
    return cached?.toEntity();
  }
}
