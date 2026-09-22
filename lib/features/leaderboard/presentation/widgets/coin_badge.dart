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
    return Image.asset(
      'assets/images/coin.png',
      width: size,
      height: size,
      fit: BoxFit.contain,
    );
  }
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
