import 'package:flutter/material.dart';
import 'core/di/app_dependencies.dart';
import 'core/di/app_providers.dart';
import 'core/router/app_router.dart';
import 'core/services/deep_link_service.dart';
import 'core/theme/app_theme.dart';
import 'core/widgets/connectivity_overlay.dart';

class MyApp extends StatelessWidget {
  final AppDependencies dependencies;

  const MyApp({super.key, required this.dependencies});

  @override
  Widget build(BuildContext context) {
    return AppProviders(
      dependencies: dependencies,
      child: MaterialApp(
        title: 'Peers Global Unity',
        navigatorKey: DeepLinkService.instance.navigatorKey,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.light,
        initialRoute: AppRoutes.splash,
        onGenerateRoute: AppRouter.onGenerateRoute,
        navigatorObservers: [AppRouter.routeObserver],
        builder: (context, child) =>
            ConnectivityOverlay(child: child ?? const SizedBox.shrink()),
      ),
    );
  }
}
