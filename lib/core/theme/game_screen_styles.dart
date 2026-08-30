import 'package:flutter/material.dart';
import 'package:word_game/core/theme/app_theme_preset.dart';

/// Per-theme tokens for the in-game screen (neon glass + moving light borders).
class GameScreenSpec {
  const GameScreenSpec({
    required this.panelFill,
    required this.gridFill,
    required this.wordListBorderLights,
    required this.gridBorderLights,
    required this.hintButtonGlow,
    required this.revealButtonGlow,
    required this.shuffleButtonGlow,
    required this.wordIconColors,
    this.lightAtmosphere = false,
    this.wordChipText = const Color(0xFFFFFFFF),
    this.chaseLight = const Color(0xFFFFFFFF),
  });

  final Color panelFill;
  final Color gridFill;
  final List<Color> wordListBorderLights;
  final List<Color> gridBorderLights;
  final Color hintButtonGlow;
  final Color revealButtonGlow;
  final Color shuffleButtonGlow;
  final List<Color> wordIconColors;

  /// Bright scenic themes (e.g. Winter Alps) use frost panels and icy lights.
  final bool lightAtmosphere;
  final Color wordChipText;
  final Color chaseLight;
}

const _wordIconPaletteClassic = [
  Color(0xFFFF9800),
  Color(0xFF42A5F5),
  Color(0xFFFFD700),
  Color(0xFFAB47BC),
  Color(0xFF66BB6A),
];

const _wordIconPaletteForest = [
  Color(0xFFC5A059),
  Color(0xFF81C784),
  Color(0xFFAED581),
  Color(0xFF43A047),
  Color(0xFF66BB6A),
];

const _wordIconPaletteNeon = [
  Color(0xFFFF4081),
  Color(0xFF00E5FF),
  Color(0xFFFFD740),
  Color(0xFFEA00FF),
  Color(0xFF69F0AE),
];

const _wordIconPaletteSunset = [
  Color(0xFFFF9800),
  Color(0xFFFFB300),
  Color(0xFFFF7043),
  Color(0xFFE65100),
  Color(0xFFFFD54F),
];

const _wordIconPaletteWinter = [
  Color(0xFF1565C0),
  Color(0xFF0277BD),
  Color(0xFF1E88E5),
  Color(0xFF0288D1),
  Color(0xFF0D47A1),
];

const _wordIconPaletteLuxury = [
  Color(0xFFD4AF37),
  Color(0xFFFFE082),
  Color(0xFFB8860B),
  Color(0xFFFFD700),
  Color(0xFFC5A059),
];

const _wordIconPaletteOcean = [
  Color(0xFF26C6DA),
  Color(0xFF4DD0E1),
  Color(0xFF00ACC1),
  Color(0xFF80DEEA),
  Color(0xFF00838F),
];

extension GameScreenSpecX on AppThemePreset {
  GameScreenSpec get gameSpec => switch (this) {
        AppThemePreset.classicTravel => const GameScreenSpec(
              panelFill: Color(0xD60A1628),
              gridFill: Color(0xE00A1628),
              wordListBorderLights: [
                Color(0xFFFFD700),
                Color(0xFF4FC3F7),
                Color(0xFFD4AF37),
                Color(0xFF1A6BB5),
              ],
              gridBorderLights: [
                Color(0xFF1A6BB5),
                Color(0xFFFFD700),
                Color(0xFF4FC3F7),
                Color(0xFFD4AF37),
              ],
              hintButtonGlow: Color(0xFF4FC3F7),
              revealButtonGlow: Color(0xFFFFD700),
              shuffleButtonGlow: Color(0xFFD4AF37),
              wordIconColors: _wordIconPaletteClassic,
              chaseLight: Color(0xFFFFF3C4),
            ),
        AppThemePreset.forestQuest => const GameScreenSpec(
              panelFill: Color(0xD6051A05),
              gridFill: Color(0xE0051A05),
              wordListBorderLights: [
                Color(0xFF81C784),
                Color(0xFFC5A059),
                Color(0xFF43A047),
                Color(0xFFAED581),
              ],
              gridBorderLights: [
                Color(0xFF43A047),
                Color(0xFFC5A059),
                Color(0xFF81C784),
                Color(0xFF2E7D32),
              ],
              hintButtonGlow: Color(0xFF81C784),
              revealButtonGlow: Color(0xFFC5A059),
              shuffleButtonGlow: Color(0xFF66BB6A),
              wordIconColors: _wordIconPaletteForest,
              chaseLight: Color(0xFFE8F5E9),
            ),
        AppThemePreset.neonCity => const GameScreenSpec(
              panelFill: Color(0xD60A0A1A),
              gridFill: Color(0xE00A0A1A),
              wordListBorderLights: [
                Color(0xFFFF00FF),
                Color(0xFF9D00FF),
                Color(0xFF00E5FF),
                Color(0xFFFF4081),
              ],
              gridBorderLights: [
                Color(0xFFEA00FF),
                Color(0xFF9D00FF),
                Color(0xFF00E5FF),
                Color(0xFFFF4081),
              ],
              hintButtonGlow: Color(0xFFEA00FF),
              revealButtonGlow: Color(0xFFFFD700),
              shuffleButtonGlow: Color(0xFF00E5FF),
              wordIconColors: _wordIconPaletteNeon,
              chaseLight: Color(0xFFFFE6FF),
            ),
        AppThemePreset.sunsetSafari => const GameScreenSpec(
              panelFill: Color(0xD62B1D14),
              gridFill: Color(0xE02B1D14),
              wordListBorderLights: [
                Color(0xFFFFB300),
                Color(0xFFE65100),
                Color(0xFFFF7043),
                Color(0xFFFFD54F),
              ],
              gridBorderLights: [
                Color(0xFFE65100),
                Color(0xFFFFB300),
                Color(0xFFFF7043),
                Color(0xFFFF8A65),
              ],
              hintButtonGlow: Color(0xFFFF7043),
              revealButtonGlow: Color(0xFFFFB300),
              shuffleButtonGlow: Color(0xFFFF7043),
              wordIconColors: _wordIconPaletteSunset,
              chaseLight: Color(0xFFFFF3E0),
            ),
        AppThemePreset.winterAlps => const GameScreenSpec(
              panelFill: Color(0xE8F4FAFF),
              gridFill: Color(0xF2FFFFFF),
              wordListBorderLights: [
                Color(0xFFFFFFFF),
                Color(0xFFB3E5FC),
                Color(0xFF90CAF9),
                Color(0xFFE1F5FE),
              ],
              gridBorderLights: [
                Color(0xFFFFFFFF),
                Color(0xFF81D4FA),
                Color(0xFFBBDEFB),
                Color(0xFF4FC3F7),
              ],
              hintButtonGlow: Color(0xFF42A5F5),
              revealButtonGlow: Color(0xFF1E88E5),
              shuffleButtonGlow: Color(0xFF81D4FA),
              wordIconColors: _wordIconPaletteWinter,
              lightAtmosphere: true,
              wordChipText: Color(0xFF0D2137),
              chaseLight: Color(0xFFFFFFFF),
            ),
        AppThemePreset.darkLuxury => const GameScreenSpec(
              panelFill: Color(0xD60A0A0A),
              gridFill: Color(0xE00A0A0A),
              wordListBorderLights: [
                Color(0xFFD4AF37),
                Color(0xFFFFE082),
                Color(0xFFB8860B),
                Color(0xFFFFD700),
              ],
              gridBorderLights: [
                Color(0xFFD4AF37),
                Color(0xFFFFE082),
                Color(0xFFB8860B),
                Color(0xFFC5A059),
              ],
              hintButtonGlow: Color(0xFFFFE082),
              revealButtonGlow: Color(0xFFD4AF37),
              shuffleButtonGlow: Color(0xFF4FC3F7),
              wordIconColors: _wordIconPaletteLuxury,
              chaseLight: Color(0xFFFFF8E1),
            ),
        AppThemePreset.oceanEscape => const GameScreenSpec(
              panelFill: Color(0xD6002B49),
              gridFill: Color(0xE0002B49),
              wordListBorderLights: [
                Color(0xFF26C6DA),
                Color(0xFF4DD0E1),
                Color(0xFF00ACC1),
                Color(0xFF80DEEA),
              ],
              gridBorderLights: [
                Color(0xFF00BCD4),
                Color(0xFF26C6DA),
                Color(0xFF4DD0E1),
                Color(0xFF00838F),
              ],
              hintButtonGlow: Color(0xFF4DD0E1),
              revealButtonGlow: Color(0xFFFFD700),
              shuffleButtonGlow: Color(0xFF26C6DA),
              wordIconColors: _wordIconPaletteOcean,
              chaseLight: Color(0xFFE0F7FA),
            ),
      };
}

/// Icons cycled for words in the word-list panel.
const gameWordIcons = [
  Icons.emoji_events_rounded,
  Icons.people_rounded,
  Icons.star_rounded,
  Icons.psychology_rounded,
  Icons.replay_rounded,
  Icons.bolt_rounded,
  Icons.favorite_rounded,
  Icons.flag_rounded,
];
