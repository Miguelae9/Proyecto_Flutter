import 'package:flutter/material.dart';
import 'package:habit_control/app.dart';
import 'package:habit_control/bootstrap.dart';

// Aquí es donde la aplicación arranca
Future<void> main() async {
  await bootstrap();
  runApp(const MyApp());
}
