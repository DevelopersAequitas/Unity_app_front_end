import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_notification_preferences_usecase.dart';
import '../../../domain/usecases/update_notification_preferences_usecase.dart';
import 'settings_event.dart';
import 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final GetNotificationPreferencesUseCase getNotificationPreferencesUseCase;
  final UpdateNotificationPreferencesUseCase updateNotificationPreferencesUseCase;

  SettingsBloc({
    required this.getNotificationPreferencesUseCase,
    required this.updateNotificationPreferencesUseCase,
  }) : super(const SettingsState()) {
    on<FetchSettingsEvent>(_onFetchSettings);
    on<UpdateSettingsEvent>(_onUpdateSettings);
  }

  Future<void> _onFetchSettings(
    FetchSettingsEvent event,
    Emitter<SettingsState> emit,
  ) async {
    emit(state.copyWith(status: SettingsStatus.loading));
    try {
      final prefs = await getNotificationPreferencesUseCase();
      emit(state.copyWith(
        status: SettingsStatus.success,
        preferences: prefs,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: SettingsStatus.failure,
        errorMessage: 'Failed to load settings',
      ));
    }
  }

  Future<void> _onUpdateSettings(
    UpdateSettingsEvent event,
    Emitter<SettingsState> emit,
  ) async {
    emit(state.copyWith(preferences: event.preferences));
    try {
      final updated = await updateNotificationPreferencesUseCase(event.preferences);
      final merged = event.preferences.copyWith(
        id: updated.id ?? event.preferences.id,
        userId: updated.userId ?? event.preferences.userId,
        pushEnabled: updated.pushEnabled,
        emailEnabled: updated.emailEnabled,
        soundEnabled: event.preferences.soundEnabled,
        chatEnabled: updated.chatEnabled,
        circleEnabled: updated.circleEnabled,
        businessEnabled: updated.businessEnabled,
        eventEnabled: updated.eventEnabled,
        campaignEnabled: updated.campaignEnabled,
        quietHoursStart: updated.quietHoursStart,
        quietHoursEnd: updated.quietHoursEnd,
        clearQuietHours: updated.quietHoursStart == null && updated.quietHoursEnd == null,
        config: updated.config ?? event.preferences.config,
        autoUpdateApp: event.preferences.autoUpdateApp,
        allowAnyNetwork: event.preferences.allowAnyNetwork,
        notifyUpdateAvailable: event.preferences.notifyUpdateAvailable,
      );
      emit(state.copyWith(
        status: SettingsStatus.success,
        preferences: merged,
      ));
    } catch (_) {
      // Keep optimistic update or notify error
    }
  }
}
