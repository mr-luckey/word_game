import 'package:word_game/core/data/game_content_registry.dart';
import 'package:word_game/core/theme/app_theme_bloc.dart';
import 'package:word_game/core/theme/app_theme_preset.dart';
import 'package:word_game/injection.dart';

/// Explore destinations — themed names from JSON, shared level content.
class DestinationCatalog {
  DestinationCatalog._();

  static GameContentRegistry? _registry;

  static void bind(GameContentRegistry registry) => _registry = registry;

  static GameContentRegistry get _r {
    _ensureLoaded();
    return _registry!;
  }

  /// All explore slots for the active visual theme (default: current app theme).
  static List<DestinationSpec> forPreset(AppThemePreset preset) =>
      _r.destinationsForPreset(preset);

  static DestinationSpec? byId(int slotId, [AppThemePreset? preset]) {
    final p = preset ?? getIt<AppThemeBloc>().state.activePreset;
    return _r.destinationForSlot(p, slotId);
  }

  static AppThemePreset presetForDestinationId(int id) {
    return getIt<AppThemeBloc>().state.activePreset;
  }

  static void _ensureLoaded() {
    if (_registry == null) {
      throw StateError(
        'Game content not loaded. Call GameContentLoader.load() at startup.',
      );
    }
  }
}

class DestinationSpec {
  const DestinationSpec({
    required this.id,
    required this.name,
    required this.country,
    required this.preset,
    required this.imageSlug,
    required this.unlockOrder,
    required this.hasLevels,
  });

  final int id;
  final String name;
  final String country;
  final AppThemePreset preset;
  final String imageSlug;
  final int unlockOrder;
  final bool hasLevels;

  String get imageAsset =>
      'assets/images/themes/${preset.folder}/$imageSlug';
}
