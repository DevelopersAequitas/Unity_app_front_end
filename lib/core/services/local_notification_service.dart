import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../features/notifications/domain/entities/notification_entity.dart';
import '../../features/notifications/presentation/widgets/notification_router_helper.dart';
import 'deep_link_service.dart';

/// Service responsible for displaying native system heads-up notifications
/// when the app is in the foreground / running, and routing on tap.
class LocalNotificationService {
  LocalNotificationService._();
  static final LocalNotificationService instance = LocalNotificationService._();

  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static const String _channelId = 'peers_unity_notifications';
  static const String _channelName = 'Peers Global Notifications';
  static const String _channelDescription =
      'Real-time updates, messages, connections, and meeting alerts';

  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;

    // 1. Android Initialization Settings
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // 2. iOS / macOS Initialization Settings
    const darwinSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
      macOS: darwinSettings,
    );

    // 3. Initialize plugin with response callback
    await _localNotifications.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // 4. Create High-Importance Android Notification Channel
    final androidNotificationPlugin = _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidNotificationPlugin != null) {
      await androidNotificationPlugin.createNotificationChannel(
        const AndroidNotificationChannel(
          _channelId,
          _channelName,
          description: _channelDescription,
          importance: Importance.max,
          playSound: true,
          enableVibration: true,
        ),
      );

      // Request notification permission for Android 13+ (API 33+)
      await androidNotificationPlugin.requestNotificationsPermission();
    }

    _isInitialized = true;
    debugPrint('[LocalNotificationService] Initialized successfully');
  }

  /// Displays a native system notification pop-up
  Future<void> showNotification({
    int? id,
    required String title,
    required String body,
    Map<String, dynamic>? payload,
  }) async {
    final notifId = id ?? DateTime.now().millisecondsSinceEpoch.remainder(100000);

    const androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      icon: '@mipmap/ic_launcher',
    );

    const darwinDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: darwinDetails,
      macOS: darwinDetails,
    );

    final payloadString = payload != null ? jsonEncode(payload) : null;

    await _localNotifications.show(
      id: notifId,
      title: title,
      body: body,
      notificationDetails: notificationDetails,
      payload: payloadString,
    );
  }

  /// Displays notification directly from a remote FCM payload map
  Future<void> showFromRemotePayload(
    Map<String, dynamic> data, {
    String? title,
    String? body,
  }) async {
    final displayTitle = title ??
        data['title']?.toString() ??
        data['notification_title']?.toString() ??
        'Peers Global';
    final displayBody = body ??
        data['body']?.toString() ??
        data['message']?.toString() ??
        data['notification_body']?.toString() ??
        '';

    await showNotification(
      title: displayTitle,
      body: displayBody,
      payload: data,
    );
  }

  /// Callback when user taps on the native system notification banner
  void _onNotificationTapped(NotificationResponse response) {
    final payloadString = response.payload;
    if (payloadString == null || payloadString.isEmpty) return;

    try {
      final Map<String, dynamic> payload = jsonDecode(payloadString);
      final context = DeepLinkService.instance.navigatorKey.currentContext;

      if (context != null) {
        final notification = NotificationEntity(
          id: payload['id']?.toString() ??
              payload['notification_id']?.toString() ??
              '',
          type: payload['type']?.toString() ??
              payload['notification_type']?.toString() ??
              '',
          title: payload['title']?.toString() ?? '',
          body: payload['body']?.toString() ??
              payload['message']?.toString() ??
              '',
          message: payload['message']?.toString() ?? '',
          screen: payload['screen']?.toString() ??
              payload['navigation_screen']?.toString(),
          tapDestination: payload['tap_destination']?.toString(),
          referenceId: payload['reference_id']?.toString() ??
              payload['referenceId']?.toString(),
          referenceType: payload['reference_type']?.toString(),
          metaData: payload,
        );

        NotificationRouterHelper.handleNotificationTap(context, notification);
      }
    } catch (e) {
      debugPrint('[LocalNotificationService] Error handling tapped notification: $e');
    }
  }
}
