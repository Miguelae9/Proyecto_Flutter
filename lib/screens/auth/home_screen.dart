import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:habit_control/router/app_routes.dart';

import 'widgets/auth_logo.dart';
import 'widgets/auth_primary_button.dart';
import 'widgets/auth_section_label.dart';
import 'widgets/auth_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _userCtrl = TextEditingController();
  final TextEditingController _passCtrl = TextEditingController();

  bool _isLoading = false;

  String _toEmail(String username) {
    final u = username.trim();
    if (u.contains('@')) return u;
    if (u.toLowerCase() == 'usuario') return 'usuario@profe.local';
    return '$u@profe.local';
  }

  Future<void> _login() async {
    if (_isLoading) return;

    setState(_setLoadingTrue);

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _toEmail(_userCtrl.text),
        password: _passCtrl.text,
      );

      if (!mounted) return;
      Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
    } on FirebaseAuthException {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Credenciales incorrectas')));
    } finally {
      if (mounted) {
        setState(_setLoadingFalse);
      }
    }
  }

  void _setLoadingTrue() {
    _isLoading = true;
  }

  void _setLoadingFalse() {
    _isLoading = false;
  }

  @override
  void dispose() {
    _userCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final Color bg = theme.scaffoldBackgroundColor;
    final Color textMain =
        theme.textTheme.headlineLarge?.color ?? const Color(0xFFE5E7EB);
    final Color textMuted =
        theme.textTheme.bodyMedium?.color ?? const Color(0xFF9CA3AF);

    final String buttonText = _isLoading ? 'CONNECTING...' : 'CONNECT';
    final VoidCallback? onPressed = _isLoading ? null : _login;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const Center(child: AuthLogo()),
                const SizedBox(height: 18),
                Text(
                  'HABIT\nCONTROL',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineLarge?.copyWith(
                    color: textMain,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'SYSTEM\nINITIALIZATION',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 11,
                    letterSpacing: 2.0,
                    height: 1.2,
                    color: textMuted,
                  ),
                ),
                const SizedBox(height: 50),

                const AuthSectionLabel(text: '> IDENTIFIER'),
                const SizedBox(height: 10),
                AuthTextField(
                  controller: _userCtrl,
                  hintText: 'usuario',
                  obscureText: false,
                ),

                const SizedBox(height: 18),

                const AuthSectionLabel(text: '> ACCESS KEY'),
                const SizedBox(height: 10),
                AuthTextField(
                  controller: _passCtrl,
                  hintText: '•••••••',
                  obscureText: true,
                ),

                const SizedBox(height: 40),

                AuthPrimaryButton(text: buttonText, onPressed: onPressed),

                const SizedBox(height: 40),

                Text(
                  'v0.1.0 [MVP_BUILD]',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontSize: 10,
                    color: const Color(0xFF6B7280),
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
