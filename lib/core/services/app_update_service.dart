import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../cache/app_cache_keys.dart';
import '../cache/cache_store.dart';
import '../constants/api_endpoints.dart';
import '../constants/app_environment.dart';
import '../models/app_version_model.dart';
import '../network/dio_client.dart';

class AppUpdateResult {
  final AppUpdateState state;
  final String currentVersion;
  final AppVersionModel? config;
  final String? errorMessage;

  const AppUpdateResult({
    required this.state,
    required this.currentVersion,
    this.config,
    this.errorMessage,
  });

  bool get isForceUpdate => state == AppUpdateState.forceUpdate;
  bool get isOptionalUpdate => state == AppUpdateState.optionalUpdate;
  bool get isUpToDate => state == AppUpdateState.upToDate;
}

class AppUpdateService {
  AppUpdateService._();
  static final AppUpdateService instance = AppUpdateService._();

  DioClient? _dioClient;
  CacheStore? _cacheStore;

  AppUpdateResult? _lastResult;
  AppUpdateResult? get lastResult => _lastResult;

  String? _cachedCurrentVersion;

  void init({
    required DioClient dioClient,
    required CacheStore cacheStore,
  }) {
    _dioClient = dioClient;
    _cacheStore = cacheStore;
  }

  /// Returns the current app version installed on this device (e.g. "1.8.9").
  Future<String> getCurrentVersion() async {
    if (_cachedCurrentVersion != null && _cachedCurrentVersion!.isNotEmpty) {
      return _cachedCurrentVersion!;
    }
    try {
      final info = await PackageInfo.fromPlatform();
      _cachedCurrentVersion = info.version;
      return info.version;
    } catch (e) {
      debugPrint('[AppUpdateService] Failed to read package info: $e');
      return '1.8.9';
    }
  }

  /// Returns current package build number (e.g. "61").
  Future<String> getBuildNumber() async {
    try {
      final info = await PackageInfo.fromPlatform();
      return info.buildNumber;
    } catch (_) {
      return '1';
    }
  }

  /// Fetches app version configuration from backend.
  Future<AppVersionModel?> fetchAppVersionConfig() async {
    if (_dioClient == null) return null;

    try {
      final platformStr = Platform.isIOS ? 'ios' : 'android';
      final response = await _dioClient!.dio.get(
        ApiEndpoints.appVersion,
        queryParameters: {
          'platform': platformStr,
          'product': 'peers',
        },
      );

      final dynamic data = response.data;
      if (data is Map<String, dynamic>) {
        final versionData = data['data'] ?? data;
        if (versionData is Map<String, dynamic>) {
          return AppVersionModel.fromJson(versionData);
        }
      }
      return null;
    } catch (e) {
      debugPrint('[AppUpdateService] Version check failed: $e');
      return null;
    }
  }

  /// Evaluates whether an update (force or optional) is available.
  Future<AppUpdateResult> checkUpdate() async {
    final currentVer = await getCurrentVersion();
    final config = await fetchAppVersionConfig();

    if (config == null) {
      final result = AppUpdateResult(
        state: AppUpdateState.upToDate,
        currentVersion: currentVer,
        errorMessage: 'Unable to reach update server.',
      );
      _lastResult = result;
      return result;
    }

    final state = evaluateAppUpdate(
      currentVersion: currentVer,
      config: config,
    );

    final result = AppUpdateResult(
      state: state,
      currentVersion: currentVer,
      config: config,
    );

    _lastResult = result;
    return result;
  }

  /// Synchronizes mobile version and device details to the backend (`POST /api/v1/user/mobile-version`).
  Future<bool> syncMobileVersion() async {
    if (_dioClient == null || _cacheStore == null) return false;

    try {
      final token = await _cacheStore!.get<String>(
        AppCacheBoxes.authBox,
        AppCacheKeys.authToken,
      );
      if (token == null || token.trim().isEmpty) return false;

      final appVer = await getCurrentVersion();
      final platformStr = Platform.isIOS ? 'ios' : (Platform.isAndroid ? 'android' : 'web');

      String deviceModel = 'Unknown Device';
      String osVersion = Platform.operatingSystemVersion;

      try {
        final deviceInfo = DeviceInfoPlugin();
        if (Platform.isAndroid) {
          final android = await deviceInfo.androidInfo;
          deviceModel = '${android.manufacturer} ${android.model}'.trim();
          osVersion = 'Android ${android.version.release} (SDK ${android.version.sdkInt})';
        } else if (Platform.isIOS) {
          final ios = await deviceInfo.iosInfo;
          deviceModel = ios.utsname.machine;
          osVersion = '${ios.systemName} ${ios.systemVersion}';
        }
      } catch (e) {
        debugPrint('[AppUpdateService] Device info read warning: $e');
      }

      await _dioClient!.dio.post(
        ApiEndpoints.syncMobileVersion,
        data: {
          'platform': platformStr,
          'app_version': appVer,
          'device_model': deviceModel,
          'os_version': osVersion,
        },
      );
      debugPrint('[AppUpdateService] Mobile version synced successfully: v$appVer ($deviceModel, $osVersion)');
      return true;
    } catch (e) {
      debugPrint('[AppUpdateService] Mobile version sync warning: $e');
      return false;
    }
  }

  /// Launches the App Store or Google Play Store update link.
  Future<bool> launchStoreUpdate({String? customUrl}) async {
    final targetUrl = customUrl ??
        _lastResult?.config?.targetStoreUrl ??
        (Platform.isIOS ? AppEnvironment.appStoreUrl : AppEnvironment.playStoreUrl);

    if (targetUrl.isEmpty) return false;

    try {
      final uri = Uri.parse(targetUrl);
      if (await canLaunchUrl(uri)) {
        return await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint('[AppUpdateService] Launch store error: $e');
    }
    return false;
  }
}
