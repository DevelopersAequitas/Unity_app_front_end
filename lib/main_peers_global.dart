import 'package:flutter/material.dart';
import 'app.dart';
import 'app/app_config.dart';
import 'app/configs/peers_global_config.dart';
import 'core/di/app_dependencies.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize AppConfig for Peers Global Unity
  AppConfig.set(peersGlobalConfig);

  final dependencies = await AppDependencies.initialize();

  runApp(
    MyApp(
      dependencies: dependencies,
      config: peersGlobalConfig,
    ),
  );
}
