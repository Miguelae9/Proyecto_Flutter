import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

import 'package:habit_control/shared/widgets/lateral_menu/lateral_menu.dart';

import 'package:habit_control/screens/dashboard/models/habit.dart';
import 'package:habit_control/screens/dashboard/widgets/habit_tile.dart';
import 'package:habit_control/shared/widgets/online_badge.dart';
import 'package:habit_control/screens/dashboard/widgets/weather_card.dart';

import 'package:provider/provider.dart';
import 'package:habit_control/shared/state/habit_day_store.dart';
import 'package:habit_control/shared/utils/day_key.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Habit> _habits = <Habit>[
    const Habit(id: 'gym', title: 'GYM', streakText: 'STREAK: 4 DAYS'),
    const Habit(id: 'reading', title: 'READING', streakText: 'STREAK: 15 DAYS'),
    const Habit(
      id: 'meditation',
      title: 'MEDITATION',
      streakText: 'STREAK: 2 DAYS',
    ),
    const Habit(
      id: 'sleep_8h',
      title: 'SLEEP 8\nHOURS',
      streakText: 'STREAK: 5 DAYS',
    ),
    const Habit(id: 'water', title: 'WATER', streakText: 'STREAK: 3 DAYS'),
    const Habit(id: 'running', title: 'RUNNING', streakText: 'STREAK: 1 DAY'),
  ];

  void _openDrawer() {
    final ScaffoldState? state = _scaffoldKey.currentState;
    if (state != null) {
      state.openDrawer();
    }
  }

  List<Widget> _buildHabitTiles(String todayKey) {
    final store = context.watch<HabitDayStore>();
    final doneIds = store.doneForDay(todayKey);

    final List<Widget> tiles = <Widget>[];

    for (int i = 0; i < _habits.length; i++) {
      final habit = _habits[i];
      final isActive = doneIds.contains(habit.id);

      tiles.add(
        HabitTile(
          title: habit.title,
          streak: habit.streakText,
          active: isActive,
          accent: isActive ? const Color(0xFF6CFAFF) : const Color(0xFF93A3B8),
          onTap: () {
            context.read<HabitDayStore>().toggleHabitForDay(
              dayKey: todayKey,
              habitId: habit.id,
            );
          },
        ),
      );
    }

    return tiles;
  }

  void _afterFirstFrame(Duration _) {
    final HabitDayStore store = context.read<HabitDayStore>();
    final String today = dayKeyFromDate(DateTime.now());

    store.trySyncPending();
    store.syncDayFromCloud(today);
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(_afterFirstFrame);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final Color bg = theme.scaffoldBackgroundColor;
    final Color textMain =
        theme.textTheme.headlineLarge?.color ?? const Color(0xFFE5E7EB);
    final Color textMuted =
        theme.textTheme.bodyMedium?.color ?? const Color(0xFF9CA3AF);

    final String todayKey = dayKeyFromDate(DateTime.now());
    final done = context.watch<HabitDayStore>().doneForDay(todayKey).length;
    final double progresoDecimal = _habits.isEmpty
        ? 0.0
        : (done / _habits.length);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: bg,
      drawer: const Drawer(
        backgroundColor: Color.fromARGB(34, 0, 70, 221),
        child: LateralMenu(),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.menu, color: textMain),
                      onPressed: _openDrawer,
                    ),
                    const Spacer(),
                    OnlineBadge(textColor: textMain),
                  ],
                ),

                const SizedBox(height: 20),

                Center(
                  // percent_indicator usa 0.0–1.0
                  child: CircularPercentIndicator(
                    radius: 105.0,
                    lineWidth: 14.0,

                    percent: progresoDecimal,

                    animation: true,
                    animateFromLastPercent: true,
                    animationDuration: 600,
                    circularStrokeCap: CircularStrokeCap.round,

                    backgroundColor: const Color(0xFF1E293B),
                    progressColor: const Color(0xFF6CFAFF),

                    center: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          '${(progresoDecimal * 100).toInt()}%',
                          style: TextStyle(
                            fontSize: 44,
                            fontWeight: FontWeight.w800,
                            color: textMain,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'COMPLETED',
                          style: TextStyle(
                            fontSize: 11,
                            letterSpacing: 2.0,
                            color: textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                WeatherCard(
                  city: 'MALAGA, ES',
                  temp: '18°C',
                  status: 'OPTIMAL',
                  hum: '45%',
                  wind: '12km/h',
                  textMain: textMain,
                  textMuted: textMuted,
                ),

                const SizedBox(height: 30),

                Column(children: _buildHabitTiles(todayKey)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
