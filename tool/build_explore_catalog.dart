// ignore_for_file: avoid_print
import 'dart:convert';
import 'dart:io';

/// Regenerates explore_catalog.json using only images that exist on disk.
void main() {
  final root = Directory.current;
  final dataDir = Directory('${root.path}/assets/data');
  final themesDir = Directory('${root.path}/assets/images/themes');

  const themeFolders = [
    'classic_travel',
    'forest_quest',
    'neon_city',
    'sunset_safari',
    'winter_alps',
    'dark_luxury',
    'ocean_escape',
  ];

  const fillerNames = {
    'classic_travel': [
      'Paris Adventure',
      'London Heritage',
      'Roman Quest',
      'Barcelona Escape',
      'Amsterdam Canals',
      'Vienna Waltz',
      'Prague Old Town',
      'Athens Odyssey',
      'Edinburgh Castle',
      'Dublin Green',
    ],
    'forest_quest': [
      'Amazon Quest',
      'Redwood Trails',
      'Alpine Forest',
      'Congo Wild',
      'Bamboo Grove',
      'Rainforest Path',
      'Pine Ridge',
      'Jungle Falls',
      'Moss Valley',
      'Canopy Walk',
    ],
    'neon_city': [
      'Tokyo Nights',
      'Seoul Pulse',
      'New York Neon',
      'Hong Kong Glow',
      'Shanghai Spark',
      'Singapore Pulse',
      'Bangkok Lights',
      'Dubai Skyline',
      'Berlin Beat',
      'Las Vegas Rush',
    ],
    'sunset_safari': [
      'Safari Adventure',
      'Cairo Dunes',
      'Marrakech Escape',
      'Serengeti Dawn',
      'Kalahari Sun',
      'Victoria Falls',
      'Zanzibar Coast',
      'Namib Desert',
      'Okavango Delta',
      'Kruger Trail',
    ],
    'winter_alps': [
      'Swiss Alps',
      'Iceland Quest',
      'Aurora Escape',
      'Norwegian Fjord',
      'Lapland Snow',
      'Aspen Peak',
      'Banff Frost',
      'Chamonix Ridge',
      'Hokkaido White',
      'Patagonia Ice',
    ],
    'dark_luxury': [
      'Dubai Luxury',
      'Monaco Nights',
      'Milan Prestige',
      'Paris Noir',
      'Singapore Elite',
      'Hong Kong Jade',
      'Las Vegas VIP',
      'London Royal',
      'New York Gold',
      'Riviera Glam',
    ],
    'ocean_escape': [
      'Maldives Escape',
      'Santorini Coast',
      'Bali Waves',
      'Caribbean Blue',
      'Hawaii Reef',
      'Croatia Cove',
      'Phuket Shore',
      'Mauritius Lagoon',
      'Fiji Islands',
      'Amalfi Coast',
    ],
  };

  const fillerCountries = [
    'World Tour',
    'Adventure Zone',
    'Discovery Path',
    'Explorer Route',
    'Journey Stop',
    'Quest Point',
    'Travel Hub',
    'Voyage Bay',
    'Wander Trail',
    'Odyssey Land',
  ];

  /// Destination + grid images per theme (must exist under assets/images/themes/<folder>/).
  final themeImages = <String, List<String>>{};
  for (final folder in themeFolders) {
    final dir = Directory('${themesDir.path}/$folder');
    if (!dir.existsSync()) {
      print('WARN: missing theme folder $folder');
      themeImages[folder] = ['grid_full.webp'];
      continue;
    }
    final files = dir
        .listSync()
        .whereType<File>()
        .where((f) => f.path.endsWith('.webp'))
        .map((f) => f.uri.pathSegments.last)
        .toList()
      ..sort();

    // Prefer destination art first, then grid for variety on extra slots.
    final destinations =
        files.where((f) => f != 'grid_full.webp' && f != 'splash.webp').toList();
    final pool = <String>[
      ...destinations,
      if (files.contains('grid_full.webp')) 'grid_full.webp',
    ];
    themeImages[folder] = pool.isEmpty ? ['grid_full.webp'] : pool;
    print('$folder: ${pool.join(', ')}');
  }

  final themes = <String, List<Map<String, dynamic>>>{};
  for (final folder in themeFolders) {
    final images = themeImages[folder]!;
    final names = fillerNames[folder]!;
    final slots = <Map<String, dynamic>>[];

    for (var i = 0; i < 10; i++) {
      final slot = i + 1;
      final slug = _imageForSlot(names[i], images, i);
      slots.add({
        'slotId': slot,
        'name': names[i],
        'country': fillerCountries[i],
        'backgroundImage': '$folder/$slug',
        'imageSlug': slug,
        'unlockOrder': slot,
      });
    }
    themes[folder] = slots;
  }

  File('${dataDir.path}/explore_catalog.json').writeAsStringSync(
    const JsonEncoder.withIndent('  ').convert({
      'version': '3.0',
      'description':
          'Explore list per visual theme — names/images only; levels from slot_1.json ... slot_10.json.',
      'slotCount': 10,
      'themes': themes,
    }),
  );
  print('Updated explore_catalog.json');
}

/// Prefer a destination image whose slug matches the slot name (e.g. Paris → paris.webp).
String _imageForSlot(String name, List<String> images, int fallbackIndex) {
  final tokens = name
      .toLowerCase()
      .split(RegExp(r'[^a-z]+'))
      .where((t) => t.length >= 3);
  for (final token in tokens) {
    for (final image in images) {
      if (image.toLowerCase().contains(token)) return image;
    }
  }
  return images[fallbackIndex % images.length];
}
