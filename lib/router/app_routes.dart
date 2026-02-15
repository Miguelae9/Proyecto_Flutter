import 'package:flutter/material.dart';
import 'package:habit_control/screens/analytics/analytics_screen.dart';
import 'package:habit_control/screens/credits/credits_screen.dart';
import 'package:habit_control/screens/dashboard/dashboard_screen.dart';
import 'package:habit_control/screens/input_log/input_log_scren.dart';
import 'package:habit_control/screens/splash/splash_screen.dart';
import 'package:habit_control/screens/auth/home_screen.dart';

class AppRoutes {
  AppRoutes._();

  // Nombres de rutas (strings únicos)
  static const splash = '/splash';
  static const home = '/home';
  static const credits = '/credits';
  static const dashboard = '/dashboard';
  static const inputLog = '/input_log';
  static const analytics = '/analytics';

  // Mapa: nombre de ruta -> pantalla
  static final Map<String, WidgetBuilder> map = {
    splash: (context) => const SplashScreen(),
    home: (context) => const LoginScreen(),
    credits: (context) => const CreditsScreen(),
    dashboard: (context) => const DashboardScreen(),
    inputLog: (context) => const InputLogScreen(),
    analytics: (context) => const AnalyticsScreen(),
};
}
