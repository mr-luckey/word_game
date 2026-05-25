import 'package:word_game/core/theme/app_theme_preset.dart';

/// Static catalog of destinations across 7 visual themes.
/// IDs 1–5 match [levels_pack_*.json] category ids for playable packs.
class DestinationCatalog {
  DestinationCatalog._();

  static const all = <DestinationSpec>[
    // Classic Travel (playable + locked)
    DestinationSpec(
      id: 1,
      name: 'Paris Adventure',
      country: 'France',
      preset: AppThemePreset.worldTour,
      imageSlug: 'paris.webp',
      unlockOrder: 1,
      hasLevels: true,
    ),
    DestinationSpec(
      id: 101,
      name: 'London Heritage',
      country: 'United Kingdom',
      preset: AppThemePreset.worldTour,
      imageSlug: 'london.webp',
      unlockOrder: 2,
      hasLevels: true,
    ),
    DestinationSpec(
      id: 4,
      name: 'Roman Quest',
      country: 'Italy',
      preset: AppThemePreset.worldTour,
      imageSlug: 'rome.webp',
      unlockOrder: 3,
      hasLevels: true,
    ),
    // Forest Quest
    DestinationSpec(
      id: 104,
      name: 'Amazon Quest',
      country: 'Brazil',
      preset: AppThemePreset.forestQuest,
      imageSlug: 'amazon.webp',
      unlockOrder: 1,
      hasLevels: true,
    ),
    DestinationSpec(
      id: 105,
      name: 'Redwood Trails',
      country: 'USA',
      preset: AppThemePreset.forestQuest,
      imageSlug: 'redwood.webp',
      unlockOrder: 2,
      hasLevels: true,
    ),
    DestinationSpec(
      id: 106,
      name: 'Alpine Forest',
      country: 'Switzerland',
      preset: AppThemePreset.forestQuest,
      imageSlug: 'alpine.webp',
      unlockOrder: 3,
      hasLevels: true,
    ),
    // Neon City
    DestinationSpec(
      id: 2,
      name: 'Tokyo Nights',
      country: 'Japan',
      preset: AppThemePreset.neonCity,
      imageSlug: 'tokyo_nights.webp',
      unlockOrder: 1,
      hasLevels: true,
    ),
    DestinationSpec(
      id: 107,
      name: 'Seoul Pulse',
      country: 'South Korea',
      preset: AppThemePreset.neonCity,
      imageSlug: 'seoul_pulse.webp',
      unlockOrder: 2,
      hasLevels: true,
    ),
    DestinationSpec(
      id: 3,
      name: 'New York Neon',
      country: 'USA',
      preset: AppThemePreset.neonCity,
      imageSlug: 'nyc_neon.webp',
      unlockOrder: 3,
      hasLevels: true,
    ),
    // Sunset Safari
    DestinationSpec(
      id: 110,
      name: 'Safari Adventure',
      country: 'Africa',
      preset: AppThemePreset.sunsetSafari,
      imageSlug: 'safari.webp',
      unlockOrder: 1,
      hasLevels: true,
    ),
    DestinationSpec(
      id: 111,
      name: 'Cairo Dunes',
      country: 'Egypt',
      preset: AppThemePreset.sunsetSafari,
      imageSlug: 'cairo.webp',
      unlockOrder: 2,
      hasLevels: true,
    ),
    DestinationSpec(
      id: 112,
      name: 'Marrakech Escape',
      country: 'Morocco',
      preset: AppThemePreset.sunsetSafari,
      imageSlug: 'marrakech.webp',
      unlockOrder: 3,
      hasLevels: true,
    ),
    // Winter Alps
    DestinationSpec(
      id: 113,
      name: 'Swiss Alps',
      country: 'Switzerland',
      preset: AppThemePreset.winterAlps,
      imageSlug: 'swiss.webp',
      unlockOrder: 1,
      hasLevels: true,
    ),
    DestinationSpec(
      id: 114,
      name: 'Iceland Quest',
      country: 'Iceland',
      preset: AppThemePreset.winterAlps,
      imageSlug: 'iceland.webp',
      unlockOrder: 2,
      hasLevels: true,
    ),
    DestinationSpec(
      id: 115,
      name: 'Aurora Escape',
      country: 'Norway',
      preset: AppThemePreset.winterAlps,
      imageSlug: 'aurora.webp',
      unlockOrder: 3,
      hasLevels: true,
    ),
    // Dark Luxury
    DestinationSpec(
      id: 116,
      name: 'Dubai Luxury',
      country: 'UAE',
      preset: AppThemePreset.darkLuxury,
      imageSlug: 'dubai.webp',
      unlockOrder: 1,
      hasLevels: true,
    ),
    DestinationSpec(
      id: 117,
      name: 'Monaco Nights',
      country: 'Monaco',
      preset: AppThemePreset.darkLuxury,
      imageSlug: 'monaco.webp',
      unlockOrder: 2,
      hasLevels: true,
    ),
    DestinationSpec(
      id: 118,
      name: 'Milan Prestige',
      country: 'Italy',
      preset: AppThemePreset.darkLuxury,
      imageSlug: 'milan.webp',
      unlockOrder: 3,
      hasLevels: true,
    ),
    // Ocean Escape
    DestinationSpec(
      id: 5,
      name: 'Maldives Escape',
      country: 'Maldives',
      preset: AppThemePreset.oceanEscape,
      imageSlug: 'maldives.webp',
      unlockOrder: 1,
      hasLevels: true,
    ),
    DestinationSpec(
      id: 119,
      name: 'Santorini Coast',
      country: 'Greece',
      preset: AppThemePreset.oceanEscape,
      imageSlug: 'santorini.webp',
      unlockOrder: 2,
      hasLevels: true,
    ),
    DestinationSpec(
      id: 120,
      name: 'Bali Waves',
      country: 'Indonesia',
      preset: AppThemePreset.oceanEscape,
      imageSlug: 'bali.webp',
      unlockOrder: 3,
      hasLevels: true,
    ),
  ];

  static DestinationSpec? byId(int id) {
    for (final d in all) {
      if (d.id == id) return d;
    }
    return null;
  }

  static List<DestinationSpec> forPreset(AppThemePreset preset) =>
      all.where((d) => d.preset == preset).toList()
        ..sort((a, b) => a.unlockOrder.compareTo(b.unlockOrder));

  static AppThemePreset presetForDestinationId(int id) =>
      byId(id)?.preset ?? AppThemePreset.worldTour;
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
