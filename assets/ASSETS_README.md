# Game assets

## Data (JSON)
| Path | Purpose |
|------|---------|
| `data/manifest.json` | Points to shared levels + explore catalog |
| `data/shared_levels.json` | One level pack — same gameplay for all explore cards |
| `data/explore_catalog.json` | 10 explore cards × 7 themes (names + images only) |
| `data/daily_challenge.json` | Daily bonus level config |
| `data/achievements.json` | Home achievement badge labels |

Regenerate explore images/names: `dart run tool/build_explore_catalog.dart`

## Images
| Path | Purpose |
|------|---------|
| `images/themes/<theme>/` | Destination `.webp`, `grid_full.webp`, `splash.webp` |
| `images/ui/` | UI icons (e.g. treasure chest) |
| `animations/` | Lottie files |
| `audio/` | Sound effects and music |
