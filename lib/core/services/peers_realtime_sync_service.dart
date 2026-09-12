import 'dart:async';
import 'package:flutter/material.dart';
import '../../features/peers/domain/usecases/get_connection_requests_usecase.dart';
import '../../features/peers/domain/usecases/get_my_connections_usecase.dart';
import '../events/peers_event_bus.dart';

class PeersRealtimeSyncService with WidgetsBindingObserver {
  PeersRealtimeSyncService._();
  static final PeersRealtimeSyncService instance = PeersRealtimeSyncService._();

  GetConnectionRequestsUseCase? _getConnectionRequestsUseCase;
  GetMyConnectionsUseCase? _getMyConnectionsUseCase;

  Timer? _pollingTimer;
  bool _isSyncing = false;
  int _lastIncomingCount = -1;
  int _lastConnectionsCount = -1;

  void init({
    required GetConnectionRequestsUseCase getConnectionRequestsUseCase,
    required GetMyConnectionsUseCase getMyConnectionsUseCase,
  }) {
    _getConnectionRequestsUseCase = getConnectionRequestsUseCase;
    _getMyConnectionsUseCase = getMyConnectionsUseCase;
    WidgetsBinding.instance.addObserver(this);
    startSync();
  }

  void startSync() {
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(const Duration(seconds: 20), (_) {
      syncNow();
    });
  }

  void stopSync() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      syncNow();
      startSync();
    } else if (state == AppLifecycleState.paused) {
      stopSync();
    }
  }

  Future<void> syncNow() async {
    if (_isSyncing || _getConnectionRequestsUseCase == null) return;
    _isSyncing = true;
    try {
      final requests = await _getConnectionRequestsUseCase!();
      if (_lastIncomingCount != -1 && requests.length != _lastIncomingCount) {
        PeersEventBus.instance.emit(const PeersSyncNeededEvent());
      }
      _lastIncomingCount = requests.length;

      if (_getMyConnectionsUseCase != null) {
        final connections = await _getMyConnectionsUseCase!();
        if (_lastConnectionsCount != -1 && connections.length != _lastConnectionsCount) {
          PeersEventBus.instance.emit(const PeersSyncNeededEvent());
        }
        _lastConnectionsCount = connections.length;
      }
    } catch (_) {} finally {
      _isSyncing = false;
    }
  }

  void dispose() {
    stopSync();
    WidgetsBinding.instance.removeObserver(this);
  }
}
