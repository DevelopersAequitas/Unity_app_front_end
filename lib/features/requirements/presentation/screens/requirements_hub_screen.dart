import 'package:flutter/material.dart';
import 'open_asks_screen.dart';

/// Backward-compatible wrapper for OpenAsksScreen
class RequirementsHubScreen extends StatelessWidget {
  final int initialTabIndex;

  const RequirementsHubScreen({
    super.key,
    this.initialTabIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    return OpenAsksScreen(
      initialTabIndex: initialTabIndex == 2 ? 0 : initialTabIndex,
    );
  }
}
