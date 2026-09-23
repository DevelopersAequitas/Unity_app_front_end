import 'package:flutter/material.dart';
import 'app.dart';
import 'app/app_config.dart';
import 'app/configs/greenpreneur_config.dart';
import 'core/di/app_dependencies.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize AppConfig for Greenpreneur Unity
  AppConfig.set(greenpreneurConfig);

  final dependencies = await AppDependencies.initialize();

  runApp(
    MyApp(
      dependencies: dependencies,
      config: greenpreneurConfig,
    ),
  );
}
