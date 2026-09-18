import '../../domain/entities/notification_preferences_entity.dart';

class NotificationPreferencesModel extends NotificationPreferencesEntity {
  const NotificationPreferencesModel({
    super.id,
    super.userId,
    super.pushEnabled,
    super.emailEnabled,
    super.soundEnabled,
    super.chatEnabled,
    super.circleEnabled,
    super.businessEnabled,
    super.eventEnabled,
    super.campaignEnabled,
    super.quietHoursStart,
    super.quietHoursEnd,
    super.config,
    super.autoUpdateApp,
    super.allowAnyNetwork,
    super.notifyUpdateAvailable,
  });

  factory NotificationPreferencesModel.fromJson(Map<String, dynamic> json) {
    bool parseBool(dynamic val, {bool fallback = true}) {
      if (val == null) return fallback;
      if (val is bool) return val;
      if (val is num) return val == 1;
      final str = val.toString().toLowerCase().trim();
      return str == 'true' || str == '1';
    }

    return NotificationPreferencesModel(
      id: json['id']?.toString(),
      userId: json['user_id']?.toString(),
      pushEnabled: parseBool(json['push_enabled']),
      emailEnabled: parseBool(json['email_enabled']),
      soundEnabled: parseBool(json['sound_enabled']),
      chatEnabled: parseBool(json['chat_enabled']),
      circleEnabled: parseBool(json['circle_enabled']),
      businessEnabled: parseBool(json['business_enabled']),
      eventEnabled: parseBool(json['event_enabled']),
      campaignEnabled: parseBool(json['campaign_enabled']),
      quietHoursStart: json['quiet_hours_start']?.toString(),
      quietHoursEnd: json['quiet_hours_end']?.toString(),
      config: json['config'],
      autoUpdateApp: parseBool(json['auto_update_app']),
      allowAnyNetwork: parseBool(json['allow_any_network'], fallback: false),
      notifyUpdateAvailable: parseBool(json['notify_update_available']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'push_enabled': pushEnabled,
      'email_enabled': emailEnabled,
      'sound_enabled': soundEnabled,
      'chat_enabled': chatEnabled,
      'circle_enabled': circleEnabled,
      'business_enabled': businessEnabled,
      'event_enabled': eventEnabled,
      'campaign_enabled': campaignEnabled,
      'quiet_hours_start': quietHoursStart,
      'quiet_hours_end': quietHoursEnd,
      if (config != null) 'config': config,
      'auto_update_app': autoUpdateApp,
      'allow_any_network': allowAnyNetwork,
      'notify_update_available': notifyUpdateAvailable,
    };
  }
}
