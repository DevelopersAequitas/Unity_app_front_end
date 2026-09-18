import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';

class ImpactBadge extends StatelessWidget {
  final int impactCount;
  final bool isPodium;
  final Color? textColor;
  final Color? iconColor;

  const ImpactBadge({
    super.key,
    required this.impactCount,
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
    final effectiveIconColor = iconColor ??
        (isPodium ? const Color(0xFFD946EF) : const Color(0xFFC026D3));

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          Icons.auto_awesome_rounded,
          size: isPodium ? 14 : 15,
          color: effectiveIconColor,
        ),
        const SizedBox(width: 4),
        Text(
          _formatCount(impactCount),
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
