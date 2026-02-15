import 'package:flutter/material.dart';
import 'package:habit_control/shared/widgets/lateral_menu.dart';

class InputLogScreen extends StatefulWidget {
  const InputLogScreen({super.key});

  @override
  State<InputLogScreen> createState() {
    return _InputLogScreenState();
  }
}

class _InputLogScreenState extends State<InputLogScreen> {
  double _sleepHours = 7.5;
  int _energy = 85;
  double _socialHours = 4.5;

  // TODO: persistencia (SharedPreferences/DB)
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
                    onMinus: () {
                      _changeSleep(false);
                    },
                    onPlus: () {
                      _changeSleep(true);
                    },
                    textColor: textMain,
                    valueColor: textMuted,
                    accent: accent,
                  ),
                  const SizedBox(height: 22),

                  MetricRow(
                    label: '> ENERGY LEVEL',
                    value: '$_energy%',
                    onMinus: () {
                      _changeEnergy(false);
                    },
                    onPlus: () {
                      _changeEnergy(true);
                    },
                    textColor: textMain,
                    valueColor: textMuted,
                    accent: accent,
                  ),
                  const SizedBox(height: 22),

                  MetricRow(
                    label: '> SOCIAL MEDIA TIME',
                    value: _formatHours(_socialHours),
                    onMinus: () {
                      _changeSocial(false);
                    },
                    onPlus: () {
                      _changeSocial(true);
                    },
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

/* ------------------ WIDGETS AUXILIARES ------------------ */

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

class MetricRow extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onMinus;
  final VoidCallback onPlus;

  final Color textColor;
  final Color valueColor;
  final Color accent;

  const MetricRow({
    super.key,
    required this.label,
    required this.value,
    required this.onMinus,
    required this.onPlus,
    required this.textColor,
    required this.valueColor,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            letterSpacing: 1.8,
            color: textColor,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 14),
        Row(
          children: <Widget>[
            StepButton(isPlus: false, onTap: onMinus, accent: accent),
            const SizedBox(width: 18),
            Expanded(
              child: Center(
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 2,
                    color: valueColor,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 18),
            StepButton(isPlus: true, onTap: onPlus, accent: accent),
          ],
        ),
      ],
    );
  }
}

class StepButton extends StatelessWidget {
  final bool isPlus;
  final VoidCallback onTap;
  final Color accent;

  const StepButton({
    super.key,
    required this.isPlus,
    required this.onTap,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    final Color border = isPlus ? accent : const Color(0xFF64748B);
    final Color iconColor = isPlus ? accent : const Color(0xFF9CA3AF);

    return SizedBox(
      width: 54,
      height: 54,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: border),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          padding: EdgeInsets.zero,
        ),
        child: Icon(
          isPlus ? Icons.add : Icons.remove,
          color: iconColor,
          size: 22,
        ),
      ),
    );
  }
}
