import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

/// Tracks eligibility and opens Play Store for in-app rating prompts.
class AppRatingService {
  AppRatingService(this._prefs);

  static const playStoreId = 'com.appwaretech.WordGlow';

  static const _ratedKey = 'app_rating_done';
  static const _declinedAtKey = 'app_rating_declined_at';
  static const _launchCountKey = 'app_launch_count';

  final SharedPreferences _prefs;
  final Random _random = Random();

  bool get hasRated => _prefs.getBool(_ratedKey) ?? false;

  Future<void> recordAppLaunch() async {
    final count = _prefs.getInt(_launchCountKey) ?? 0;
    await _prefs.setInt(_launchCountKey, count + 1);
  }

  /// Random prompt while the user is actively using the app.
  bool shouldOfferRandomPrompt({bool afterGameplay = false}) {
    if (hasRated) return false;

    final launches = _prefs.getInt(_launchCountKey) ?? 0;
    if (launches < 2) return false;

    final declinedAt = _prefs.getInt(_declinedAtKey);
    if (declinedAt != null) {
      final daysSince = DateTime.now()
          .difference(DateTime.fromMillisecondsSinceEpoch(declinedAt))
          .inDays;
      if (daysSince < 7) return false;
    }

    final chance = afterGameplay ? 0.35 : 0.2;
    return _random.nextDouble() < chance;
  }

  Future<void> markRated() => _prefs.setBool(_ratedKey, true);

  Future<void> markDeclined() async {
    await _prefs.setInt(
      _declinedAtKey,
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  Future<void> openStoreListing() async {
    final market = Uri.parse('market://details?id=$playStoreId');
    final web = Uri.parse(
      'https://play.google.com/store/apps/details?id=$playStoreId',
    );
    if (await canLaunchUrl(market)) {
      await launchUrl(market, mode: LaunchMode.externalApplication);
    } else {
      await launchUrl(web, mode: LaunchMode.externalApplication);
    }
  }
}
