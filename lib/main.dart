import 'package:flutter/material.dart';
import 'app.dart';
import 'app/app_config.dart';
import 'app/configs/peers_global_config.dart';
import 'core/cache/app_cache_keys.dart';
import 'core/di/app_dependencies.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Default to Peers Global configuration
  if (!AppConfig.isInitialized) {
    AppConfig.set(peersGlobalConfig);
  }

  final dependencies = await AppDependencies.initialize();

  // Print Bearer token on every restart
  try {
    final token = await dependencies.cacheStore.get<String>(
      AppCacheBoxes.authBox,
      AppCacheKeys.authToken,
    );
    if (token != null && token.isNotEmpty) {
      debugPrint('\n====================================================');
      debugPrint('🔑 [AUTH] BEARER TOKEN ON STARTUP:');
      debugPrint('Bearer $token');
      debugPrint('====================================================\n');
    } else {
      debugPrint('\n🔑 [AUTH] BEARER TOKEN: (No active session / not logged in)\n');
    }
  } catch (_) {}

  runApp(
    MyApp(
      dependencies: dependencies,
      config: AppConfig.current,
    ),
  );
}
