import 'package:flutter/material.dart';
import 'package:habit_control/shared/widgets/app_logo.dart';

/// Header section of the [LateralMenu] drawer.
class LateralMenuHeader extends StatelessWidget {
  final Color textMain;

  const LateralMenuHeader({super.key, required this.textMain});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 12),
      child: Column(
        children: <Widget>[
          const AppLogo(size: 150),
          const SizedBox(height: 25),
          Text(
            'HABIT\nCONTROL',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: textMain,
              fontSize: 28,
              fontWeight: FontWeight.w900,
              height: 1.05,
              letterSpacing: 1.8,
            ),
          ),
        ],
      ),
    );
  }
}
