import 'dart:async';

import 'package:flutter/material.dart';
import 'package:word_game/core/services/audio_service.dart';
import 'package:word_game/injection.dart';

/// Pauses background music when the app is backgrounded or the screen turns off,
/// and resumes when the user returns.
class AppLifecycleAudioScope extends StatefulWidget {
  const AppLifecycleAudioScope({required this.child, super.key});

  final Widget child;

  @override
  State<AppLifecycleAudioScope> createState() => _AppLifecycleAudioScopeState();
}

class _AppLifecycleAudioScopeState extends State<AppLifecycleAudioScope>
    with WidgetsBindingObserver {
  late final AudioService _audio = getIt<AudioService>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      unawaited(_audio.resumeBackgroundMusicFromLifecycle());
      return;
    }
    switch (state) {
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.hidden:
      case AppLifecycleState.detached:
        unawaited(_audio.pauseBackgroundMusicForLifecycle());
      case AppLifecycleState.resumed:
        break;
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
