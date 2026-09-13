import '../../../../core/cache/app_cache_keys.dart';
import '../../../../core/cache/cache_store.dart';
import '../models/notifications_response_model.dart';

abstract class NotificationsLocalDataSource {
  Future<void> cacheNotifications(Map<String, dynamic> json);
  Future<NotificationsResponseModel?> getCachedNotifications();
}

class NotificationsLocalDataSourceImpl implements NotificationsLocalDataSource {
  final CacheStore cacheStore;

  NotificationsLocalDataSourceImpl({required this.cacheStore});

  @override
  Future<void> cacheNotifications(Map<String, dynamic> json) async {
    await cacheStore.set(
      AppCacheBoxes.notificationsBox,
      AppCacheKeys.notifications,
      json,
    );
  }

  @override
  Future<NotificationsResponseModel?> getCachedNotifications() async {
    final cached = await cacheStore.get<Map<String, dynamic>>(
      AppCacheBoxes.notificationsBox,
      AppCacheKeys.notifications,
    );
    if (cached != null) {
      try {
        return NotificationsResponseModel.fromJson(cached);
      } catch (_) {
        return null;
      }
    }
    return null;
  }
}
