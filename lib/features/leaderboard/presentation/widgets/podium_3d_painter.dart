import 'package:flutter/material.dart';

/// Individual 3D Card CustomPainter that draws the exact tiered arch card
/// with symmetrical curved shoulders and connected 3D cylinder pedestal base.
class PodiumCardPainter extends CustomPainter {
  final int rank;
  final bool isCenter;

  const PodiumCardPainter({required this.rank, required this.isCenter});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final pedestalHeight = isCenter ? 62.0 : (rank == 2 ? 50.0 : 46.0);
    final yPedTop = h - pedestalHeight;
    final yBottom = h;

    if (rank == 1) {
      _drawCenterCard(canvas, w, h, yPedTop, yBottom, pedestalHeight);
    } else if (rank == 2) {
      _drawLeftCard(canvas, w, h, yPedTop, yBottom, pedestalHeight);
    } else {
      _drawRightCard(canvas, w, h, yPedTop, yBottom, pedestalHeight);
    }
  }

  // ── Helper to build a symmetrical arched backplate path ──
  Path _buildSymmetricArchCardPath({
    required double w,
    required double yPedTop,
    required double yShoulder,
    required double domeRadius,
    double insetX = 4.0,
    double extraBottom = 0.0,
  }) {
    final left = insetX;
    final right = w - insetX;
    final cx = w / 2;
    final domeLeft = cx - domeRadius;
    final domeRight = cx + domeRadius;
    const cornerR = 7.0;

    final path = Path()
      ..moveTo(left, yPedTop + extraBottom)
      ..lineTo(left, yShoulder + cornerR)
      // Top-left outer shoulder corner
      ..quadraticBezierTo(left, yShoulder, left + cornerR, yShoulder)
      ..lineTo(domeLeft - 2, yShoulder)
      // Smooth fillet into dome
      ..quadraticBezierTo(domeLeft, yShoulder, domeLeft, yShoulder - 2)
      // Rounded dome arch over avatar
      ..arcToPoint(
        Offset(domeRight, yShoulder - 2),
        radius: Radius.circular(domeRadius),
        clockwise: true,
      )
      // Smooth fillet from dome to right shoulder
      ..quadraticBezierTo(domeRight, yShoulder, domeRight + 2, yShoulder)
      ..lineTo(right - cornerR, yShoulder)
      // Top-right outer shoulder corner
      ..quadraticBezierTo(right, yShoulder, right, yShoulder + cornerR)
      ..lineTo(right, yPedTop + extraBottom)
      ..close();

    return path;
  }

  // ── Helper to build the open arch stroke path (bottom cut cleanly) ──
  Path _buildArchStrokePath({
    required double w,
    required double yPedTop,
    required double yShoulder,
    required double domeRadius,
    double insetX = 4.0,
  }) {
    final left = insetX;
    final right = w - insetX;
    final cx = w / 2;
    final domeLeft = cx - domeRadius;
    final domeRight = cx + domeRadius;
    const cornerR = 7.0;

    final path = Path()
      ..moveTo(left, yPedTop)
      ..lineTo(left, yShoulder + cornerR)
      ..quadraticBezierTo(left, yShoulder, left + cornerR, yShoulder)
      ..lineTo(domeLeft - 2, yShoulder)
      ..quadraticBezierTo(domeLeft, yShoulder, domeLeft, yShoulder - 2)
      ..arcToPoint(
        Offset(domeRight, yShoulder - 2),
        radius: Radius.circular(domeRadius),
        clockwise: true,
      )
      ..quadraticBezierTo(domeRight, yShoulder, domeRight + 2, yShoulder)
      ..lineTo(right - cornerR, yShoulder)
      ..quadraticBezierTo(right, yShoulder, right, yShoulder + cornerR)
      ..lineTo(right, yPedTop);

    return path;
  }

  // ── Helper to build the 3D cylinder front face with true curved top & bottom ellipse arcs ──
  Path _buildCylinderFrontFacePath({
    required double w,
    required double yPedTop,
    required double yBottom,
    required double pedExtraX,
    required double ellipseH,
  }) {
    final left = -pedExtraX;
    final right = w + pedExtraX;
    final stageW = w + (pedExtraX * 2);
    final rX = stageW / 2;
    final rY = ellipseH / 2;

    final path = Path()
      ..moveTo(left, yPedTop)
      // Top front rim: Curves DOWNWARD in front of the card
      ..arcToPoint(
        Offset(right, yPedTop),
        radius: Radius.elliptical(rX, rY),
        clockwise: false,
      )
      // Right vertical side wall
      ..lineTo(right, yBottom - rY)
      // Bottom front rim: Curves DOWNWARD across the bottom floor
      ..arcToPoint(
        Offset(left, yBottom - rY),
        radius: Radius.elliptical(rX, rY),
        clockwise: true,
      )
      // Left vertical side wall
      ..lineTo(left, yPedTop)
      ..close();

    return path;
  }

  // ── Center Card (#1 Gold Elevated Stage) ──
  void _drawCenterCard(
    Canvas canvas,
    double w,
    double h,
    double yPedTop,
    double yBottom,
    double pedH,
  ) {
    const yShoulder = 30.0;
    const domeRadius = 32.0;
    const pedExtraX = 8.0;
    const ellipseH = 22.0;
    const insetX = 4.0;
    final rX = (w + pedExtraX * 2) / 2;
    final rY = ellipseH / 2;

    // 1. Top Platform Ellipse (Back surface of cylinder platform)
    final topEllipseRect = Rect.fromCenter(
      center: Offset(w / 2, yPedTop),
      width: w + (pedExtraX * 2),
      height: ellipseH,
    );
    final topPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFFFFFFFF),
          Color(0xFFEFF6FF),
          Color(0xFFBFDBFE),
        ],
        stops: [0.0, 0.5, 1.0],
      ).createShader(topEllipseRect);
    canvas.drawOval(topEllipseRect, topPaint);

    final backRimPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..color = Colors.white.withValues(alpha: 0.95);
    canvas.drawOval(topEllipseRect, backRimPaint);

    // 2. Symmetrical Arch Card Path (Cut cleanly at cylinder top edge)
    final cardPath = _buildSymmetricArchCardPath(
      w: w,
      yPedTop: yPedTop,
      yShoulder: yShoulder,
      domeRadius: domeRadius,
      insetX: insetX,
      extraBottom: 0.0,
    );

    // Soft Ambient Stage Underglow
    final underglowPaint = Paint()
      ..color = const Color(0xFF3B82F6).withValues(alpha: 0.08)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 14.0);
    canvas.drawPath(cardPath, underglowPaint);

    // 3D Drop Shadow
    canvas.drawShadow(
      cardPath,
      Colors.black.withValues(alpha: 0.04),
      6.0,
      false,
    );
    canvas.drawShadow(
      cardPath,
      const Color(0xFF3B82F6).withValues(alpha: 0.08),
      6.0,
      false,
    );

    // Pristine White Soft Gradient Fill
    final cardPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFFFFFFF), Color(0xFFFCFDFF), Color(0xFFF1F6FE)],
        stops: [0.0, 0.45, 1.0],
      ).createShader(Rect.fromLTRB(insetX, 0, w - insetX, yPedTop));
    canvas.drawPath(cardPath, cardPaint);

    // Glowing White Stroke along the open arch (bottom cut cleanly)
    final archStrokePath = _buildArchStrokePath(
      w: w,
      yPedTop: yPedTop,
      yShoulder: yShoulder,
      domeRadius: domeRadius,
      insetX: insetX,
    );
    final strokePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = Colors.white;
    canvas.drawPath(archStrokePath, strokePaint);

    // 3. 3D Cylinder Front Wall (Curving in front of the card!)
    final frontFacePath = _buildCylinderFrontFacePath(
      w: w,
      yPedTop: yPedTop,
      yBottom: yBottom,
      pedExtraX: pedExtraX,
      ellipseH: ellipseH,
    );

    // Drop shadow under bottom of cylinder
    canvas.drawShadow(
      frontFacePath,
      const Color(0xFF1D4ED8).withValues(alpha: 0.10),
      10.0,
      true,
    );

    // Front Wall Specular Reflection Gradient (Lighter Soft Sky Blue -> Highlight -> Soft Lavender)
    final frontPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          Color(0xFF93C5FD), // Soft sky blue
          Color(0xFFBFDBFE),
          Color(0xFFFFFFFF), // Bright center highlight
          Color(0xFFEDE9FE),
          Color(0xFFC4B5FD), // Soft lilac
        ],
        stops: [0.0, 0.22, 0.50, 0.78, 1.0],
      ).createShader(
        Rect.fromLTRB(-pedExtraX, yPedTop, w + pedExtraX, yBottom),
      );
    canvas.drawPath(frontFacePath, frontPaint);

    // Crisp Illuminated Front Top Rim Highlight (Curves down in front of card!)
    final topRimPath = Path()
      ..moveTo(-pedExtraX, yPedTop)
      ..arcToPoint(
        Offset(w + pedExtraX, yPedTop),
        radius: Radius.elliptical(rX, rY),
        clockwise: false,
      );
    final topRimPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..color = Colors.white;
    canvas.drawPath(topRimPath, topRimPaint);

    // Crisp Bottom Rim Arc Highlight
    final bottomRimPath = Path()
      ..moveTo(-pedExtraX, yBottom - rY)
      ..arcToPoint(
        Offset(w + pedExtraX, yBottom - rY),
        radius: Radius.elliptical(rX, rY),
        clockwise: false,
      );
    final bottomRimPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..color = Colors.white.withValues(alpha: 0.9);
    canvas.drawPath(bottomRimPath, bottomRimPaint);

    // Outer subtle border
    final borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8
      ..color = Colors.white.withValues(alpha: 0.9);
    canvas.drawPath(frontFacePath, borderPaint);
  }

  // ── Left Card (#2 Silver Tier) ──
  void _drawLeftCard(
    Canvas canvas,
    double w,
    double h,
    double yPedTop,
    double yBottom,
    double pedH,
  ) {
    const yShoulder = 25.0;
    const domeRadius = 26.0;
    const pedExtraX = 6.0;
    const ellipseH = 18.0;
    const insetX = 4.0;
    final rX = (w + pedExtraX * 2) / 2;
    final rY = ellipseH / 2;

    // 1. Top Platform Ellipse (Back surface of cylinder platform)
    final topEllipseRect = Rect.fromCenter(
      center: Offset(w / 2, yPedTop),
      width: w + (pedExtraX * 2),
      height: ellipseH,
    );
    final topPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFFFFFFFF),
          Color(0xFFE0F2FE),
          Color(0xFFBAE6FD),
        ],
        stops: [0.0, 0.5, 1.0],
      ).createShader(topEllipseRect);
    canvas.drawOval(topEllipseRect, topPaint);

    final backRimPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..color = Colors.white.withValues(alpha: 0.95);
    canvas.drawOval(topEllipseRect, backRimPaint);

    // 2. Symmetrical Arch Card Path (Cut cleanly at cylinder top edge)
    final cardPath = _buildSymmetricArchCardPath(
      w: w,
      yPedTop: yPedTop,
      yShoulder: yShoulder,
      domeRadius: domeRadius,
      insetX: insetX,
      extraBottom: 0.0,
    );

    // Soft Ambient Stage Underglow
    final underglowPaint = Paint()
      ..color = const Color(0xFF0284C7).withValues(alpha: 0.07)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12.0);
    canvas.drawPath(cardPath, underglowPaint);

    // Drop Shadow
    canvas.drawShadow(
      cardPath,
      Colors.black.withValues(alpha: 0.03),
      5.0,
      false,
    );

    // Fill Gradient
    final cardPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFFFFFFF), Color(0xFFFAFCFE), Color(0xFFEFF8FE)],
        stops: [0.0, 0.45, 1.0],
      ).createShader(Rect.fromLTRB(insetX, 0, w - insetX, yPedTop));
    canvas.drawPath(cardPath, cardPaint);

    // Glowing White Stroke along the open arch (bottom cut cleanly)
    final archStrokePath = _buildArchStrokePath(
      w: w,
      yPedTop: yPedTop,
      yShoulder: yShoulder,
      domeRadius: domeRadius,
      insetX: insetX,
    );
    final strokePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..color = Colors.white;
    canvas.drawPath(archStrokePath, strokePaint);

    // 3. 3D Cylinder Front Wall (Curving in front of the card!)
    final frontFacePath = _buildCylinderFrontFacePath(
      w: w,
      yPedTop: yPedTop,
      yBottom: yBottom,
      pedExtraX: pedExtraX,
      ellipseH: ellipseH,
    );

    // Drop shadow under left cylinder
    canvas.drawShadow(
      frontFacePath,
      const Color(0xFF0369A1).withValues(alpha: 0.09),
      8.0,
      true,
    );

    // 3D Cylinder Front Wall (Soft Ice Cyan/Blue)
    final frontPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          Color(0xFF7DD3FC), // Soft ice cyan
          Color(0xFFBAE6FD),
          Color(0xFFFFFFFF), // Highlight
          Color(0xFFE0F2FE),
          Color(0xFF93C5FD), // Soft sky
        ],
        stops: [0.0, 0.25, 0.50, 0.78, 1.0],
      ).createShader(
        Rect.fromLTRB(-pedExtraX, yPedTop, w + pedExtraX, yBottom),
      );
    canvas.drawPath(frontFacePath, frontPaint);

    // Crisp Illuminated Front Top Rim Highlight
    final topRimPath = Path()
      ..moveTo(-pedExtraX, yPedTop)
      ..arcToPoint(
        Offset(w + pedExtraX, yPedTop),
        radius: Radius.elliptical(rX, rY),
        clockwise: false,
      );
    final topRimPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4
      ..color = Colors.white;
    canvas.drawPath(topRimPath, topRimPaint);

    // Crisp Bottom Rim Arc Highlight
    final bottomRimPath = Path()
      ..moveTo(-pedExtraX, yBottom - rY)
      ..arcToPoint(
        Offset(w + pedExtraX, yBottom - rY),
        radius: Radius.elliptical(rX, rY),
        clockwise: false,
      );
    final bottomRimPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.9
      ..color = Colors.white.withValues(alpha: 0.85);
    canvas.drawPath(bottomRimPath, bottomRimPaint);

    // Outer subtle border
    final borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8
      ..color = Colors.white.withValues(alpha: 0.85);
    canvas.drawPath(frontFacePath, borderPaint);
  }

  // ── Right Card (#3 Bronze Tier) ──
  void _drawRightCard(
    Canvas canvas,
    double w,
    double h,
    double yPedTop,
    double yBottom,
    double pedH,
  ) {
    const yShoulder = 25.0;
    const domeRadius = 26.0;
    const pedExtraX = 6.0;
    const ellipseH = 18.0;
    const insetX = 4.0;
    final rX = (w + pedExtraX * 2) / 2;
    final rY = ellipseH / 2;

    // 1. Top Platform Ellipse (Back surface of cylinder platform)
    final topEllipseRect = Rect.fromCenter(
      center: Offset(w / 2, yPedTop),
      width: w + (pedExtraX * 2),
      height: ellipseH,
    );
    final topPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFFFFFFFF),
          Color(0xFFFCE7F3),
          Color(0xFFFBCFE8),
        ],
        stops: [0.0, 0.5, 1.0],
      ).createShader(topEllipseRect);
    canvas.drawOval(topEllipseRect, topPaint);

    final backRimPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..color = Colors.white.withValues(alpha: 0.95);
    canvas.drawOval(topEllipseRect, backRimPaint);

    // 2. Symmetrical Arch Card Path (Cut cleanly at cylinder top edge)
    final cardPath = _buildSymmetricArchCardPath(
      w: w,
      yPedTop: yPedTop,
      yShoulder: yShoulder,
      domeRadius: domeRadius,
      insetX: insetX,
      extraBottom: 0.0,
    );

    // Soft Ambient Stage Underglow
    final underglowPaint = Paint()
      ..color = const Color(0xFFF43F5E).withValues(alpha: 0.07)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12.0);
    canvas.drawPath(cardPath, underglowPaint);

    // Drop Shadow
    canvas.drawShadow(
      cardPath,
      Colors.black.withValues(alpha: 0.03),
      5.0,
      false,
    );

    // Fill Gradient
    final cardPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFFFFFFF), Color(0xFFFFF7FA), Color(0xFFFDE8F1)],
        stops: [0.0, 0.45, 1.0],
      ).createShader(Rect.fromLTRB(insetX, 0, w - insetX, yPedTop));
    canvas.drawPath(cardPath, cardPaint);

    // Glowing White Stroke along the open arch (bottom cut cleanly)
    final archStrokePath = _buildArchStrokePath(
      w: w,
      yPedTop: yPedTop,
      yShoulder: yShoulder,
      domeRadius: domeRadius,
      insetX: insetX,
    );
    final strokePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..color = Colors.white;
    canvas.drawPath(archStrokePath, strokePaint);

    // 3. 3D Cylinder Front Wall (Curving in front of the card!)
    final frontFacePath = _buildCylinderFrontFacePath(
      w: w,
      yPedTop: yPedTop,
      yBottom: yBottom,
      pedExtraX: pedExtraX,
      ellipseH: ellipseH,
    );

    // Drop shadow under right cylinder
    canvas.drawShadow(
      frontFacePath,
      const Color(0xFFBE123C).withValues(alpha: 0.09),
      8.0,
      true,
    );

    // 3D Cylinder Front Wall (Soft Rose / Blush)
    final frontPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          Color(0xFFFDA4AF), // Soft rose
          Color(0xFFFCE7F3),
          Color(0xFFFFFFFF), // Highlight
          Color(0xFFFCE7F3),
          Color(0xFFFB7185), // Soft vibrant rose
        ],
        stops: [0.0, 0.25, 0.50, 0.78, 1.0],
      ).createShader(
        Rect.fromLTRB(-pedExtraX, yPedTop, w + pedExtraX, yBottom),
      );
    canvas.drawPath(frontFacePath, frontPaint);

    // Crisp Illuminated Front Top Rim Highlight
    final topRimPath = Path()
      ..moveTo(-pedExtraX, yPedTop)
      ..arcToPoint(
        Offset(w + pedExtraX, yPedTop),
        radius: Radius.elliptical(rX, rY),
        clockwise: false,
      );
    final topRimPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4
      ..color = Colors.white;
    canvas.drawPath(topRimPath, topRimPaint);

    // Crisp Bottom Rim Arc Highlight
    final bottomRimPath = Path()
      ..moveTo(-pedExtraX, yBottom - rY)
      ..arcToPoint(
        Offset(w + pedExtraX, yBottom - rY),
        radius: Radius.elliptical(rX, rY),
        clockwise: false,
      );
    final bottomRimPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.9
      ..color = Colors.white.withValues(alpha: 0.85);
    canvas.drawPath(bottomRimPath, bottomRimPaint);

    // Outer subtle border
    final borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8
      ..color = Colors.white.withValues(alpha: 0.85);
    canvas.drawPath(frontFacePath, borderPaint);
  }

  @override
  bool shouldRepaint(covariant PodiumCardPainter oldDelegate) =>
      oldDelegate.rank != rank || oldDelegate.isCenter != isCenter;
}
