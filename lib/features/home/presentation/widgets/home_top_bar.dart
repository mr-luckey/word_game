import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:word_game/core/theme/theme_context.dart';

class HomeTopBar extends StatelessWidget {
  const HomeTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 6, 14, 0),
      child: Row(
        children: [
          _CircleBtn(
            icon: Icons.settings_rounded,
            onTap: () => context.push('/settings'),
          ),
        ],
      ),
    );
  }
}

class _CircleBtn extends StatelessWidget {
  const _CircleBtn({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Ink(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: colors.surface.withValues(alpha: 0.85),
            border: Border.all(color: colors.glassBorder, width: 1.5),
          ),
          child: Icon(icon, color: colors.gold, size: 22),
        ),
      ),
    );
  }
}
