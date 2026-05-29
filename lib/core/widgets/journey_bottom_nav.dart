import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:word_game/core/theme/theme_context.dart';
import 'package:word_game/core/widgets/shell_nav_metrics.dart';

/// Floating pill bottom nav with theme-aware glow.
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

  static const _radius = 28.0;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final spec = context.themePreset.homeSpec;
    final bottomInset = MediaQuery.viewPaddingOf(context).bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        ShellNavMetrics.horizontalMargin,
        0,
        ShellNavMetrics.horizontalMargin,
        bottomInset + ShellNavMetrics.floatBottomMargin,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(_radius),
          color: colors.navSurface.withValues(alpha: 0.94),
          border: Border.all(
            color: colors.glassBorder.withValues(alpha: 0.55),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: colors.scrim.withValues(alpha: 0.38),
              blurRadius: 22,
              offset: const Offset(0, 10),
            ),
            BoxShadow(
              color: spec.playButtonGlow.withValues(alpha: 0.22),
              blurRadius: 18,
              spreadRadius: 0.5,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(_radius),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: ShellNavMetrics.innerVerticalPadding,
              horizontal: 6,
            ),
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
                    borderRadius: BorderRadius.circular(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 42,
                          height: ShellNavMetrics.iconSlotHeight,
                          alignment: Alignment.center,
                          decoration: selected
                              ? BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
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
                        const SizedBox(height: ShellNavMetrics.labelGap),
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
      ),
    );
  }
}
