import '../../domain/entities/menu_summary_entity.dart';
import '../../domain/entities/notification_preferences_entity.dart';
import '../../domain/repositories/menu_repository.dart';
import '../datasources/menu_remote_datasource.dart';
import '../models/notification_preferences_model.dart';

class MenuRepositoryImpl implements MenuRepository {
  final MenuRemoteDataSource remoteDataSource;

  const MenuRepositoryImpl(this.remoteDataSource);

  @override
  Future<MenuSummaryEntity> getMenuSummary() async {
    final model = await remoteDataSource.getMenuSummary();
    return model.toEntity();
  }

  @override
  Future<NotificationPreferencesEntity> getNotificationPreferences() async {
    return await remoteDataSource.getNotificationPreferences();
  }

  @override
  Future<NotificationPreferencesEntity> updateNotificationPreferences(
    NotificationPreferencesEntity preferences,
  ) async {
    final model = NotificationPreferencesModel(
      id: preferences.id,
      userId: preferences.userId,
      pushEnabled: preferences.pushEnabled,
      emailEnabled: preferences.emailEnabled,
      soundEnabled: preferences.soundEnabled,
      chatEnabled: preferences.chatEnabled,
      circleEnabled: preferences.circleEnabled,
      businessEnabled: preferences.businessEnabled,
      eventEnabled: preferences.eventEnabled,
      campaignEnabled: preferences.campaignEnabled,
      quietHoursStart: preferences.quietHoursStart,
      quietHoursEnd: preferences.quietHoursEnd,
      config: preferences.config,
      autoUpdateApp: preferences.autoUpdateApp,
      allowAnyNetwork: preferences.allowAnyNetwork,
      notifyUpdateAvailable: preferences.notifyUpdateAvailable,
    );
    return await remoteDataSource.updateNotificationPreferences(model.toJson());
  }
}

