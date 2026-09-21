import 'package:equatable/equatable.dart';

class NotificationPreferencesEntity extends Equatable {
  final String? id;
  final String? userId;
  final bool pushEnabled;
  final bool emailEnabled;
  final bool soundEnabled;
  final bool chatEnabled;
  final bool circleEnabled;
  final bool businessEnabled;
  final bool eventEnabled;
  final bool campaignEnabled;
  final String? quietHoursStart;
  final String? quietHoursEnd;
  final dynamic config;
  final bool autoUpdateApp;
  final bool allowAnyNetwork;
  final bool notifyUpdateAvailable;

  const NotificationPreferencesEntity({
    this.id,
    this.userId,
    this.pushEnabled = true,
    this.emailEnabled = true,
    this.soundEnabled = true,
    this.chatEnabled = true,
    this.circleEnabled = true,
    this.businessEnabled = true,
    this.eventEnabled = true,
    this.campaignEnabled = true,
    this.quietHoursStart,
    this.quietHoursEnd,
    this.config,
    this.autoUpdateApp = true,
    this.allowAnyNetwork = false,
    this.notifyUpdateAvailable = true,
  });

  NotificationPreferencesEntity copyWith({
    String? id,
    String? userId,
    bool? pushEnabled,
    bool? emailEnabled,
    bool? soundEnabled,
    bool? chatEnabled,
    bool? circleEnabled,
    bool? businessEnabled,
    bool? eventEnabled,
    bool? campaignEnabled,
    String? quietHoursStart,
    String? quietHoursEnd,
    bool clearQuietHours = false,
    dynamic config,
    bool? autoUpdateApp,
    bool? allowAnyNetwork,
    bool? notifyUpdateAvailable,
  }) {
    return NotificationPreferencesEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      pushEnabled: pushEnabled ?? this.pushEnabled,
      emailEnabled: emailEnabled ?? this.emailEnabled,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      chatEnabled: chatEnabled ?? this.chatEnabled,
      circleEnabled: circleEnabled ?? this.circleEnabled,
      businessEnabled: businessEnabled ?? this.businessEnabled,
      eventEnabled: eventEnabled ?? this.eventEnabled,
      campaignEnabled: campaignEnabled ?? this.campaignEnabled,
      quietHoursStart: clearQuietHours ? null : (quietHoursStart ?? this.quietHoursStart),
      quietHoursEnd: clearQuietHours ? null : (quietHoursEnd ?? this.quietHoursEnd),
      config: config ?? this.config,
      autoUpdateApp: autoUpdateApp ?? this.autoUpdateApp,
      allowAnyNetwork: allowAnyNetwork ?? this.allowAnyNetwork,
      notifyUpdateAvailable: notifyUpdateAvailable ?? this.notifyUpdateAvailable,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        pushEnabled,
        emailEnabled,
        soundEnabled,
        chatEnabled,
        circleEnabled,
        businessEnabled,
        eventEnabled,
        campaignEnabled,
        quietHoursStart,
        quietHoursEnd,
        config,
        autoUpdateApp,
        allowAnyNetwork,
        notifyUpdateAvailable,
      ];
}
