import 'dart:async';
import 'package:flutter/material.dart';
import '../constants/api_endpoints.dart';
import '../network/dio_client.dart';
import '../../features/auth/data/datasources/auth_local_datasource.dart';
import 'location_sync_service.dart';

class UserPresenceService with WidgetsBindingObserver {
  UserPresenceService._();
  static final UserPresenceService instance = UserPresenceService._();

  DioClient? _dioClient;
  AuthLocalDataSource? _authLocalDataSource;
  Timer? _heartbeatTimer;
  bool _isDispatched = false;

  void init({
    required DioClient dioClient,
    required AuthLocalDataSource authLocalDataSource,
  }) {
    _dioClient = dioClient;
    _authLocalDataSource = authLocalDataSource;

    WidgetsBinding.instance.removeObserver(this);
    WidgetsBinding.instance.addObserver(this);

    // Initial check on app startup
    markOnlineAndStart();
  }

  void startHeartbeat() {
    _heartbeatTimer?.cancel();
    // Heartbeat every 75s (stale threshold on backend is 120s)
    _heartbeatTimer = Timer.periodic(const Duration(seconds: 75), (_) {
      sendHeartbeat();
    });
  }

  void stopHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        markOnlineAndStart();
        LocationSyncService.instance.syncLocationIfPermitted();
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        markOfflineAndStop();
        break;
    }
  }

  Future<void> markOnlineAndStart() async {
    startHeartbeat();
    await sendHeartbeat();
  }

  Future<void> markOfflineAndStop() async {
    stopHeartbeat();
    await sendOffline();
  }

  Future<void> sendHeartbeat() async {
    if (_dioClient == null || _isDispatched) return;
    try {
      final authData = await _authLocalDataSource?.getAuthData();
      final token = authData?.token;
      if (token == null || token.trim().isEmpty) return;

      _isDispatched = true;
      await _dioClient!.dio.post(ApiEndpoints.onlineHeartbeat);
    } catch (_) {
      // Graceful error suppression
    } finally {
      _isDispatched = false;
    }
  }

  Future<void> sendOffline() async {
    if (_dioClient == null) return;
    try {
      final authData = await _authLocalDataSource?.getAuthData();
      final token = authData?.token;
      if (token == null || token.trim().isEmpty) return;

      await _dioClient!.dio.post(ApiEndpoints.onlineOffline);
    } catch (_) {
      // Graceful error suppression
    }
  }

  void dispose() {
    stopHeartbeat();
    WidgetsBinding.instance.removeObserver(this);
  }
}
