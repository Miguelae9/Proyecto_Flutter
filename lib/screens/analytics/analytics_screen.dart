import 'package:flutter/material.dart';
import 'package:habit_control/shared/widgets/lateral_menu/lateral_menu.dart';

import 'widgets/stat_card.dart';
import 'widgets/weekly_bar_chart.dart';

import 'package:provider/provider.dart';
import 'package:habit_control/shared/state/habit_day_store.dart';
import 'package:habit_control/shared/utils/day_key.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  static const int _totalHabits = 6;

  DateTime _startOfWeek(DateTime d) {
    final date = DateTime(d.year, d.month, d.day);
    final delta = date.weekday - DateTime.monday;
    return date.subtract(Duration(days: delta));
  }

  List<String> _weekKeys(DateTime now) {
    final start = _startOfWeek(now);

    final List<String> keys = <String>[];
    for (int i = 0; i < 7; i++) {
      final DateTime day = start.add(Duration(days: i));
      keys.add(dayKeyFromDate(day));
    }
    return keys;
  }

  Future<void> _syncWeekIfPossible() async {
    final HabitDayStore store = context.read<HabitDayStore>();
    await store.trySyncPending();

    final List<String> keys = _weekKeys(DateTime.now());
    for (final String k in keys) {
      await store.syncDayFromCloud(k);
    }
  }

  void _afterFirstFrame(Duration _) {
    _syncWeekIfPossible();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_afterFirstFrame);
  }

  List<int> _computeDoneCounts(HabitDayStore store, List<String> keys) {
    final List<int> counts = <int>[];
    for (int i = 0; i < keys.length; i++) {
      final String dayKey = keys[i];
      final int done = store.doneForDay(dayKey).length;
      counts.add(done);
    }
    return counts;
  }

  List<double> _computeWeeklyData(List<int> doneCounts) {
    final List<double> data = <double>[];
    for (int i = 0; i < doneCounts.length; i++) {
      final int c = doneCounts[i];
      double ratio = 0.0;
      if (_totalHabits != 0) {
        ratio = c / _totalHabits;
      }
      data.add(ratio);
    }
    return data;
  }

  int _computeConsistencyPct(List<double> weeklyData) {
    if (weeklyData.isEmpty) return 0;

    double sum = 0.0;
    for (int i = 0; i < weeklyData.length; i++) {
      sum += weeklyData[i];
    }
    final double avg = sum / weeklyData.length;
    return (avg * 100).round();
  }

  int _computeStreak(List<String> keys, List<int> doneCounts) {
    int streak = 0;

    final String todayKey = dayKeyFromDate(DateTime.now());
    final int todayIndex = keys.indexOf(todayKey);

    if (todayIndex == -1) return 0;

    for (int i = todayIndex; i >= 0; i--) {
      if (doneCounts[i] > 0) {
        streak++;
      } else {
        break;
      }
    }

    return streak;
  }

  Widget _buildMenuButton(Color textMain) {
    return Builder(
      builder: (BuildContext ctx) {
        return IconButton(
          icon: Icon(Icons.menu, color: textMain),
          onPressed: () {
            Scaffold.of(ctx).openDrawer();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final Color bg = theme.scaffoldBackgroundColor;
    final Color textMain = theme.textTheme.bodyLarge?.color ?? Colors.white;
    final Color textMuted = theme.textTheme.bodyMedium?.color ?? Colors.grey;
    final Color accent = theme.primaryColor;

    final List<String> days = <String>['L', 'M', 'X', 'J', 'V', 'S', 'D'];

    final HabitDayStore store = context.watch<HabitDayStore>();
    final List<String> keys = _weekKeys(DateTime.now());

    final List<int> doneCounts = _computeDoneCounts(store, keys);
    final List<double> weeklyData = _computeWeeklyData(doneCounts);
    final int consistencyPct = _computeConsistencyPct(weeklyData);
    final int streak = _computeStreak(keys, doneCounts);

    return Scaffold(
      backgroundColor: bg,
      drawer: const Drawer(child: LateralMenu()),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      _buildMenuButton(textMain),
                      const Spacer(),
                      Text(
                        'WEEKLY PERFORMANCE',
                        style: TextStyle(
                          fontSize: 11,
                          letterSpacing: 1.8,
                          color: textMain,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    height: 320,
                    child: WeeklyBarChart(
                      data: weeklyData,
                      days: days,
                      accent: accent,
                      gridColor: textMuted.withValues(alpha: 0.25),
                      borderColor: textMuted.withValues(alpha: 0.35),
                      axisTextColor: textMuted.withValues(alpha: 0.85),
                      labelTextColor: textMuted,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: StatCard(
                          title: 'CONSISTENCY',
                          value: '$consistencyPct%',
                          showUpArrow: true,
                          textMain: textMain,
                          borderColor: textMuted.withValues(alpha: 0.35),
                          bg: bg,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: StatCard(
                          title: 'CURRENT STREAK',
                          value: '$streak DAYS',
                          showUpArrow: false,
                          textMain: textMain,
                          borderColor: textMuted.withValues(alpha: 0.5),
                          bg: bg,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    '“EXCELLENCE IS\nA HABIT,\nNOT AN ACT”',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      height: 1.15,
                      letterSpacing: 1.2,
                      color: textMuted,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'ARISTOTLE',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      letterSpacing: 2.0,
                      color: textMuted.withValues(alpha: 0.75),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
