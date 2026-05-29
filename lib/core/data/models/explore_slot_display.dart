import 'package:word_game/core/theme/app_theme_preset.dart';

class ExploreSlotDisplay {
  const ExploreSlotDisplay({
    required this.slotId,
    required this.name,
    required this.country,
    required this.backgroundImage,
    required this.imageSlug,
    required this.unlockOrder,
    required this.preset,
  });

  final int slotId;
  final String name;
  final String country;
  final String backgroundImage;
  final String imageSlug;
  final int unlockOrder;
  final AppThemePreset preset;

  factory ExploreSlotDisplay.fromJson(
    Map<String, dynamic> json,
    AppThemePreset preset,
  ) {
    return ExploreSlotDisplay(
      slotId: json['slotId'] as int,
      name: json['name'] as String,
      country: json['country'] as String? ?? '',
      backgroundImage: json['backgroundImage'] as String? ?? '',
      imageSlug: json['imageSlug'] as String? ?? '',
      unlockOrder: json['unlockOrder'] as int? ?? json['slotId'] as int,
      preset: preset,
    );
  }
}
