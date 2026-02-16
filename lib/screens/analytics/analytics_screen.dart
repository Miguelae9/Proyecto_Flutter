import 'package:flutter/material.dart';
import 'package:habit_control/shared/widgets/lateral_menu/lateral_menu.dart';

import 'widgets/stat_card.dart';
import 'widgets/weekly_bar_chart.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final Color bg = theme.scaffoldBackgroundColor;
    final Color textMain = theme.textTheme.bodyLarge?.color ?? Colors.white;
    final Color textMuted = theme.textTheme.bodyMedium?.color ?? Colors.grey;
    final Color accent = theme.primaryColor;

    final List<double> weeklyData = <double>[
      0.80,
      0.50,
      0.32,
      0.60,
      0.53,
      0.73,
      0.45,
    ];
    final List<String> days = <String>['L', 'M', 'X', 'J', 'V', 'S', 'D'];

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
                          value: '85%',
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
                          value: '12 DAYS',
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
