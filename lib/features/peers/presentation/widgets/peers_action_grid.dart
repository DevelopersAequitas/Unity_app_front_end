import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';

class PeersActionGrid extends StatelessWidget {
  final VoidCallback onConnectionsTap;
  final VoidCallback onRequestsTap;
  final VoidCallback? onNearMeTap;
  final VoidCallback? onMatchesTap;

  const PeersActionGrid({
    super.key,
    required this.onConnectionsTap,
    required this.onRequestsTap,
    this.onNearMeTap,
    this.onMatchesTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: [
          Expanded(
            child: _ActionCard(
              icon: Icons.location_on_rounded,
              label: 'Near Me',
              iconColor: const Color(0xFF2563EB),
              badgeBg: const Color(0xFFEFF6FF),
              onTap: onNearMeTap,
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: _ActionCard(
              icon: Icons.groups_rounded,
              label: 'Connections',
              iconColor: const Color(0xFF4F46E5),
              badgeBg: const Color(0xFFEEF2FF),
              onTap: onConnectionsTap,
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: _ActionCard(
              icon: Icons.favorite_rounded,
              label: 'Matches',
              iconColor: const Color(0xFFE11D48),
              badgeBg: const Color(0xFFFFF1F2),
              onTap: onMatchesTap,
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: _ActionCard(
              icon: Icons.person_add_alt_1_rounded,
              label: 'Requests',
              iconColor: const Color(0xFF7C3AED),
              badgeBg: const Color(0xFFFAF5FF),
              onTap: onRequestsTap,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color iconColor;
  final Color badgeBg;
  final VoidCallback? onTap;

  const _ActionCard({
    required this.icon,
    required this.label,
    required this.iconColor,
    required this.badgeBg,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.lightSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColor.lightBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: badgeBg,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(icon, size: 15, color: iconColor),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppColor.lightTextPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
