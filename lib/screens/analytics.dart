import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:habit_control/screens/lateral_menu.dart';

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
          // padding extra para que no se recorten labels
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

/* ------------------ CHART ------------------ */

class WeeklyBarChart extends StatelessWidget {
  final List<double> data;
  final List<String> days;

  final Color accent;
  final Color gridColor;
  final Color borderColor;
  final Color axisTextColor;
  final Color labelTextColor;

  const WeeklyBarChart({
    super.key,
    required this.data,
    required this.days,
    required this.accent,
    required this.gridColor,
    required this.borderColor,
    required this.axisTextColor,
    required this.labelTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        minY: 0,
        // maxY fijo para comparar semanas
        maxY: 1,

        alignment: BarChartAlignment.spaceAround,
        backgroundColor: Colors.transparent,

        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (double value) {
            return FlLine(color: gridColor, strokeWidth: 1);
          },
        ),

        borderData: FlBorderData(
          show: true,
          border: Border.all(color: borderColor),
        ),

        titlesData: FlTitlesData(
          show: true,
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),

          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              interval: 0.25,
              getTitlesWidget: (double value, TitleMeta meta) {
                if (value == 0 || value == 0.25 || value == 0.5 || value == 0.75 || value == 1) {
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    space: 8,
                    child: Text(
                      '${(value * 100).toInt()}%',
                      style: TextStyle(
                        color: axisTextColor,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ),

          rightTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              interval: 0.5,
              getTitlesWidget: (double value, TitleMeta meta) {
                String text = '';
                if (value == 1) text = 'MAX';
                if (value == 0.5) text = 'MID';
                if (value == 0) text = 'MIN';

                if (text.isEmpty) return const SizedBox();

                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  space: 8,
                  child: Text(
                    text,
                    style: TextStyle(
                      color: axisTextColor.withValues(alpha: 0.7),
                      fontSize: 9,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
          ),

          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 42,
              getTitlesWidget: (double value, TitleMeta meta) {
                final int index = value.toInt();
                if (index < 0 || index >= days.length) return const SizedBox();

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const SizedBox(height: 8),
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: accent,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      days[index],
                      style: TextStyle(
                        color: labelTextColor,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
        barGroups: _buildGroups(),
      ),
    );
  }

  List<BarChartGroupData> _buildGroups() {
    final List<BarChartGroupData> groups = <BarChartGroupData>[];

    for (int i = 0; i < data.length; i++) {
      groups.add(
        BarChartGroupData(
          x: i,
          barRods: <BarChartRodData>[
            BarChartRodData(
              toY: data[i],
              color: accent,
              width: 15,
              borderRadius: BorderRadius.circular(2),
              backDrawRodData: BackgroundBarChartRodData(
                show: true,
                toY: 1,
                color: Colors.transparent,
              ),
            ),
          ],
        ),
      );
    }

    return groups;
  }
}

/* ------------------ STAT CARD ------------------ */

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final bool showUpArrow;

  final Color textMain;
  final Color borderColor;
  final Color bg;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.showUpArrow,
    required this.textMain,
    required this.borderColor,
    required this.bg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: bg,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            // 1 línea para mantener altura fija
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
              color: textMain,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                value,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.0,
                  color: textMain,
                ),
              ),
              if (showUpArrow) const SizedBox(width: 4),
              if (showUpArrow)
                const Icon(
                  Icons.arrow_drop_up,
                  size: 24,
                  color: Color(0xFF22C55E),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
