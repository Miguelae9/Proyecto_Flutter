import 'package:flutter/material.dart';
import 'step_button.dart';

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
