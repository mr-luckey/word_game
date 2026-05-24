import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:word_game/core/theme/theme_context.dart';

/// Bottom nav — active tab gold square border (mockup).
class JourneyBottomNav extends StatelessWidget {
  const JourneyBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelected;

  static const _items = [
    (Icons.home_rounded, 'Home'),
    (Icons.explore_rounded, 'Explore'),
    (Icons.store_rounded, 'Shop'),
    (Icons.person_rounded, 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final spec = context.themePreset.homeSpec;

    return Container(
      decoration: BoxDecoration(
        color: colors.navSurface,
        border: Border(
          top: BorderSide(color: colors.glassBorder.withValues(alpha: 0.45)),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_items.length, (i) {
              final selected = i == selectedIndex;
              final (icon, label) = _items[i];
              return Expanded(
                child: InkWell(
                  onTap: () => onSelected(i),
                  borderRadius: BorderRadius.circular(12),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.all(8),
                        decoration: selected
                            ? BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: colors.glassBorder,
                                  width: 1.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: spec.playButtonGlow
                                        .withValues(alpha: 0.4),
                                    blurRadius: 10,
                                  ),
                                ],
                              )
                            : null,
                        child: Icon(
                          icon,
                          size: 24,
                          color: selected ? colors.gold : colors.onScenic,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        label,
                        style: GoogleFonts.montserrat(
                          fontSize: 10,
                          fontWeight:
                              selected ? FontWeight.w700 : FontWeight.w500,
                          color: selected ? colors.gold : colors.onScenic,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
