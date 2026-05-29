import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:word_game/core/data/game_content_registry.dart';
import 'package:word_game/core/data/models/achievement_badge_config.dart';
import 'package:word_game/core/data/models/daily_challenge_config.dart';
import 'package:word_game/core/data/models/explore_slot_display.dart';
import 'package:word_game/core/data/models/slots_config.dart';
import 'package:word_game/core/theme/app_theme_preset.dart';
import 'package:word_game/features/game/domain/entities/level_entity.dart';

class GameContentLoader {
  GameContentLoader._();

  static Future<GameContentRegistry> load() async {
    final manifestRaw =
        await rootBundle.loadString('assets/data/manifest.json');
    final manifest = jsonDecode(manifestRaw) as Map<String, dynamic>;

    final dailyRaw = await rootBundle.loadString(
      manifest['dailyChallengeAsset'] as String,
    );
    final dailyChallenge = DailyChallengeConfig.fromJson(
      jsonDecode(dailyRaw) as Map<String, dynamic>,
    );

    final achievementsRaw = await rootBundle.loadString(
      manifest['achievementsAsset'] as String,
    );
    final achievements = AchievementsConfig.fromJson(
      jsonDecode(achievementsRaw) as Map<String, dynamic>,
    );

    final slotsRaw = await rootBundle.loadString(
      manifest['slotsConfigAsset'] as String,
    );
    final slotsConfig = SlotsConfig.fromJson(
      jsonDecode(slotsRaw) as Map<String, dynamic>,
    );

    final exploreRaw = await rootBundle.loadString(
      manifest['exploreCatalogAsset'] as String,
    );
    final exploreData = jsonDecode(exploreRaw) as Map<String, dynamic>;
    final themesRaw = exploreData['themes'] as Map<String, dynamic>;

    final exploreByPreset = <AppThemePreset, List<ExploreSlotDisplay>>{};
    for (final preset in AppThemePreset.values) {
      final list = themesRaw[preset.folder] as List<dynamic>?;
      if (list == null) continue;
      exploreByPreset[preset] = list
          .map(
            (e) => ExploreSlotDisplay.fromJson(
              e as Map<String, dynamic>,
              preset,
            ),
          )
          .toList()
        ..sort((a, b) => a.unlockOrder.compareTo(b.unlockOrder));
    }

    final levelPacks = <int, List<LevelJson>>{};
    for (var slotId = 1; slotId <= slotsConfig.slotCount; slotId++) {
      final fileName = SlotsConfig.packFileName(slotId);
      final packRaw = await rootBundle.loadString(
        'assets/data/level_packs/$fileName.json',
      );
      final packData = jsonDecode(packRaw) as Map<String, dynamic>;
      levelPacks[slotId] = (packData['levels'] as List<dynamic>)
          .map((l) => LevelJson.fromJson(l as Map<String, dynamic>))
          .toList();
    }

    return GameContentRegistry(
      exploreByPreset: exploreByPreset,
      dailyChallenge: dailyChallenge,
      achievements: achievements,
      slotsConfig: slotsConfig,
      levelPacksBySlot: levelPacks,
    );
  }
}
