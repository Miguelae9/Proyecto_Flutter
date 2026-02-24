import 'package:flutter/material.dart';

/// Small section label used to title authentication fields.
class AuthSectionLabel extends StatelessWidget {
  final String text;

  const AuthSectionLabel({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 12,
        letterSpacing: 1.6,
        color: Color(0xFF6CFAFF),
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
