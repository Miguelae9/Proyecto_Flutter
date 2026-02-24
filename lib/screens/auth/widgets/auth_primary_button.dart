import 'package:flutter/material.dart';

/// Primary call-to-action button used on the authentication screen.
class AuthPrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  const AuthPrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      height: 52,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.primaryColor,
          foregroundColor: theme.scaffoldBackgroundColor,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            letterSpacing: 1.4,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
