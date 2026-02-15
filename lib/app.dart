import 'package:flutter/material.dart';
import 'package:habit_control/router/app_routes.dart';
import 'package:habit_control/theme/app_theme.dart';

// Raíz de la aplicación.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Habit Control',
      theme: AppTheme.dark(),
      initialRoute: AppRoutes.splash,
      routes: AppRoutes.map,
    );
  }
}
