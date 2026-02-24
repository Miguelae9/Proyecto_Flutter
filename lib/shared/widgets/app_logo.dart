import 'package:flutter/material.dart';

/// Application logo widget backed by a bundled asset image.
class AppLogo extends StatelessWidget {
  final double size;
  final double borderRadius;

  /// Creates the logo with a square [size] and optional [borderRadius].
  const AppLogo({super.key, required this.size, this.borderRadius = 16});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Image.asset(
        'assets/imgs/habit_control_logo.png',
        width: size,
        height: size,
        fit: BoxFit.cover,
      ),
    );
  }
}
