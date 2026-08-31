import 'package:flutter/material.dart';
import 'package:word_game/core/theme/theme_context.dart';
import 'package:word_game/features/level_select/presentation/widgets/level_map_layout.dart';
import 'package:word_game/features/level_select/presentation/widgets/level_map_active_marker.dart';
import 'package:word_game/features/level_select/presentation/widgets/level_map_node.dart';
import 'package:word_game/features/level_select/presentation/widgets/level_map_difficulty_banner.dart';
import 'package:word_game/features/level_select/presentation/widgets/level_map_path_painter.dart';
import 'package:word_game/features/level_select/presentation/widgets/level_map_sections.dart';

class LevelMapEntry {
  const LevelMapEntry({
    required this.levelNumber,
    required this.stars,
    required this.locked,
    required this.isActive,
    required this.isCompleted,
    this.onTap,
  });

  final int levelNumber;
  final int stars;
  final bool locked;
  final bool isActive;
  final bool isCompleted;
  final VoidCallback? onTap;
}

/// Scrollable Candy Crush–style level map — path grows as you progress.
class LevelMapView extends StatefulWidget {
  const LevelMapView({
    super.key,
    required this.levels,
    required this.activeIndex,
    required this.progressThroughIndex,
    this.sections = const [],
  });

  final List<LevelMapEntry> levels;
  final int activeIndex;
  final int progressThroughIndex;
  final List<LevelMapSection> sections;

  @override
  State<LevelMapView> createState() => _LevelMapViewState();
}

class _LevelMapViewState extends State<LevelMapView> {
  final ScrollController _scrollController = ScrollController();
  int _lastScrolledTo = -1;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(LevelMapView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.activeIndex != widget.activeIndex ||
        oldWidget.progressThroughIndex != widget.progressThroughIndex ||
        oldWidget.levels.length != widget.levels.length) {
      _lastScrolledTo = -1;
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToActive());
    }
  }

  void _scrollToActive({bool animate = true}) {
    if (!_scrollController.hasClients || widget.levels.isEmpty) return;
    final maxIdx = widget.levels.length - 1;
    final idx = widget.activeIndex < 0
        ? 0
        : widget.activeIndex > maxIdx
            ? maxIdx
            : widget.activeIndex;
    if (_lastScrolledTo == idx && animate) return;

    final viewport = _scrollController.position.viewportDimension;
    final layout = _layoutForWidth(
      MediaQuery.sizeOf(context).width - 16,
    );
    final offset = layout.scrollOffsetToCenterNode(
      nodeIndex: idx,
      viewportHeight: viewport,
    );

    _lastScrolledTo = idx;
    if (animate) {
      _scrollController.animateTo(
        offset,
        duration: const Duration(milliseconds: 550),
        curve: Curves.easeOutCubic,
      );
    } else {
      _scrollController.jumpTo(offset);
    }
  }

  LevelMapLayout _layoutForWidth(double width) {
    final count = widget.levels.length;
    final spacing = count > 30
        ? (width < 340 ? 82.0 : 90.0)
        : count > 20
            ? (width < 340 ? 90.0 : 98.0)
            : (width < 340 ? 96.0 : 108.0);
    return LevelMapLayout(
      count: count,
      mapWidth: width,
      nodeSpacing: spacing,
    );
  }

  int _safeIndex(int index, int length) {
    if (length <= 0) return 0;
    if (index < 0) return 0;
    if (index >= length) return length - 1;
    return index;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final spec = context.themePreset.homeSpec;
    final pathUnlocked = context.themePreset.useNeonGlow
        ? spec.journeyWordColor
        : colors.primary;

    if (widget.levels.isEmpty) {
      return Center(
        child: Text(
          'No levels in this pack yet',
          style: TextStyle(color: colors.onScenicMuted),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final mapWidth = constraints.maxWidth;
        final layout = _layoutForWidth(mapWidth);
        final centers = layout.nodeCenters();
        final mapHeight = layout.mapHeight;
        final nodeSize = mapWidth < 340 ? 52.0 : 58.0;
        final progressIdx = _safeIndex(
          widget.progressThroughIndex,
          widget.levels.length,
        );

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_lastScrolledTo < 0) _scrollToActive(animate: false);
        });

        return Stack(
          children: [
            Scrollbar(
              controller: _scrollController,
              thumbVisibility: true,
              child: SingleChildScrollView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                child: SizedBox(
                  width: mapWidth,
                  height: mapHeight,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      CustomPaint(
                        size: Size(mapWidth, mapHeight),
                        painter: LevelMapPathPainter(
                          points: centers,
                          unlockedThroughIndex: progressIdx,
                          unlockedColor: pathUnlocked,
                          lockedColor: colors.onScenicMuted,
                          glowColor: spec.playButtonGlow,
                          strokeWidth:
                              context.themePreset.useNeonGlow ? 4 : 5,
                        ),
                      ),
                      ...widget.sections.map((section) {
                        final i = section.nodeIndex;
                        if (i < 0 || i >= centers.length) {
                          return const SizedBox.shrink();
                        }
                        final c = centers[i];
                        final bannerW = mapWidth * 0.52;
                        return Positioned(
                          left: ((mapWidth - bannerW) / 2).clamp(8.0, mapWidth - bannerW - 8),
                          top: (c.dy - nodeSize - 52).clamp(4.0, mapHeight - 40),
                          width: bannerW,
                          child: Center(
                            child: LevelMapDifficultyBanner(
                              label: section.label,
                              color: sectionColor(colors, section.difficultyIndex),
                            ),
                          ),
                        );
                      }),
                      ...List.generate(widget.levels.length, (i) {
                        final entry = widget.levels[i];
                        final c = centers[i];
                        if (entry.isActive) {
                          final outer = nodeSize + 28;
                          const playBlockHeight = 22.0;
                          const playGap = 8.0;
                          final circleCenterFromTop =
                              playBlockHeight + playGap + outer / 2;
                          final markerW = outer + 20;
                          final markerH = circleCenterFromTop + outer / 2;
                          return Positioned(
                            left: (c.dx - markerW / 2)
                                .clamp(0.0, mapWidth - markerW),
                            top: (c.dy - circleCenterFromTop)
                                .clamp(0.0, mapHeight - markerH),
                            child: LevelMapActiveMarker(
                              levelNumber: entry.levelNumber,
                              stars: entry.stars,
                              onTap: entry.onTap,
                              size: nodeSize,
                            ),
                          );
                        }
                        final half = nodeSize / 2;
                        return Positioned(
                          left: (c.dx - half).clamp(0.0, mapWidth - nodeSize - 8),
                          top: (c.dy - half - 8)
                              .clamp(0.0, mapHeight - nodeSize - 24),
                          child: LevelMapNode(
                            levelNumber: entry.levelNumber,
                            stars: entry.stars,
                            locked: entry.locked,
                            isActive: false,
                            isCompleted: entry.isCompleted,
                            onTap: entry.onTap,
                            size: nodeSize,
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              right: 8,
              bottom: 12,
              child: _ScrollHint(colors: colors),
            ),
          ],
        );
      },
    );
  }
}

class _ScrollHint extends StatelessWidget {
  const _ScrollHint({required this.colors});

  final dynamic colors;

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.swipe_vertical_rounded,
      color: colors.onScenicMuted.withValues(alpha: 0.5),
      size: 20,
    );
  }
}
