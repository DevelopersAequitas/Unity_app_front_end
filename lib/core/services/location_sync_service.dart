import 'dart:async';
import 'package:geolocator/geolocator.dart';
import '../constants/api_endpoints.dart';
import '../network/dio_client.dart';
import '../../features/auth/data/datasources/auth_local_datasource.dart';

class LocationSyncService {
  LocationSyncService._();
  static final LocationSyncService instance = LocationSyncService._();

  DioClient? _dioClient;
  AuthLocalDataSource? _authLocalDataSource;
  DateTime? _lastSyncTime;
  bool _isSyncing = false;

  void init({
    required DioClient dioClient,
    required AuthLocalDataSource authLocalDataSource,
  }) {
    _dioClient = dioClient;
    _authLocalDataSource = authLocalDataSource;
  }

  /// Checks if location permission is already granted, and if so,
  /// obtains the latest coordinates and syncs them with the backend.
  Future<void> syncLocationIfPermitted() async {
    if (_isSyncing || _dioClient == null) return;

    // Rate-limit sync to once every 60 seconds unless explicitly forced
    if (_lastSyncTime != null &&
        DateTime.now().difference(_lastSyncTime!).inSeconds < 60) {
      return;
    }

    _isSyncing = true;
    try {
      // 1. Verify user is logged in
      final authData = await _authLocalDataSource?.getAuthData();
      final token = authData?.token;
      if (token == null || token.trim().isEmpty) return;

      // 2. Check location service status
      final isServiceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!isServiceEnabled) return;

      // 3. Check permission without prompting if denied
      final permission = await Geolocator.checkPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return;
      }

      // 4. Retrieve current position safely
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          timeLimit: Duration(seconds: 10),
        ),
      );

      // 5. Send to backend
      await _dioClient!.dio.post(
        ApiEndpoints.geoUpdateLocation,
        data: {
          'latitude': position.latitude,
          'longitude': position.longitude,
        },
      );

      _lastSyncTime = DateTime.now();
    } catch (_) {
      // Silent fail to preserve uninterrupted user experience
    } finally {
      _isSyncing = false;
    }
  }
}
