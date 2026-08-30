import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:word_game/core/theme/game_screen_styles.dart';
import 'package:word_game/core/theme/theme_context.dart';
import 'package:word_game/core/widgets/moving_light_border.dart';

enum GamePanelBorderStyle { wordList, grid }

/// Dark glass panel with animated moving-light border for the game screen.
///
/// No BackdropFilter — that would blur the HD scenic photo behind the board.
class GameNeonPanel extends StatelessWidget {
  const GameNeonPanel({
    super.key,
    required this.child,
    required this.borderStyle,
    this.padding,
    this.borderRadius,
  });

  final Widget child;
  final GamePanelBorderStyle borderStyle;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    final spec = context.themePreset.gameSpec;
    final radius =
        borderRadius ?? (borderStyle == GamePanelBorderStyle.grid ? 22.0 : 18.0);
    final isGrid = borderStyle == GamePanelBorderStyle.grid;
    final lightColors =
        isGrid ? spec.gridBorderLights : spec.wordListBorderLights;
    final fill = isGrid ? spec.gridFill : spec.panelFill;
    final borderWidth = isGrid ? 3.4 : 2.6;
    final glowBlur = isGrid ? 20.0 : 12.0;
    final innerRadius = math.max(0.0, radius - borderWidth);

    return MovingLightBorder(
      lightColors: lightColors,
      borderWidth: borderWidth,
      borderRadius: radius,
      glowBlur: glowBlur,
      glowSpread: isGrid ? 2 : 1,
      duration: Duration(milliseconds: isGrid ? 2600 : 3400),
      reverse: isGrid,
      chaseColor: spec.chaseLight,
      softGlow: spec.lightAtmosphere,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(innerRadius),
        child: Container(
          width: double.infinity,
          padding: padding,
          decoration: BoxDecoration(
            color: fill,
            borderRadius: BorderRadius.circular(innerRadius),
          ),
          child: child,
        ),
      ),
    );
  }
}
