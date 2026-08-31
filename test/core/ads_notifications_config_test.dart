import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:word_game/core/config/ads_config.dart';
import 'package:word_game/core/config/notification_config.dart';
import 'package:word_game/core/services/network_guard.dart';

void main() {
  group('AdsConfig placements', () {
    const config = AdsConfig(
      testMode: false,
      bannerAdUnits: [
        'ca-app-pub-1111111111111111/banner0',
        'ca-app-pub-1111111111111111/banner1',
        '',
      ],
      interstitialAdUnits: [
        'ca-app-pub-1111111111111111/int0',
        'ca-app-pub-1111111111111111/int1',
      ],
      rewardedAdUnits: [
        'ca-app-pub-1111111111111111/rew0',
      ],
      bannerPlacements: {
        'level_select': 0,
        'game': 1,
        'result': 2,
        'missing': 9,
      },
      interstitialPlacements: {
        'after_level_group': 0,
        'after_session': 1,
      },
      rewardedPlacements: {
        'extra_coins': 0,
        'unknown': 1,
      },
      minimumInterstitialInterval: Duration(minutes: 2),
      maxRetries: 2,
      retryBackoff: Duration(seconds: 30),
    );

    test('maps each placement to a single unit id', () {
      expect(
        config.bannerUnitId('level_select'),
        'ca-app-pub-1111111111111111/banner0',
      );
      expect(
        config.bannerUnitId('game'),
        'ca-app-pub-1111111111111111/banner1',
      );
      expect(
        config.interstitialUnitId('after_session'),
        'ca-app-pub-1111111111111111/int1',
      );
    });

    test('empty or out-of-range placement is disabled', () {
      expect(config.bannerUnitId('result'), isNull);
      expect(config.bannerUnitId('missing'), isNull);
      expect(config.bannerUnitId('nope'), isNull);
      expect(config.rewardedUnitId('unknown'), isNull);
    });

    test('testMode uses Google sample units only', () {
      const testConfig = AdsConfig(
        testMode: true,
        bannerAdUnits: ['ca-app-pub-1111111111111111/prod'],
        bannerPlacements: {'game': 0},
      );
      expect(
        testConfig.bannerUnitId('game'),
        isNot('ca-app-pub-1111111111111111/prod'),
      );
      expect(
        testConfig.bannerUnitId('game'),
        anyOf(
          GoogleTestAdUnits.androidBanner,
          GoogleTestAdUnits.iosBanner,
        ),
      );
    });

    test('retry policy is limited with backoff', () {
      expect(config.maxRetries, 2);
      expect(config.retryBackoff, const Duration(seconds: 30));
      expect(
        config.minimumInterstitialInterval,
        const Duration(minutes: 2),
      );
    });
  });

  group('NetworkGuard', () {
    test('none is offline; other interfaces are allowed', () {
      expect(NetworkGuard.usable(const []), isFalse);
      expect(NetworkGuard.usable(const [ConnectivityResult.none]), isFalse);
      expect(NetworkGuard.usable(const [ConnectivityResult.wifi]), isTrue);
      expect(NetworkGuard.usable(const [ConnectivityResult.mobile]), isTrue);
    });
  });

  group('NotificationConfig rotation', () {
    const config = NotificationConfig(
      scheduleTimes: ['17:00', '21:00'],
      rotationMode: NotificationRotationMode.alternate,
      daysToSchedule: 14,
    );

    test('alternates 17:00 and 21:00 by day index', () {
      expect(config.scheduleTimeForDay(0), '17:00');
      expect(config.scheduleTimeForDay(1), '21:00');
      expect(config.scheduleTimeForDay(2), '17:00');
      expect(config.scheduleTimeForDay(3), '21:00');
    });
  });
}
