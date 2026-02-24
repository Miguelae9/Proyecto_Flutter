import 'package:flutter/material.dart';
import 'package:habit_control/shared/widgets/app_logo.dart';

/// App logo sized for the authentication screen.
class AuthLogo extends StatelessWidget {
  const AuthLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppLogo(size: 130);
  }
}
