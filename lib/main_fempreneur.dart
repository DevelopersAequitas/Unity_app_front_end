import 'package:flutter/material.dart';
import 'app.dart';
import 'app/app_config.dart';
import 'app/configs/fempreneur_config.dart';
import 'core/di/app_dependencies.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize AppConfig for Fempreneur Unity
  AppConfig.set(fempreneurConfig);

  final dependencies = await AppDependencies.initialize();

  runApp(
    MyApp(
      dependencies: dependencies,
      config: fempreneurConfig,
    ),
  );
}
