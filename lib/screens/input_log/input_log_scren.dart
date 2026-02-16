import 'package:flutter/material.dart';
import 'package:habit_control/shared/widgets/lateral_menu/lateral_menu.dart';

import 'package:habit_control/shared/widgets/online_badge.dart';
import 'package:habit_control/screens/input_log/widgets/metric_row.dart';

class InputLogScreen extends StatefulWidget {
  const InputLogScreen({super.key});

  @override
  State<InputLogScreen> createState() => _InputLogScreenState();
}

class _InputLogScreenState extends State<InputLogScreen> {
  double _sleepHours = 7.5;
  int _energy = 85;
  double _socialHours = 4.5;

  String _formatHours(double value) {
    final int h = value.floor();
    final int m = ((value - h) * 60).round();
    return '${h}h ${m}m';
  }

  void _changeSleep(bool plus) {
    setState(() {
      final double next = plus ? _sleepHours + 0.5 : _sleepHours - 0.5;
      if (next < 0) _sleepHours = 0;
      if (next > 24) _sleepHours = 24;
      if (next >= 0 && next <= 24) _sleepHours = next;
    });
  }

  void _changeEnergy(bool plus) {
    setState(() {
      final int next = plus ? _energy + 5 : _energy - 5;
      if (next < 0) _energy = 0;
      if (next > 100) _energy = 100;
      if (next >= 0 && next <= 100) _energy = next;
    });
  }

  void _changeSocial(bool plus) {
    setState(() {
      final double next = plus ? _socialHours + 0.25 : _socialHours - 0.25;
      if (next < 0) {
        _socialHours = 0;
      } else {
        _socialHours = next;
      }
    });
  }

  void _saveRecord() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'RECORD SAVED SUCCESSFULLY',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        duration: const Duration(seconds: 2),
      ),
    );
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
                    label: '> SLEEP HOURS',
                    value: _formatHours(_sleepHours),
                    onMinus: () => _changeSleep(false),
                    onPlus: () => _changeSleep(true),
                    textColor: textMain,
                    valueColor: textMuted,
                    accent: accent,
                  ),
                  const SizedBox(height: 22),
                  MetricRow(
                    label: '> ENERGY LEVEL',
                    value: '$_energy%',
                    onMinus: () => _changeEnergy(false),
                    onPlus: () => _changeEnergy(true),
                    textColor: textMain,
                    valueColor: textMuted,
                    accent: accent,
                  ),
                  const SizedBox(height: 22),
                  MetricRow(
                    label: '> SOCIAL MEDIA TIME',
                    value: _formatHours(_socialHours),
                    onMinus: () => _changeSocial(false),
                    onPlus: () => _changeSocial(true),
                    textColor: textMain,
                    valueColor: textMuted,
                    accent: accent,
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _saveRecord,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accent,
                        foregroundColor: bg,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      child: const Text(
                        'SAVE RECORD',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.4,
                          fontSize: 12,
                        ),
                      ),
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
