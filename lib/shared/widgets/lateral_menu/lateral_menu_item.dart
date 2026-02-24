import 'package:flutter/material.dart';

class LateralMenuItem extends StatelessWidget {
  static const Color _card = Color(0xFF141A22);
  static const Color _border = Color(0xFF1F2A37);

  final String label;
  final bool selected;
  final Color accent;
  final Color textMuted;

  final String? routeName;
  final bool replace;
  final bool clearStack;

  final Future<void> Function(BuildContext)? onTap;

  const LateralMenuItem({
    super.key,
    required this.label,
    required this.selected,
    required this.accent,
    required this.textMuted,
    this.routeName,
    this.replace = true,
    this.clearStack = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color color = selected ? accent : textMuted;

    return Container(
      height: 48,
      decoration: const BoxDecoration(
        color: _card,
        border: Border(
          top: BorderSide(color: _border),
          bottom: BorderSide(color: _border),
        ),
      ),
      child: InkWell(
        onTap: _handleTapNoArgs(context),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Row(
            children: <Widget>[
              Text(
                '>',
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  letterSpacing: 1.6,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  VoidCallback _handleTapNoArgs(BuildContext context) {
    return _TapHandler(context, this).call;
  }
}

class _TapHandler {
  _TapHandler(this.context, this.item);

  final BuildContext context;
  final LateralMenuItem item;

  void call() {
    item._handleTap(context);
  }
}

extension on LateralMenuItem {
  void _handleTap(BuildContext context) {
    if (onTap != null) {
      onTap!(context);
      return;
    }

    if (routeName == null) return;

    Navigator.of(context).pop();

    if (clearStack) {
      Navigator.pushNamedAndRemoveUntil(context, routeName!, _removeAllRoutes);
      return;
    }

    if (replace) {
      Navigator.pushReplacementNamed(context, routeName!);
      return;
    }

    Navigator.pushNamed(context, routeName!);
  }

  static bool _removeAllRoutes(Route<dynamic> route) {
    return false;
  }
}
