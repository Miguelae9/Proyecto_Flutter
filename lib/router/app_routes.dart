import 'package:flutter/material.dart';
import 'package:habit_control/screens/credits.dart';
import 'package:habit_control/screens/splash.dart';
import 'package:habit_control/screens/home_screen.dart';

class AppRoutes {
  AppRoutes._();

  // Nombres de rutas (strings únicos)
  static const splash = '/splash';
  static const home = '/home';
  static const credits = '/credits';

  // Mapa: nombre de ruta -> pantalla
  static final Map<String, WidgetBuilder> map = {
    splash: (context) => const SplashScreen(),
    home: (context) => const HomeScreen(),
    credits: (context) => const CreditsScreen(),
  };
}
