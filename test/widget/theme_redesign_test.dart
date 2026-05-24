import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:word_game/core/constants/asset_paths.dart';
import 'package:word_game/core/theme/destination_catalog.dart';
import 'package:word_game/core/theme/app_theme.dart';
import 'package:word_game/core/theme/theme_context.dart';
import 'package:word_game/core/widgets/journey_bottom_nav.dart';

void main() {
  testWidgets('bottom nav shows all tabs and reports selected taps',
      (tester) async {
    var selected = -1;

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.build(preset: AppThemePreset.neonCity),
        home: Scaffold(
          bottomNavigationBar: JourneyBottomNav(
            selectedIndex: 2,
            onSelected: (index) => selected = index,
          ),
        ),
      ),
    );

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Explore'), findsOneWidget);
    expect(find.text('Shop'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);

    await tester.tap(find.text('Profile'));
    expect(selected, 3);
  });

  testWidgets('all seven presets expose theme marker and splash assets',
      (tester) async {
    for (final preset in AppThemePreset.values) {
      await tester.pumpWidget(
        MaterialApp(
          key: ValueKey(preset),
          theme: AppTheme.build(preset: preset),
          home: Builder(
            builder: (context) {
              expect(context.themePreset, preset);
              expect(File(AssetPaths.themeSplash(preset)).existsSync(), isTrue);
              expect(File(AssetPaths.themeGrid(preset)).existsSync(), isTrue);
              return const SizedBox.shrink();
            },
          ),
        ),
      );
    }
  });

  test('each preset has a playable first destination in level packs', () {
    final categories = <int, Map<String, dynamic>>{};
    for (final file in Directory('assets/data')
        .listSync()
        .whereType<File>()
        .where((file) => file.path.contains('levels_pack_'))) {
      final data = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
      for (final category in data['categories'] as List<dynamic>) {
        final map = category as Map<String, dynamic>;
        categories[map['id'] as int] = map;
      }
    }

    for (final preset in AppThemePreset.values) {
      final featured = DestinationCatalog.forPreset(preset)
          .where((destination) => destination.unlockOrder == 1)
          .single;
      expect(categories[featured.id], isNotNull, reason: preset.label);
      expect(
        File(featured.imageAsset).existsSync(),
        isTrue,
        reason: featured.name,
      );
    }
  });
}
