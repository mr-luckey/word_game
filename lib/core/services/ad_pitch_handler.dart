import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:word_game/core/navigation/app_navigator.dart';
import 'package:word_game/core/services/ad_service.dart';
import 'package:word_game/core/widgets/ads/remove_ads_pitch_dialog.dart';
import 'package:word_game/injection.dart';

/// Shows the Remove Ads pitch after interstitial/rewarded ads close.
class AdPitchHandler {
  AdPitchHandler(this._ads, this._prefs);

  final AdService _ads;
  final SharedPreferences _prefs;

  static const _lastPitchKey = 'last_remove_ads_pitch_ms';
  static const _pitchCooldown = Duration(minutes: 3);

  void install() {
    _ads.addOnFullScreenAdDismissed(_onFullScreenAdDismissed);
  }

  void _onFullScreenAdDismissed(FullScreenAdKind kind) {
    if (_ads.adsRemoved) return;

    final lastMs = _prefs.getInt(_lastPitchKey);
    if (lastMs != null) {
      final last = DateTime.fromMillisecondsSinceEpoch(lastMs);
      if (DateTime.now().difference(last) < _pitchCooldown) return;
    }

    unawaited(_prefs.setInt(_lastPitchKey, DateTime.now().millisecondsSinceEpoch));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctx = rootNavigatorKey.currentContext;
      if (ctx == null || !ctx.mounted) return;
      if (_ads.adsRemoved) return;
      unawaited(showRemoveAdsPitchDialog(ctx));
    });
  }
}

void installAdPitchHandler() {
  AdPitchHandler(getIt<AdService>(), getIt<SharedPreferences>()).install();
}
