import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';

class CoinStackIcon extends StatelessWidget {
  final double size;
  final Color? color;

  const CoinStackIcon({
    super.key,
    this.size = 16,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final c = color ?? const Color(0xFFEAB308); // Gold/amber or primary
    return CustomPaint(
      size: Size(size, size),
      painter: _CoinStackPainter(color: c),
    );
  }
}

class _CoinStackPainter extends CustomPainter {
  final Color color;

  _CoinStackPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = size.width * 0.085;
    final strokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth.clamp(1.0, 2.0)
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final fillPaint = Paint()
      ..color = color.withValues(alpha: 0.12)
      ..style = PaintingStyle.fill;

    final w = size.width;
    final h = size.height;

    // We draw 3 stacked coin disks from bottom to top
    final diskHeight = h * 0.32;
    final diskWidth = w * 0.88;
    final left = (w - diskWidth) / 2;

    // Bottom coin (lowest)
    final bottomRect = Rect.fromLTWH(left, h * 0.52, diskWidth, diskHeight);
    canvas.drawOval(bottomRect, fillPaint);
    canvas.drawArc(bottomRect, 0, 3.14159, false, strokePaint);

    // Middle coin
    final midRect = Rect.fromLTWH(left, h * 0.30, diskWidth, diskHeight);
    canvas.drawOval(midRect, fillPaint);
    canvas.drawArc(midRect, 0, 3.14159, false, strokePaint);

    // Top coin (full oval)
    final topRect = Rect.fromLTWH(left, h * 0.08, diskWidth, diskHeight);
    canvas.drawOval(topRect, fillPaint);
    canvas.drawOval(topRect, strokePaint);

    // Inner subtle ring in top coin
    final innerTopRect = Rect.fromLTWH(
      left + diskWidth * 0.15,
      h * 0.08 + diskHeight * 0.15,
      diskWidth * 0.7,
      diskHeight * 0.7,
    );
    canvas.drawOval(
      innerTopRect,
      Paint()
        ..color = color.withValues(alpha: 0.4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth * 0.65,
    );
  }

  @override
  bool shouldRepaint(covariant _CoinStackPainter oldDelegate) =>
      oldDelegate.color != color;
}

class CoinBadge extends StatelessWidget {
  final int coins;
  final bool isPodium;
  final Color? textColor;
  final Color? iconColor;

  const CoinBadge({
    super.key,
    required this.coins,
    this.isPodium = false,
    this.textColor,
    this.iconColor,
  });

  String _formatCount(int number) {
    if (number >= 1000000000000000) {
      final val = (number / 1000000000000000).toStringAsFixed(1);
      return '${val.endsWith('.0') ? val.substring(0, val.length - 2) : val}Q';
    }
    if (number >= 1000000000000) {
      final val = (number / 1000000000000).toStringAsFixed(1);
      return '${val.endsWith('.0') ? val.substring(0, val.length - 2) : val}T';
    }
    if (number >= 1000000000) {
      final val = (number / 1000000000).toStringAsFixed(1);
      return '${val.endsWith('.0') ? val.substring(0, val.length - 2) : val}B';
    }
    if (number >= 1000000) {
      final val = (number / 1000000).toStringAsFixed(1);
      return '${val.endsWith('.0') ? val.substring(0, val.length - 2) : val}M';
    }
    if (number >= 100000) {
      final val = (number / 1000).toStringAsFixed(1);
      return '${val.endsWith('.0') ? val.substring(0, val.length - 2) : val}K';
    }
    if (number >= 1000) {
      final str = number.toString();
      final chars = str.split('');
      final buffer = StringBuffer();
      for (int i = 0; i < chars.length; i++) {
        if (i > 0 && (chars.length - i) % 3 == 0) {
          buffer.write(',');
        }
        buffer.write(chars[i]);
      }
      return buffer.toString();
    }
    return number.toString();
  }

  @override
  Widget build(BuildContext context) {
    final effectiveIconColor = iconColor ?? (isPodium ? const Color(0xFFD97706) : const Color(0xFF2563EB));
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CoinStackIcon(
          size: isPodium ? 15 : 16,
          color: effectiveIconColor,
        ),
        const SizedBox(width: 4),
        Text(
          _formatCount(coins),
          style: TextStyle(
            fontSize: isPodium ? 12.5 : 13.5,
            fontWeight: FontWeight.w500,
            color: textColor ?? AppColor.lightTextPrimary,
            letterSpacing: -0.1,
          ),
        ),
      ],
    );
  }
}
