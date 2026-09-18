import 'package:equatable/equatable.dart';
import '../../../domain/entities/notification_preferences_entity.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object?> get props => [];
}

class FetchSettingsEvent extends SettingsEvent {
  const FetchSettingsEvent();
}

class UpdateSettingsEvent extends SettingsEvent {
  final NotificationPreferencesEntity preferences;

  const UpdateSettingsEvent(this.preferences);

  @override
  List<Object?> get props => [preferences];
}
