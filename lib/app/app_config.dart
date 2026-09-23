import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import 'app_flavor.dart';

/// Strongly typed application configuration model.
/// Supports multi-app flavors (Peers Global, Greenpreneur, Fempreneur).
class AppConfig {
  final AppFlavor flavor;
  final String appName;
  final String androidPackageName;
  final String iosBundleId;
  final String logoPath;
  final String appScheme;
  final String appDomain;
  final String devBaseUrl;
  final String prodBaseUrl;
  final String appStoreUrl;
  final String appStoreId;
  final ThemeData? themeData;
  final ThemeData? darkThemeData;

  const AppConfig({
    required this.flavor,
    required this.appName,
    required this.androidPackageName,
    required this.iosBundleId,
    required this.logoPath,
    required this.appScheme,
    required this.appDomain,
    required this.devBaseUrl,
    required this.prodBaseUrl,
    required this.appStoreUrl,
    required this.appStoreId,
    this.themeData,
    this.darkThemeData,
  });

  ThemeData get activeTheme => themeData ?? AppTheme.lightTheme;
  ThemeData get activeDarkTheme => darkThemeData ?? AppTheme.darkTheme;

  static AppConfig? _current;

  /// Returns the current active configuration.
  static AppConfig get current {
    if (_current == null) {
      throw StateError(
        'AppConfig has not been initialized. Ensure an entry point calls AppConfig.set() before running the app.',
      );
    }
    return _current!;
  }

  /// Sets the active configuration.
  static void set(AppConfig config) {
    _current = config;
  }

  /// Helper to check if config is initialized
  static bool get isInitialized => _current != null;
}
