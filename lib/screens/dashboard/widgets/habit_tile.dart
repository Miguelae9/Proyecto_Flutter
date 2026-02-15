import 'package:flutter/material.dart';

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
