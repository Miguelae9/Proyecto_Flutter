import 'package:flutter/material.dart';
//import 'package:habit_control/screens/analytics.dart';
import 'package:habit_control/screens/credits.dart';
import 'package:habit_control/screens/dashboard.dart';
import 'package:habit_control/screens/input_log.dart';
import 'package:habit_control/screens/splash.dart';
import 'package:habit_control/screens/home_screen.dart';

class AppRoutes {
  AppRoutes._();

  // Nombres de rutas (strings únicos)
  static const splash = '/splash';
  static const home = '/home';
  static const credits = '/credits';
  static const dashboard = '/dashboard';
  static const inputLog = '/input_log';
  //static const analytics = '/analytics';

  // Mapa: nombre de ruta -> pantalla
  static final Map<String, WidgetBuilder> map = {
    splash: (context) => const SplashScreen(),
    home: (context) => const HomeScreen(),
    credits: (context) => const CreditsScreen(),
    dashboard: (context) => const DashboardScreen(),
    inputLog: (context) => const InputLogScreen(),
    //analytics: (context) => const AnalyticsScreen(),
};
}
