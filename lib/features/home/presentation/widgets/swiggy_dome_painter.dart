import 'package:flutter/material.dart';

class SwiggyDomePainter extends CustomPainter {
  final double selectedIndex;
  final int tabCount;
  final Color backgroundColor;
  final Color borderColor;
  final Color baselineColor;
  final double tabHeaderHeight;
  final double borderWidth;

  const SwiggyDomePainter({
    required this.selectedIndex,
    this.tabCount = 4,
    required this.backgroundColor,
    required this.borderColor,
    required this.baselineColor,
    this.tabHeaderHeight = 74.0,
    this.borderWidth = 1.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (tabCount <= 0) return;

    final W = size.width;
    final H = size.height;
    final tabWidth = W / tabCount;
    const tabRadius = 14.0;
    const flareRadius = 8.0;
    const tabTop = 4.0;
    final baseH = tabHeaderHeight;

    final rawLeft = selectedIndex * tabWidth;
    final rawRight = (selectedIndex + 1) * tabWidth;
    final x0 = rawLeft.clamp(0.0, W);
    final x1 = rawRight.clamp(0.0, W);

    final isFirst = x0 <= 0.5;
    final isLast = x1 >= W - 0.5;

    // 1. Unified body path
    final unifiedPath = Path();
    unifiedPath.moveTo(0, baseH);

    // Left baseline and selected tab left edge
    if (!isFirst) {
      unifiedPath.lineTo((x0 - flareRadius).clamp(0.0, W), baseH);
      unifiedPath.quadraticBezierTo(x0, baseH, x0, baseH - flareRadius);
      unifiedPath.lineTo(x0, tabTop + tabRadius);
      unifiedPath.arcToPoint(
        Offset(x0 + tabRadius, tabTop),
        radius: const Radius.circular(tabRadius),
      );
    } else {
      unifiedPath.lineTo(0, tabTop + tabRadius);
      unifiedPath.arcToPoint(
        const Offset(tabRadius, tabTop),
        radius: const Radius.circular(tabRadius),
      );
    }

    // Top edge & right edge of selected tab
    if (!isLast) {
      unifiedPath.lineTo(x1 - tabRadius, tabTop);
      unifiedPath.arcToPoint(
        Offset(x1, tabTop + tabRadius),
        radius: const Radius.circular(tabRadius),
      );
      unifiedPath.lineTo(x1, baseH - flareRadius);
      unifiedPath.quadraticBezierTo(
        x1,
        baseH,
        (x1 + flareRadius).clamp(0.0, W),
        baseH,
      );
      unifiedPath.lineTo(W, baseH);
    } else {
      unifiedPath.lineTo(W - tabRadius, tabTop);
      unifiedPath.arcToPoint(
        Offset(W, tabTop + tabRadius),
        radius: const Radius.circular(tabRadius),
      );
      unifiedPath.lineTo(W, baseH);
    }

    // Content box right edge (flat bottom)
    unifiedPath.lineTo(W, H);

    // Content box bottom edge
    unifiedPath.lineTo(0, H);

    // Close path
    unifiedPath.close();

    // Draw fill
    final fillPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;
    canvas.drawPath(unifiedPath, fillPaint);

    // Outer contour border
    final borderPaint = Paint()
      ..color = borderColor
      ..strokeWidth = borderWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(unifiedPath, borderPaint);

    // Baseline under unselected tabs
    final baseLinePaint = Paint()
      ..color = baselineColor
      ..strokeWidth = borderWidth
      ..style = PaintingStyle.stroke;

    if (!isFirst) {
      final leftEnd = (x0 - flareRadius).clamp(0.0, W);
      if (leftEnd > 0) {
        canvas.drawLine(Offset(0, baseH), Offset(leftEnd, baseH), baseLinePaint);
      }
    }

    if (!isLast) {
      final rightStart = (x1 + flareRadius).clamp(0.0, W);
      if (rightStart < W) {
        canvas.drawLine(Offset(rightStart, baseH), Offset(W, baseH), baseLinePaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant SwiggyDomePainter oldDelegate) {
    return oldDelegate.selectedIndex != selectedIndex ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.borderColor != borderColor ||
        oldDelegate.baselineColor != baselineColor;
  }
}
