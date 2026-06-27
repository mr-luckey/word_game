import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:word_game/core/theme/app_text_styles.dart';
import 'package:word_game/core/theme/app_theme_extension.dart';
import 'package:word_game/core/theme/theme_context.dart';
import 'package:word_game/features/game/presentation/bloc/game_state.dart';

enum _TutorialStep { intro, demo, practice }

/// First-level guided tutorial: intro → hand demo on grid → user tries.
class LevelTutorialOverlay extends StatefulWidget {
  const LevelTutorialOverlay({
    super.key,
    required this.state,
    required this.gridKey,
    required this.onDismiss,
  });

  final GameInProgress state;
  final GlobalKey gridKey;
  final VoidCallback onDismiss;

  @override
  State<LevelTutorialOverlay> createState() => _LevelTutorialOverlayState();
}

class _LevelTutorialOverlayState extends State<LevelTutorialOverlay>
    with SingleTickerProviderStateMixin {
  _TutorialStep _step = _TutorialStep.intro;
  late final AnimationController _handController;
  List<Offset> _pathCenters = [];
  Rect? _gridRect;
  double _cellSize = 0;

  @override
  void initState() {
    super.initState();
    _handController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed && mounted) {
          _handController.forward(from: 0);
        }
      });
    SchedulerBinding.instance.addPostFrameCallback((_) => _updateGeometry());
  }

  @override
  void didUpdateWidget(LevelTutorialOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.gridKey != widget.gridKey ||
        oldWidget.state.tutorialPathCells != widget.state.tutorialPathCells) {
      SchedulerBinding.instance.addPostFrameCallback((_) => _updateGeometry());
    }
    if (_step == _TutorialStep.demo && !_handController.isAnimating) {
      _handController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _handController.dispose();
    super.dispose();
  }

  void _updateGeometry() {
    if (!mounted) return;
    final gridBox =
        widget.gridKey.currentContext?.findRenderObject() as RenderBox?;
    final overlayBox = context.findRenderObject() as RenderBox?;
    if (gridBox == null || overlayBox == null || !gridBox.hasSize) return;

    final n = widget.state.grid.length;
    if (n == 0) return;

    final gridTopLeft = overlayBox.globalToLocal(gridBox.localToGlobal(Offset.zero));
    final cellSize = gridBox.size.width / n;
    final path = widget.state.tutorialPathCells;

    setState(() {
      _gridRect = gridTopLeft & gridBox.size;
      _cellSize = cellSize;
      _pathCenters = path
          .map(
            (cell) => gridTopLeft +
                Offset(
                  cell.col * cellSize + cellSize / 2,
                  cell.row * cellSize + cellSize / 2,
                ),
          )
          .toList();
    });
  }

  void _goToDemo() {
    setState(() => _step = _TutorialStep.demo);
    _handController.forward(from: 0);
  }

  void _goToPractice() {
    setState(() => _step = _TutorialStep.practice);
    _handController.stop();
  }

  Offset _handPosition(double t) {
    if (_pathCenters.length < 2) {
      return _pathCenters.isEmpty ? Offset.zero : _pathCenters.first;
    }
    final segments = _pathCenters.length - 1;
    final scaled = t * segments;
    final index = scaled.floor().clamp(0, segments - 1);
    final localT = scaled - index;
    return Offset.lerp(_pathCenters[index], _pathCenters[index + 1], localT)!;
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.state.showTutorial || widget.state.wordsToFind.isEmpty) {
      return const SizedBox.shrink();
    }

    final colors = context.appColors;
    final firstWord = widget.state.wordsToFind.first.text;
    final blockInput = _step != _TutorialStep.practice;

    return Positioned.fill(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          if (blockInput)
            ModalBarrier(
              color: colors.scrim.withValues(alpha: 0.68),
              dismissible: false,
            ),
          if (_step == _TutorialStep.practice)
            Positioned.fill(
              child: IgnorePointer(
                child: ColoredBox(
                  color: colors.scrim.withValues(alpha: 0.18),
                ),
              ),
            ),
          if (_gridRect != null && _step != _TutorialStep.intro)
            ..._buildCellHighlights(colors),
          if (_step == _TutorialStep.demo && _pathCenters.length >= 2)
            AnimatedBuilder(
              animation: _handController,
              builder: (context, child) {
                final pos = _handPosition(_handController.value);
                return Positioned(
                  left: pos.dx - 18,
                  top: pos.dy - 10,
                  child: child!,
                );
              },
              child: Transform.rotate(
                angle: -0.35,
                child: Icon(
                  Icons.back_hand_rounded,
                  size: 44,
                  color: colors.gold,
                  shadows: [
                    Shadow(
                      color: colors.scrim.withValues(alpha: 0.8),
                      blurRadius: 8,
                    ),
                  ],
                ),
              ),
            ),
          if (_step == _TutorialStep.practice && _pathCenters.isNotEmpty)
            Positioned(
              left: _pathCenters.first.dx - 22,
              top: _pathCenters.first.dy - 22,
              child: IgnorePointer(
                child: _PulseRing(color: colors.gold),
              ),
            ),
          Align(
            alignment: Alignment.topCenter,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                child: _TutorialCard(
                  title: switch (_step) {
                    _TutorialStep.intro => 'Welcome!',
                    _TutorialStep.demo => 'Watch this',
                    _TutorialStep.practice => 'Your turn!',
                  },
                  message: switch (_step) {
                    _TutorialStep.intro =>
                      'Swipe connected letters on the board to find hidden words.',
                    _TutorialStep.demo =>
                      'Drag your finger across the letters to spell "$firstWord".',
                    _TutorialStep.practice =>
                      'Now swipe on the board to find "$firstWord".',
                  },
                  word: firstWord,
                  colors: colors,
                  primaryLabel: switch (_step) {
                    _TutorialStep.intro => 'Show me',
                    _TutorialStep.demo => 'Got it',
                    _TutorialStep.practice => 'Skip',
                  },
                  onPrimary: switch (_step) {
                    _TutorialStep.intro => _goToDemo,
                    _TutorialStep.demo => _goToPractice,
                    _TutorialStep.practice => widget.onDismiss,
                  },
                  onSkip: widget.onDismiss,
                  showSkip: _step != _TutorialStep.practice,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildCellHighlights(AppThemeColors colors) {
    final rect = _gridRect!;
    final wordIndex = 0;
    final accent = colors.foundColorForIndex(wordIndex);

    return widget.state.tutorialPathCells.map((cell) {
      final left = rect.left + cell.col * _cellSize;
      final top = rect.top + cell.row * _cellSize;
      return Positioned(
        left: left,
        top: top,
        width: _cellSize,
        height: _cellSize,
        child: IgnorePointer(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: accent.withValues(alpha: _step == _TutorialStep.demo ? 0.35 : 0.22),
              border: Border.all(
                color: accent.withValues(alpha: 0.85),
                width: 2,
              ),
            ),
          ),
        ),
      );
    }).toList();
  }
}

class _TutorialCard extends StatelessWidget {
  const _TutorialCard({
    required this.title,
    required this.message,
    required this.word,
    required this.colors,
    required this.primaryLabel,
    required this.onPrimary,
    required this.onSkip,
    required this.showSkip,
  });

  final String title;
  final String message;
  final String word;
  final AppThemeColors colors;
  final String primaryLabel;
  final VoidCallback onPrimary;
  final VoidCallback onSkip;
  final bool showSkip;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(18, 16, 18, 14),
        decoration: BoxDecoration(
          color: colors.surface.withValues(alpha: 0.96),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: colors.gold.withValues(alpha: 0.55)),
          boxShadow: [
            BoxShadow(
              color: colors.shadow.withValues(alpha: 0.35),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: AppTextStyles.sectionHeading(context).copyWith(
                color: colors.onSurface,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.subtitle(context).copyWith(
                color: colors.onSurface.withValues(alpha: 0.85),
                fontSize: 14,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              word,
              style: AppTextStyles.levelName(context).copyWith(
                color: colors.foundColorForIndex(0),
                fontSize: 22,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                if (showSkip)
                  TextButton(
                    onPressed: onSkip,
                    child: Text(
                      'Skip',
                      style: TextStyle(color: colors.onSurface.withValues(alpha: 0.6)),
                    ),
                  )
                else
                  const Spacer(),
                const Spacer(),
                FilledButton(
                  onPressed: onPrimary,
                  style: FilledButton.styleFrom(
                    backgroundColor: colors.gold,
                    foregroundColor: colors.onPrimary,
                    padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    primaryLabel,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PulseRing extends StatefulWidget {
  const _PulseRing({required this.color});

  final Color color;

  @override
  State<_PulseRing> createState() => _PulseRingState();
}

class _PulseRingState extends State<_PulseRing>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = _controller.value;
        final size = 44 + t * 18;
        final opacity = (1 - t).clamp(0.0, 1.0);
        return SizedBox(
          width: size,
          height: size,
          child: DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: widget.color.withValues(alpha: 0.7 * opacity),
                width: 2.5,
              ),
            ),
          ),
        );
      },
    );
  }
}
