import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

import 'package:habit_control/shared/widgets/lateral_menu.dart';

import 'package:habit_control/screens/dashboard/models/habit.dart';
import 'package:habit_control/screens/dashboard/widgets/habit_tile.dart';
import 'package:habit_control/screens/dashboard/widgets/online_badge.dart';
import 'package:habit_control/screens/dashboard/widgets/weather_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // TODO: conectar a datos reales
  final List<Habit> _habits = <Habit>[
    Habit(title: 'GYM', streakText: 'STREAK: 4 DAYS', active: false),
    Habit(title: 'READING', streakText: 'STREAK: 15 DAYS', active: false),
    Habit(title: 'MEDITATION', streakText: 'STREAK: 2 DAYS', active: false),
    Habit(title: 'SLEEP 8\nHOURS', streakText: 'STREAK: 5 DAYS', active: false),
    Habit(title: 'WATER', streakText: 'STREAK: 3 DAYS', active: false),
    Habit(title: 'RUNNING', streakText: 'STREAK: 1 DAY', active: false),
  ];

  void _openDrawer() {
    final ScaffoldState? state = _scaffoldKey.currentState;
    if (state != null) {
      state.openDrawer();
    }
  }

  void _toggleHabit(int index) {
    setState(() {
      _habits[index].active = !_habits[index].active;
    });
  }

  int _countCompleted() {
    int completed = 0;
    for (int i = 0; i < _habits.length; i++) {
      if (_habits[i].active) {
        completed++;
      }
    }
    return completed;
  }

  double _progress() {
    if (_habits.isEmpty) {
      return 0.0;
    }
    final int completed = _countCompleted();
    return completed / _habits.length;
  }

  List<Widget> _buildHabitTiles() {
    final List<Widget> tiles = <Widget>[];

    for (int i = 0; i < _habits.length; i++) {
      final Habit habit = _habits[i];

      tiles.add(
        HabitTile(
          title: habit.title,
          streak: habit.streakText,
          active: habit.active,
          accent: habit.active
              ? const Color(0xFF6CFAFF)
              : const Color(0xFF93A3B8),
          onTap: () {
            _toggleHabit(i);
          },
        ),
      );
    }

    return tiles;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final Color bg = theme.scaffoldBackgroundColor;
    final Color textMain =
        theme.textTheme.headlineLarge?.color ?? const Color(0xFFE5E7EB);
    final Color textMuted =
        theme.textTheme.bodyMedium?.color ?? const Color(0xFF9CA3AF);

    final double progresoDecimal = _progress();

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

                Column(children: _buildHabitTiles()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
