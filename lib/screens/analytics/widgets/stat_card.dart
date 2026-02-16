import 'package:flutter/material.dart';

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
