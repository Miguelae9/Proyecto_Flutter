import 'package:flutter/material.dart';

class LateralMenuItem extends StatelessWidget {
  static const Color _card = Color(0xFF141A22);
  static const Color _border = Color(0xFF1F2A37);

  final String label;
  final bool selected;
  final Color accent;
  final Color textMuted;
  final VoidCallback onTap;

  const LateralMenuItem({
    super.key,
    required this.label,
    required this.selected,
    required this.accent,
    required this.textMuted,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color color = selected ? accent : textMuted;

    return Container(
      height: 48,
      decoration: const BoxDecoration(
        color: _card,
        border: Border(
          top: BorderSide(color: _border),
          bottom: BorderSide(color: _border),
        ),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Row(
            children: <Widget>[
              Text(
                '>',
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  letterSpacing: 1.6,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
