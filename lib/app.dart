import 'package:flutter/material.dart';
import 'app/app_config.dart';
import 'core/di/app_dependencies.dart';
import 'core/di/app_providers.dart';
import 'core/router/app_router.dart';
import 'core/services/deep_link_service.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/app_screenshot_manager.dart';
import 'core/widgets/connectivity_overlay.dart';

class MyApp extends StatelessWidget {
  final AppDependencies dependencies;
  final AppConfig? config;

  const MyApp({
    super.key,
    required this.dependencies,
    this.config,
  });

  @override
  Widget build(BuildContext context) {
    final activeConfig =
        config ?? (AppConfig.isInitialized ? AppConfig.current : null);
    final appTitle = activeConfig?.appName ?? 'Peers Global Unity';
    final appTheme = activeConfig?.activeTheme ?? AppTheme.lightTheme;
    final appDarkTheme = activeConfig?.activeDarkTheme ?? AppTheme.darkTheme;

    return AppProviders(
      dependencies: dependencies,
      child: MaterialApp(
        title: appTitle,
        navigatorKey: DeepLinkService.instance.navigatorKey,
        debugShowCheckedModeBanner: false,
        theme: appTheme,
        darkTheme: appDarkTheme,
        themeMode: ThemeMode.light,
        initialRoute: AppRoutes.splash,
        onGenerateRoute: AppRouter.onGenerateRoute,
        navigatorObservers: [AppRouter.routeObserver],
        builder: (context, child) => RepaintBoundary(
          key: AppScreenshotManager.rootRepaintKey,
          child: ConnectivityOverlay(child: child ?? const SizedBox.shrink()),
        ),
      ),
    );
  }
}
