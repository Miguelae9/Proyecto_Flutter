import 'package:flutter/material.dart';
import 'package:habit_control/screens/lateral_menu.dart';
import 'package:percent_indicator/percent_indicator.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() {
    return _DashboardScreenState();
  }
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

/* Models */
class Habit {
  final String title;
  final String streakText;
  bool active;

  Habit({required this.title, required this.streakText, bool? active})
    : active = active ?? false;
}

/* Widgets */
class OnlineBadge extends StatelessWidget {
  final Color textColor;

  const OnlineBadge({super.key, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        const Dot(color: Color(0xFF22C55E)),
        const SizedBox(width: 6),
        Text(
          'ONLINE',
          style: TextStyle(color: textColor, fontSize: 11, letterSpacing: 1.6),
        ),
      ],
    );
  }
}

class Dot extends StatelessWidget {
  final Color color;

  const Dot({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 7,
      height: 7,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class WeatherCard extends StatelessWidget {
  final String city;
  final String temp;
  final String status;
  final String hum;
  final String wind;

  final Color textMain;
  final Color textMuted;

  const WeatherCard({
    super.key,
    required this.city,
    required this.temp,
    required this.status,
    required this.hum,
    required this.wind,
    required this.textMain,
    required this.textMuted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF141A22),
        border: Border.all(color: const Color(0xFF334155)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: <Widget>[
          const Icon(
            Icons.wb_sunny_outlined,
            color: Color(0xFF6CFAFF),
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  city,
                  style: TextStyle(
                    fontSize: 11,
                    letterSpacing: 1.4,
                    color: textMuted,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '$temp // $status',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                    color: textMain,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(
                'HUM: $hum',
                style: TextStyle(
                  fontSize: 10,
                  letterSpacing: 1.2,
                  color: textMuted,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'WIND: $wind',
                style: TextStyle(
                  fontSize: 10,
                  letterSpacing: 1.2,
                  color: textMuted,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class HabitTile extends StatelessWidget {
  final String title;
  final String streak;
  final bool active;
  final Color accent;
  final VoidCallback onTap;

  const HabitTile({
    super.key,
    required this.title,
    required this.streak,
    required this.active,
    required this.accent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 74,
        decoration: BoxDecoration(
          color: const Color(0xFF1B2430),
          border: Border.all(color: const Color(0xFF0F172A)),
          borderRadius: BorderRadius.circular(2),
        ),
        child: Row(
          children: <Widget>[
            Container(
              height: 60,
              width: 4,
              color: accent,
              margin: const EdgeInsets.only(left: 10),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.6,
                      color: Color(0xFFE5E7EB),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    streak,
                    style: const TextStyle(
                      fontSize: 10,
                      letterSpacing: 1.4,
                      color: Color(0xFF9CA3AF),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 18,
              height: 18,
              margin: const EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                border: Border.all(color: accent, width: 1.5),
                color: active ? const Color(0xFF6CFAFF) : Colors.transparent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
