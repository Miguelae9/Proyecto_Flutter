import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:habit_control/router/app_routes.dart';

import 'lateral_menu_header.dart';
import 'lateral_menu_item.dart';

class LateralMenu extends StatelessWidget {
  const LateralMenu({super.key});

  static const Color _border = Color(0xFF1F2A37);

  void _navigate(BuildContext context, String routeName) {
    Navigator.of(context).pop();
    Navigator.pushReplacementNamed(context, routeName);
  }

  Future<void> _logout(BuildContext context) async {
    Navigator.of(context).pop();
    await FirebaseAuth.instance.signOut();

    if (!context.mounted) return;
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.home,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final bg = theme.scaffoldBackgroundColor;
    final accent = theme.primaryColor;

    final textMain =
        theme.textTheme.headlineLarge?.color ?? const Color(0xFFF8FAFC);
    final textMuted =
        theme.textTheme.bodyMedium?.color ?? const Color(0xFF94A3B8);

    final currentRoute = ModalRoute.of(context)?.settings.name;

    return Container(
      color: bg,
      child: SafeArea(
        child: Column(
          children: <Widget>[
            LateralMenuHeader(textMain: textMain),
            const SizedBox(height: 20),
            Container(height: 1, color: _border),

            LateralMenuItem(
              label: 'DASHBOARD',
              selected: currentRoute == AppRoutes.dashboard,
              accent: accent,
              textMuted: textMuted,
              onTap: () => _navigate(context, AppRoutes.dashboard),
            ),
            LateralMenuItem(
              label: 'INPUT LOG',
              selected: currentRoute == AppRoutes.inputLog,
              accent: accent,
              textMuted: textMuted,
              onTap: () => _navigate(context, AppRoutes.inputLog),
            ),
            LateralMenuItem(
              label: 'ANALYTICS',
              selected: currentRoute == AppRoutes.analytics,
              accent: accent,
              textMuted: textMuted,
              onTap: () => _navigate(context, AppRoutes.analytics),
            ),
            LateralMenuItem(
              label: 'ABOUT',
              selected: currentRoute == AppRoutes.credits,
              accent: accent,
              textMuted: textMuted,
              onTap: () => _navigate(context, AppRoutes.credits),
            ),

            const Spacer(),

            LateralMenuItem(
              label: 'LOG OUT',
              selected: false,
              accent: accent,
              textMuted: textMuted,
              onTap: () => _logout(context),
            ),
          ],
        ),
      ),
    );
  }
}
