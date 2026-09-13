import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

enum NetworkStatus { online, offline }

class NetworkConnectivityService {
  NetworkConnectivityService._();
  static final NetworkConnectivityService instance = NetworkConnectivityService._();

  final Connectivity _connectivity = Connectivity();
  final StreamController<NetworkStatus> _statusController = StreamController<NetworkStatus>.broadcast();

  NetworkStatus _currentStatus = NetworkStatus.online;
  StreamSubscription<List<ConnectivityResult>>? _subscription;
  bool _isInitialized = false;

  NetworkStatus get currentStatus => _currentStatus;
  bool get isOnline => _currentStatus == NetworkStatus.online;
  bool get isOffline => _currentStatus == NetworkStatus.offline;
  Stream<NetworkStatus> get onStatusChanged => _statusController.stream;

  Future<void> init() async {
    if (_isInitialized) return;
    _isInitialized = true;

    try {
      final results = await _connectivity.checkConnectivity();
      _currentStatus = _resolveStatus(results);
    } catch (_) {
      _currentStatus = NetworkStatus.online;
    }

    _subscription = _connectivity.onConnectivityChanged.listen((results) {
      final newStatus = _resolveStatus(results);
      if (newStatus != _currentStatus) {
        _currentStatus = newStatus;
        _statusController.add(newStatus);
      }
    });
  }

  NetworkStatus _resolveStatus(List<ConnectivityResult> results) {
    final hasConnection = results.any(
      (r) => r != ConnectivityResult.none,
    );
    return hasConnection ? NetworkStatus.online : NetworkStatus.offline;
  }

  void dispose() {
    _subscription?.cancel();
    _statusController.close();
  }
}
