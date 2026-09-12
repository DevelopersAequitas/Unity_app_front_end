import 'package:flutter/material.dart';
import '../theme/app_color.dart';

/// A full-screen gradient background widget.
///
/// Wraps [child] in a [DecoratedBox] that paints a subtle top-to-bottom
/// gradient: white → faint blue-tinted white in light mode, or deep slate →
/// slightly lighter slate in dark mode. The gradient is intentionally very
/// subtle (B2B premium — not consumer confetti).
///
/// Usage in a [Scaffold] body:
/// ```dart
/// body: AppGradientBackground(child: YourContent()),
/// ```
///
/// The [Scaffold]'s `backgroundColor` must be set to `Colors.transparent` (or
/// omitted — the gradient fills the whole area) for it to show through.
class AppGradientBackground extends StatelessWidget {
  final Widget child;

  const AppGradientBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: isDark ? AppColor.darkBgGradient : AppColor.lightBgGradient,
      ),
      child: child,
    );
  }
}
