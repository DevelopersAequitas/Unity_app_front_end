import 'package:equatable/equatable.dart';
import '../../../domain/entities/notification_preferences_entity.dart';

enum SettingsStatus { initial, loading, success, failure }

class SettingsState extends Equatable {
  final SettingsStatus status;
  final NotificationPreferencesEntity preferences;
  final String? errorMessage;
  final String? successMessage;

  const SettingsState({
    this.status = SettingsStatus.initial,
    this.preferences = const NotificationPreferencesEntity(),
    this.errorMessage,
    this.successMessage,
  });

  SettingsState copyWith({
    SettingsStatus? status,
    NotificationPreferencesEntity? preferences,
    String? errorMessage,
    String? successMessage,
  }) {
    return SettingsState(
      status: status ?? this.status,
      preferences: preferences ?? this.preferences,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }

  @override
  List<Object?> get props => [status, preferences, errorMessage, successMessage];
}
