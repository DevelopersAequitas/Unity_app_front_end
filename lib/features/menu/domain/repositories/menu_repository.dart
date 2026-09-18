import '../entities/menu_summary_entity.dart';
import '../entities/notification_preferences_entity.dart';

abstract class MenuRepository {
  Future<MenuSummaryEntity> getMenuSummary();
  Future<NotificationPreferencesEntity> getNotificationPreferences();
  Future<NotificationPreferencesEntity> updateNotificationPreferences(NotificationPreferencesEntity preferences);
}

