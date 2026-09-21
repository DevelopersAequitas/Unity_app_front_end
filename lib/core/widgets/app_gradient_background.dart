import 'package:flutter/material.dart';
import '../theme/app_color.dart';

/// A full-screen gradient background widget.
///
/// Wraps [child] in a [SizedBox.expand] + [DecoratedBox] that paints a subtle
/// top-to-bottom gradient: white → faint blue-tinted white in light mode, or
/// deep slate → slightly lighter slate in dark mode.
///
/// Always fills 100% of the available width and height so screens never cut off.
class AppGradientBackground extends StatelessWidget {
  final Widget child;

  const AppGradientBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SizedBox.expand(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: isDark ? AppColor.darkBgGradient : AppColor.lightBgGradient,
        ),
        child: child,
      ),
    );
  }
}
