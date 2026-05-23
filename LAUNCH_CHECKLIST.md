# Word Search Journey — Launch Checklist

## AdMob (production)

Replace test unit IDs in [`lib/core/constants/ad_unit_ids.dart`](lib/core/constants/ad_unit_ids.dart):

- Interstitial, rewarded, banner ad units
- Android `APPLICATION_ID` in [`android/app/src/main/AndroidManifest.xml`](android/app/src/main/AndroidManifest.xml)
- iOS `Info.plist` GADApplicationIdentifier when shipping iOS

Current dev IDs are Google official test placements.

## Firebase

1. Run `flutterfire configure` and add `firebase_options.dart`
2. Enable Crashlytics + Analytics in Firebase console
3. Trigger a test crash before release

## Google Play

- App icon 512×512 + adaptive icon
- Feature graphic 1024×500
- 8–12 phone screenshots (1080×1920)
- Short description (80 chars): "Explore the world through words — offline puzzle game!"
- Privacy policy URL (required for ads)
- Signed release AAB with upload keystore (never commit keystore)
- Create 6 IAP products matching `shop_cubit.dart` product IDs

## QA

- [ ] Airplane mode: play levels from bundled JSON
- [ ] All 100 levels load
- [ ] Interstitial only every 3rd level complete
- [ ] Rotate board remains free
- [ ] Low-end device 60fps target

## Store listing keywords

word search, word puzzle, word find, brain game, offline puzzle
