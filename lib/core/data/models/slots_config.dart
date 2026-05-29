/// How level JSON files map to explore cards (slot numbers).
class SlotsConfig {
  const SlotsConfig({required this.slotCount});

  final int slotCount;

  factory SlotsConfig.fromJson(Map<String, dynamic> json) {
    return SlotsConfig(
      slotCount: json['slotCount'] as int? ?? 10,
    );
  }

  /// File name for this destination number, e.g. slot_1.json
  static String packFileName(int slotId) => 'slot_$slotId';
}
