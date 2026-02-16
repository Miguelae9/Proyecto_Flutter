import 'package:flutter/material.dart';
import 'dot.dart';

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
