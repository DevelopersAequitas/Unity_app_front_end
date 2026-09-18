import '../entities/notification_preferences_entity.dart';
import '../repositories/menu_repository.dart';

class UpdateNotificationPreferencesUseCase {
  final MenuRepository repository;
  const UpdateNotificationPreferencesUseCase(this.repository);

  Future<NotificationPreferencesEntity> call(NotificationPreferencesEntity preferences) {
    return repository.updateNotificationPreferences(preferences);
  }
}
