import 'dart:io';

enum AppUpdateState {
  upToDate,
  optionalUpdate,
  forceUpdate,
}

class AppVersionModel {
  final String latestVersion;
  final String minVersion;
  final String updateType;
  final bool isActive;
  final String playStoreUrl;
  final String appStoreUrl;
  final String releaseNotes;
  final String? latestVersionAndroid;
  final String? latestVersionIos;

  const AppVersionModel({
    required this.latestVersion,
    required this.minVersion,
    required this.updateType,
    required this.isActive,
    required this.playStoreUrl,
    required this.appStoreUrl,
    required this.releaseNotes,
    this.latestVersionAndroid,
    this.latestVersionIos,
  });

  factory AppVersionModel.fromJson(Map<String, dynamic> json) {
    return AppVersionModel(
      latestVersion: (json['latest_version'] ?? '1.0.0').toString().trim(),
      minVersion: (json['min_version'] ?? '1.0.0').toString().trim(),
      updateType: (json['update_type'] ?? 'optional').toString().toLowerCase().trim(),
      isActive: json['is_active'] == true || json['is_active'] == 1 || json['is_active'] == '1',
      playStoreUrl: (json['playstore_url'] ?? '').toString().trim(),
      appStoreUrl: (json['appstore_url'] ?? '').toString().trim(),
      releaseNotes: (json['release_notes'] ?? '').toString().trim(),
      latestVersionAndroid: json['latest_version_android']?.toString().trim(),
      latestVersionIos: json['latest_version_ios']?.toString().trim(),
    );
  }

  Map<String, dynamic> toJson() => {
        'latest_version': latestVersion,
        'min_version': minVersion,
        'update_type': updateType,
        'is_active': isActive,
        'playstore_url': playStoreUrl,
        'appstore_url': appStoreUrl,
        'release_notes': releaseNotes,
        'latest_version_android': latestVersionAndroid,
        'latest_version_ios': latestVersionIos,
      };

  String get effectiveLatestVersion {
    if (Platform.isIOS && latestVersionIos != null && latestVersionIos!.isNotEmpty) {
      return latestVersionIos!;
    }
    if (Platform.isAndroid && latestVersionAndroid != null && latestVersionAndroid!.isNotEmpty) {
      return latestVersionAndroid!;
    }
    return latestVersion;
  }

  String get targetStoreUrl {
    if (Platform.isIOS && appStoreUrl.isNotEmpty) {
      return appStoreUrl;
    }
    return playStoreUrl;
  }
}

/// Compares two semantic version strings (e.g. "1.8.2" vs "1.2.0").
/// Returns -1 if v1 < v2, 1 if v1 > v2, 0 if v1 == v2.
int compareSemVer(String v1, String v2) {
  final p1 = _normalizeSemVer(v1);
  final p2 = _normalizeSemVer(v2);

  for (int i = 0; i < 3; i++) {
    if (p1[i] < p2[i]) return -1;
    if (p1[i] > p2[i]) return 1;
  }
  return 0;
}

List<int> _normalizeSemVer(String v) {
  final clean = v.split('+').first.trim().replaceFirst(RegExp(r'^[vV]'), '');
  final parts = clean.split('.').map((e) => int.tryParse(e) ?? 0).toList();
  while (parts.length < 3) {
    parts.add(0);
  }
  return parts.take(3).toList();
}

/// Evaluates update requirement based on current installed version and backend config.
AppUpdateState evaluateAppUpdate({
  required String currentVersion,
  required AppVersionModel config,
}) {
  if (!config.isActive) {
    return AppUpdateState.upToDate;
  }

  final targetLatest = config.effectiveLatestVersion;
  final targetMin = config.minVersion;

  final isBelowMin = compareSemVer(currentVersion, targetMin) < 0;
  final isBelowLatest = compareSemVer(currentVersion, targetLatest) < 0;
  final isForceType = config.updateType.toLowerCase() == 'force';

  // 1. Force update if below min_version OR (below latest_version AND update_type is force)
  if (isBelowMin || (isBelowLatest && isForceType)) {
    return AppUpdateState.forceUpdate;
  }

  // 2. Optional update if below latest_version and update_type is optional
  if (isBelowLatest) {
    return AppUpdateState.optionalUpdate;
  }

  return AppUpdateState.upToDate;
}
