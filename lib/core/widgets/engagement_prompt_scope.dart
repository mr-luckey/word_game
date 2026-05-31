import 'dart:async';

import 'package:flutter/material.dart';
import 'package:word_game/core/services/app_rating_service.dart';
import 'package:word_game/core/widgets/journey_prompt_dialog.dart';
import 'package:word_game/injection.dart';

/// Shows random rating prompts while the user plays on the home screen.
class EngagementPromptScope extends StatefulWidget {
  const EngagementPromptScope({
    super.key,
    required this.child,
    this.afterGameplay = false,
  });

  final Widget child;
  final bool afterGameplay;

  @override
  State<EngagementPromptScope> createState() => _EngagementPromptScopeState();
}

class _EngagementPromptScopeState extends State<EngagementPromptScope> {
  Timer? _idleTimer;
  bool _ratingShownThisSession = false;

  @override
  void initState() {
    super.initState();
    _scheduleIdleRatingPrompt();
    if (widget.afterGameplay) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _maybeShowRating(afterGameplay: true);
      });
    }
  }

  @override
  void didUpdateWidget(covariant EngagementPromptScope oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!oldWidget.afterGameplay && widget.afterGameplay) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _maybeShowRating(afterGameplay: true);
      });
    }
  }

  void _scheduleIdleRatingPrompt() {
    _idleTimer?.cancel();
    _idleTimer = Timer(const Duration(seconds: 75), () {
      if (!mounted) return;
      _maybeShowRating(afterGameplay: false);
    });
  }

  Future<void> _maybeShowRating({required bool afterGameplay}) async {
    if (!mounted || _ratingShownThisSession) return;

    final rating = getIt<AppRatingService>();
    if (!rating.shouldOfferRandomPrompt(afterGameplay: afterGameplay)) {
      return;
    }

    _ratingShownThisSession = true;
    final accepted = await showJourneyPromptDialog(
      context,
      kind: JourneyPromptKind.rating,
    );
    if (!mounted) return;

    if (accepted == true) {
      await rating.markRated();
      await rating.openStoreListing();
    } else {
      await rating.markDeclined();
    }
  }

  @override
  void dispose() {
    _idleTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
