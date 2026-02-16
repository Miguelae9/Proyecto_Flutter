import 'package:flutter/widgets.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:habit_control/firebase_options.dart';

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}
