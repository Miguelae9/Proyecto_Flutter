import 'package:flutter/material.dart';

/// Outlined square button used for stepping a value up or down.
class StepButton extends StatelessWidget {
  /// Whether this is the "+" variant.
  final bool isPlus;

  /// Called when the button is pressed.
  final VoidCallback onTap;

  /// Accent color used for the "+" variant.
  final Color accent;

  /// Creates a step button.
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
