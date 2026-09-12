import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';

class MatchActionButtons extends StatelessWidget {
  final VoidCallback onPass;
  final VoidCallback onConnect;
  final VoidCallback? onMessage;
  final VoidCallback? onBookmark;

  const MatchActionButtons({
    super.key,
    required this.onPass,
    required this.onConnect,
    this.onMessage,
    this.onBookmark,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Left: Pass button (Red circle with ✕)
          _ActionButton(
            icon: Icons.close_rounded,
            iconSize: 32,
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColor.primaryPink,
                Color(0xFFFF2A4D),
              ],
            ),
            shadowColor: AppColor.primaryPink,
            onTap: onPass,
          ),
          const SizedBox(width: 36),
          // Right: Connect button (Blue circle with 👤+)
          _ActionButton(
            icon: Icons.person_add_alt_1_rounded,
            iconSize: 28,
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF2563EB),
                AppColor.primaryBlue,
              ],
            ),
            shadowColor: AppColor.primaryBlue,
            onTap: onConnect,
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final double iconSize;
  final Gradient gradient;
  final Color shadowColor;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.iconSize,
    required this.gradient,
    required this.shadowColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 66,
      height: 66,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: gradient,
        boxShadow: [
          BoxShadow(
            color: shadowColor.withValues(alpha: 0.42),
            blurRadius: 18,
            offset: const Offset(0, 8),
            spreadRadius: 2,
          ),
          BoxShadow(
            color: shadowColor.withValues(alpha: 0.18),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          splashColor: Colors.white.withValues(alpha: 0.3),
          highlightColor: Colors.white.withValues(alpha: 0.15),
          child: Center(
            child: Icon(
              icon,
              color: Colors.white,
              size: iconSize,
            ),
          ),
        ),
      ),
    );
  }
}

