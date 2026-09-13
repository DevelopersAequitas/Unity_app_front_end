import 'package:flutter/material.dart';
import 'app.dart';
import 'core/di/app_dependencies.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dependencies = await AppDependencies.initialize();

  runApp(
    MyApp(dependencies: dependencies),
  );
}
