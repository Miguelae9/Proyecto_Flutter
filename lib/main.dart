import 'package:flutter/material.dart';
import 'package:habit_control/app.dart';
import 'package:habit_control/bootstrap.dart';

/// Application entry point.
///
/// Initializes dependencies via [bootstrap] and then mounts [MyApp].
Future<void> main() async {
  await bootstrap();
  runApp(const MyApp());
}
