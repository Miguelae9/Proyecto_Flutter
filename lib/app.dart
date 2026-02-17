import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:habit_control/router/app_routes.dart';
import 'package:habit_control/theme/app_theme.dart';
import 'package:habit_control/shared/state/habit_day_store.dart';
import 'package:habit_control/shared/state/daily_metrics_store.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final HabitDayStore _habitStore;
  late final DailyMetricsStore _metricsStore;

  @override
  void initState() {
    super.initState();
    _habitStore = HabitDayStore()..loadLocal();
    _metricsStore = DailyMetricsStore()..loadLocal();
  }

  @override
  void dispose() {
    _habitStore.dispose();
    _metricsStore.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<HabitDayStore>.value(value: _habitStore),
        ChangeNotifierProvider<DailyMetricsStore>.value(value: _metricsStore),
      ],
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
