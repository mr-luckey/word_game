import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:word_game/core/theme/theme_context.dart';

enum LevelSelectTab { map, stats }

class LevelSelectHeader extends StatelessWidget {
  const LevelSelectHeader({
    super.key,
    required this.destinationTitle,
    required this.currentLevelLabel,
    required this.selectedTab,
    required this.onTabChanged,
    required this.onBack,
  });

  final String destinationTitle;
  final String currentLevelLabel;
  final LevelSelectTab selectedTab;
  final ValueChanged<LevelSelectTab> onTabChanged;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 8),
      child: Column(
        children: [
          Row(
            children: [
              _BackButton(onPressed: onBack),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            destinationTitle,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.cinzel(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.5,
              color: colors.onScenic,
              shadows: [
                Shadow(
                  color: colors.scrim.withValues(alpha: 0.6),
                  blurRadius: 8,
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 1,
                  color: colors.glassBorder.withValues(alpha: 0.5),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  currentLevelLabel,
                  style: GoogleFonts.montserrat(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: colors.onScenicMuted,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 1,
                  color: colors.glassBorder.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: colors.surface.withValues(alpha: 0.75),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: colors.glassBorder.withValues(alpha: 0.6),
              ),
              boxShadow: [
                BoxShadow(
                  color: colors.scrim.withValues(alpha: 0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                _TabChip(
                  label: 'Map',
                  icon: Icons.map_rounded,
                  selected: selectedTab == LevelSelectTab.map,
                  onTap: () => onTabChanged(LevelSelectTab.map),
                ),
                _TabChip(
                  label: 'Stats',
                  icon: Icons.bar_chart_rounded,
                  selected: selectedTab == LevelSelectTab.stats,
                  onTap: () => onTabChanged(LevelSelectTab.stats),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: Ink(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: colors.onScenic.withValues(alpha: 0.92),
            border: Border.all(
              color: colors.glassBorder.withValues(alpha: 0.5),
            ),
            boxShadow: [
              BoxShadow(
                color: colors.scrim.withValues(alpha: 0.25),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(Icons.arrow_back_rounded, color: colors.primary, size: 22),
        ),
      ),
    );
  }
}

class _TabChip extends StatelessWidget {
  const _TabChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final spec = context.themePreset.homeSpec;

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(vertical: 9),
            decoration: BoxDecoration(
              color: selected
                  ? colors.onScenic.withValues(alpha: 0.95)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
              boxShadow: selected
                  ? [
                      BoxShadow(
                        color: spec.playButtonGlow.withValues(alpha: 0.25),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ]
                  : null,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 16,
                  color: selected ? colors.primary : colors.onScenicMuted,
                ),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: GoogleFonts.montserrat(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: selected ? colors.primary : colors.onScenicMuted,
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
