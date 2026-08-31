import 'package:flutter/widgets.dart';

/// True only when the app is in the foreground and system back should run.
bool shouldHandleSystemBack() {
  return WidgetsBinding.instance.lifecycleState == AppLifecycleState.resumed;
}
