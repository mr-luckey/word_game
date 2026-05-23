# Game assets

Regenerate or refresh media with:

```bash
python tool/generate_assets.py
```

## Layout

| Folder | Files |
|--------|--------|
| `images/splash/` | `travel_bg.jpg` — splash background |
| `images/themes/` | `paris_bg.jpg`, `tokyo_bg.jpg`, `nyc_bg.jpg`, `rome_bg.jpg`, `sydney_bg.jpg` |
| `animations/` | `word_logo.json`, `confetti.json`, `star_burst.json`, `word_found.json` (Lottie) |
| `audio/` | `word_found.wav`, `level_complete.wav`, `wrong.wav`, `bg_music.wav` |
| `data/` | Level packs + dictionary JSON |

Audio is synthesized WAV (royalty-free). Images are from Unsplash (splash/themes) where download succeeds. Lottie files are from LottieFiles public packages.

Replace any file with your own branded assets; paths are centralized in `lib/core/constants/asset_paths.dart`.
