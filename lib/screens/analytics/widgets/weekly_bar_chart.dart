import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

/// Weekly bar chart rendered with `fl_chart`.
///
/// Visible expectations:
/// - [data] values are plotted on a 0..1 scale (see `minY`/`maxY`)
/// - Left axis labels display percentages derived from `value * 100`
/// - Bars use their list index as the X coordinate and [days] for bottom labels
class WeeklyBarChart extends StatelessWidget {
  final List<double> data;
  final List<String> days;

  final Color accent;
  final Color gridColor;
  final Color borderColor;
  final Color axisTextColor;
  final Color labelTextColor;

  /// Creates a bar chart widget.
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
                if (value == 0 ||
                    value == 0.25 ||
                    value == 0.5 ||
                    value == 0.75 ||
                    value == 1) {
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
