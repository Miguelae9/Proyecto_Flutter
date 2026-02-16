import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:habit_control/router/app_routes.dart';
import 'package:habit_control/theme/app_theme.dart';
import 'package:habit_control/shared/state/habit_day_store.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final HabitDayStore _store;

  @override
  void initState() {
    super.initState();
    _store = HabitDayStore();
    _store.loadLocal();
  }

  @override
  void dispose() {
    _store.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HabitDayStore>.value(
      value: _store,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Habit Control',
        theme: AppTheme.dark(),
        initialRoute: AppRoutes.splash,
        routes: AppRoutes.map,
      ),
    );
  }
}
