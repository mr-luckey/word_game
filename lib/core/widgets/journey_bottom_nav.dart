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
  ];

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final spec = context.themePreset.homeSpec;

    return Container(
      decoration: BoxDecoration(
        color: colors.navSurface.withValues(alpha: 0.94),
        border: Border(
          top: BorderSide(color: colors.glassBorder.withValues(alpha: 0.45)),
        ),
        boxShadow: [
          BoxShadow(
            color: spec.playButtonGlow.withValues(alpha: 0.2),
            blurRadius: 18,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(4, (i) {
              final selected = i == selectedIndex;
              final (icon, label) = switch (i) {
                0 => _items[0],
                1 => _items[1],
                2 => (spec.navShopIcon, 'Shop'),
                3 => (spec.navProfileIcon, 'Profile'),
                _ => _items[0],
              };
              return Expanded(
                child: InkWell(
                  onTap: () => onSelected(i),
                  borderRadius: BorderRadius.circular(12),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 42,
                        height: 36,
                        alignment: Alignment.center,
                        decoration: selected
                            ? BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: spec.cardFill.withValues(alpha: 0.68),
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
                          size: 22,
                          color: selected
                              ? colors.gold
                              : colors.onScenicMuted.withValues(alpha: 0.78),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        label,
                        style: GoogleFonts.montserrat(
                          fontSize: 10,
                          fontWeight:
                              selected ? FontWeight.w700 : FontWeight.w500,
                          color: selected
                              ? colors.gold
                              : colors.onScenicMuted.withValues(alpha: 0.82),
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
