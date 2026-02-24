import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:habit_control/shared/widgets/lateral_menu/lateral_menu.dart';
import 'package:habit_control/shared/widgets/online_badge.dart';

import 'package:habit_control/shared/state/daily_metrics_store.dart';
import 'package:habit_control/shared/utils/day_key.dart';
import 'package:habit_control/screens/input_log/models/daily_metrics.dart';
import 'package:habit_control/screens/input_log/widgets/metric_row.dart';

/// Screen for editing daily metric inputs (sleep, energy, social hours).
///
/// Visible data source:
/// - Reads and writes values via [DailyMetricsStore] using today's `YYYY-MM-DD` key.
class InputLogScreen extends StatefulWidget {
  /// Creates the input log screen.
  const InputLogScreen({super.key});

  @override
  State<InputLogScreen> createState() => _InputLogScreenState();
}

class _InputLogScreenState extends State<InputLogScreen> {
  late String _todayKey;

  double _sleepHours = 0.0;
  int _energy = 0;
  double _socialHours = 0.0;

  @override
  void initState() {
    super.initState();

    _todayKey = dayKeyFromDate(DateTime.now());

    final DailyMetricsStore store = context.read<DailyMetricsStore>();
    final DailyMetrics initial = store.metricsForDay(_todayKey);

    _sleepHours = initial.sleepHours;
    _energy = initial.energy;
    _socialHours = initial.socialHours;

    WidgetsBinding.instance.addPostFrameCallback(_afterFirstFrame);
  }

  void _afterFirstFrame(Duration _) async {
    final DailyMetricsStore store = context.read<DailyMetricsStore>();

    // Refreshes local values from Firestore after first render, if available.
    await store.syncDayFromCloud(_todayKey);

    final DailyMetrics fresh = store.metricsForDay(_todayKey);
    if (!mounted) return;

    setState(() {
      _sleepHours = fresh.sleepHours;
      _energy = fresh.energy;
      _socialHours = fresh.socialHours;
    });
  }

  void _persistNow() {
    final DailyMetricsStore store = context.read<DailyMetricsStore>();
    final DailyMetrics value = DailyMetrics(
      sleepHours: _sleepHours,
      energy: _energy,
      socialHours: _socialHours,
    );
    store.setMetrics(_todayKey, value);
  }

  void _sleepMinus() {
    setState(() {
      _sleepHours = (_sleepHours - 0.5).clamp(0.0, 12.0);
    });
    _persistNow();
  }

  void _sleepPlus() {
    setState(() {
      _sleepHours = (_sleepHours + 0.5).clamp(0.0, 12.0);
    });
    _persistNow();
  }

  void _energyMinus() {
    setState(() {
      _energy = (_energy - 1).clamp(0, 10);
    });
    _persistNow();
  }

  void _energyPlus() {
    setState(() {
      _energy = (_energy + 1).clamp(0, 10);
    });
    _persistNow();
  }

  void _socialMinus() {
    setState(() {
      _socialHours = (_socialHours - 0.5).clamp(0.0, 10.0);
    });
    _persistNow();
  }

  void _socialPlus() {
    setState(() {
      _socialHours = (_socialHours + 0.5).clamp(0.0, 10.0);
    });
    _persistNow();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final Color bg = theme.scaffoldBackgroundColor;
    final Color textMain = theme.textTheme.bodyLarge?.color ?? Colors.white;
    final Color textMuted = theme.textTheme.bodyMedium?.color ?? Colors.grey;
    final Color accent = theme.primaryColor;

    return Scaffold(
      backgroundColor: bg,
      drawer: const Drawer(child: LateralMenu()),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Builder(
                        builder: (BuildContext ctx) {
                          return IconButton(
                            icon: Icon(Icons.menu, color: textMain),
                            onPressed: () {
                              Scaffold.of(ctx).openDrawer();
                            },
                          );
                        },
                      ),
                      const Spacer(),
                      OnlineBadge(textColor: textMain),
                    ],
                  ),
                  const SizedBox(height: 26),
                  Text(
                    'DAILY METRICS',
                    textAlign: TextAlign.center,
                    style:
                        theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                          letterSpacing: 2,
                          color: textMain,
                          fontSize: 26,
                        ) ??
                        TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 2,
                          color: textMain,
                        ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'ENTER DATA FOR CALCULATION',
                    textAlign: TextAlign.center,
                    style:
                        theme.textTheme.bodySmall?.copyWith(
                          letterSpacing: 2,
                          color: textMuted,
                          fontSize: 11,
                        ) ??
                        TextStyle(
                          fontSize: 11,
                          letterSpacing: 2,
                          color: textMuted,
                        ),
                  ),
                  const SizedBox(height: 28),

                  MetricRow(
                    label: 'SLEEP HOURS',
                    value: _sleepHours.toStringAsFixed(1),
                    onMinus: _sleepMinus,
                    onPlus: _sleepPlus,
                    textColor: textMuted,
                    valueColor: textMain,
                    accent: accent,
                  ),

                  const SizedBox(height: 28),

                  MetricRow(
                    label: 'ENERGY (0-10)',
                    value: '$_energy',
                    onMinus: _energyMinus,
                    onPlus: _energyPlus,
                    textColor: textMuted,
                    valueColor: textMain,
                    accent: accent,
                  ),

                  const SizedBox(height: 28),

                  MetricRow(
                    label: 'SOCIAL HOURS',
                    value: _socialHours.toStringAsFixed(1),
                    onMinus: _socialMinus,
                    onPlus: _socialPlus,
                    textColor: textMuted,
                    valueColor: textMain,
                    accent: accent,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
