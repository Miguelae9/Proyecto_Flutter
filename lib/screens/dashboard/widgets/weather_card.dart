import 'package:flutter/material.dart';

class WeatherCard extends StatelessWidget {
  final String city;
  final String temp;
  final String status;
  final String hum;
  final String wind;

  final Color textMain;
  final Color textMuted;

  const WeatherCard({
    super.key,
    required this.city,
    required this.temp,
    required this.status,
    required this.hum,
    required this.wind,
    required this.textMain,
    required this.textMuted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF141A22),
        border: Border.all(color: const Color(0xFF334155)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: <Widget>[
          const Icon(
            Icons.wb_sunny_outlined,
            color: Color(0xFF6CFAFF),
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  city,
                  style: TextStyle(
                    fontSize: 11,
                    letterSpacing: 1.4,
                    color: textMuted,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '$temp // $status',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                    color: textMain,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(
                'HUM: $hum',
                style: TextStyle(
                  fontSize: 10,
                  letterSpacing: 1.2,
                  color: textMuted,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'WIND: $wind',
                style: TextStyle(
                  fontSize: 10,
                  letterSpacing: 1.2,
                  color: textMuted,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
