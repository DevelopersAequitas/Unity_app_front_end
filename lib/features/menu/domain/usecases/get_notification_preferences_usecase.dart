import '../entities/notification_preferences_entity.dart';
import '../repositories/menu_repository.dart';

class GetNotificationPreferencesUseCase {
  final MenuRepository repository;
  const GetNotificationPreferencesUseCase(this.repository);

  Future<NotificationPreferencesEntity> call() {
    return repository.getNotificationPreferences();
  }
}
