import 'package:flutter/widgets.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:habit_control/firebase_options.dart';

/// Performs app bootstrap initialization.
///
/// Ensures Flutter bindings are initialized and initializes Firebase with
/// [DefaultFirebaseOptions.currentPlatform].
Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}
