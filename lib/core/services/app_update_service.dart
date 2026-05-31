import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

/// Checks Play Store for updates and opens the store listing when requested.
class AppUpdateService {
  static const playStoreId = 'com.appwaretech.WordGlow';

  bool _updateAvailable = false;

  bool get updateAvailable => _updateAvailable;

  /// Returns whether a newer build exists on the Play Store.
  Future<bool> checkForUpdate() async {
    _updateAvailable = false;
    if (kIsWeb || !Platform.isAndroid) return false;

    try {
      final info = await InAppUpdate.checkForUpdate();
      _updateAvailable =
          info.updateAvailability == UpdateAvailability.updateAvailable;
      return _updateAvailable;
    } catch (_) {
      return false;
    }
  }

  Future<String> currentVersionLabel() async {
    final info = await PackageInfo.fromPlatform();
    return '${info.version} (${info.buildNumber})';
  }

  Future<void> startUpdate() async {
    if (kIsWeb || !Platform.isAndroid) {
      await openStoreListing();
      return;
    }

    try {
      if (_updateAvailable) {
        await InAppUpdate.performImmediateUpdate();
        return;
      }
    } catch (_) {}

    await openStoreListing();
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
