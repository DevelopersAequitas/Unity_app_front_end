import 'package:flutter/material.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../screens/peers_asks_hub_screen.dart';
import 'ask_flow_selection_overlay.dart';

class HomeAskFlowsSection extends StatelessWidget {
  const HomeAskFlowsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColor.darkSurface : AppColor.lightSurface;
    final borderColor = isDark ? AppColor.darkBorder : AppColor.lightBorder;
    final titleColor = isDark
        ? AppColor.darkTextPrimary
        : AppColor.lightTextPrimary;
    final subtitleColor = isDark
        ? AppColor.darkTextSecondary
        : AppColor.lightTextSecondary;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Container(
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: 0.9),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Top Header Bar ──────────────────────────────────────────────
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () =>
                        Navigator.of(context).pushNamed(AppRoutes.openAsks),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'What do you need right now?',
                              style: AppTypography.titleMedium.copyWith(
                                fontSize: 14.5,
                                fontWeight: FontWeight.w700,
                                color: titleColor,
                                letterSpacing: -0.2,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 11,
                              color: AppColor.primaryBlue,
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Collaborations · Referrals · Get Help',
                          style: AppTypography.bodySmall.copyWith(
                            fontSize: 11.5,
                            color: subtitleColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(18),
                    onTap: () => AskFlowSelectionOverlay.show(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 11,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        gradient: AppColor.brandGradient,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: AppColor.primaryBlue.withValues(alpha: 0.25),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.add_rounded,
                            size: 14,
                            color: Colors.white,
                          ),
                          SizedBox(width: 3),
                          Text(
                            'Post Ask',
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // ── 3 Side-by-Side Flow Tiles ──────────────────────────────────
            Row(
              children: [
                // 1. Collaborations
                Expanded(
                  child: _CompactFlowTile(
                    title: 'Collaborations',
                    subtitle: 'Partners & JV',
                    icon: Icons.handshake_rounded,
                    accentColor: const Color(0xFF0E7A68),
                    bgGradient: const [Color(0xFF0E7A68), Color(0xFF065F46)],
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const PeersAsksHubScreen(
                          flowCode: 'collaboration',
                          flowTitle: 'Collaboration Asks',
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // 2. Referrals
                Expanded(
                  child: _CompactFlowTile(
                    title: 'Referrals',
                    subtitle: 'Introductions',
                    icon: Icons.share_location_rounded,
                    accentColor: const Color(0xFF1E3A8A),
                    bgGradient: const [Color(0xFF1E3A8A), Color(0xFF172554)],
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const PeersAsksHubScreen(
                          flowCode: 'referral',
                          flowTitle: 'Referral Asks',
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // 3. Get Help
                Expanded(
                  child: _CompactFlowTile(
                    title: 'Get Help',
                    subtitle: 'Advice & Tasks',
                    icon: Icons.support_agent_rounded,
                    accentColor: const Color(0xFF6B21A8),
                    bgGradient: const [Color(0xFF6B21A8), Color(0xFF4C1D95)],
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const PeersAsksHubScreen(
                          flowCode: 'help',
                          flowTitle: 'Get Help Asks',
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // ── Bottom Quick Links Row ──────────────────────────────────────
            // Container(
            //   padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            //   decoration: BoxDecoration(
            //     color: isDark
            //         ? const Color(0xFF0F172A).withValues(alpha: 0.5)
            //         : const Color(0xFFF8FAFC),
            //     borderRadius: BorderRadius.circular(10),
            //     border: Border.all(
            //       color: isDark
            //           ? const Color(0xFF334155)
            //           : const Color(0xFFE2E8F0),
            //       width: 0.8,
            //     ),
            //   ),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       InkWell(
            //         onTap: () =>
            //             Navigator.of(context).pushNamed(AppRoutes.openAsks),
            //         borderRadius: BorderRadius.circular(6),
            //         child: Padding(
            //           padding: const EdgeInsets.symmetric(
            //             horizontal: 4,
            //             vertical: 2,
            //           ),
            //           child: Row(
            //             mainAxisSize: MainAxisSize.min,
            //             children: [
            //               Icon(
            //                 Icons.public_rounded,
            //                 size: 14,
            //                 color: isDark
            //                     ? const Color(0xFF38BDF8)
            //                     : AppColor.primaryBlue,
            //               ),
            //               const SizedBox(width: 4),
            //               Text(
            //                 'Global Feed',
            //                 style: TextStyle(
            //                   fontSize: 11.5,
            //                   fontWeight: FontWeight.w600,
            //                   color: isDark
            //                       ? const Color(0xFF38BDF8)
            //                       : AppColor.primaryBlue,
            //                 ),
            //               ),
            //             ],
            //           ),
            //         ),
            //       ),
            //       Container(
            //         width: 1,
            //         height: 14,
            //         color: isDark
            //             ? const Color(0xFF334155)
            //             : const Color(0xFFCBD5E1),
            //       ),
            //       InkWell(
            //         onTap: () =>
            //             Navigator.of(context).pushNamed(AppRoutes.myAsks),
            //         borderRadius: BorderRadius.circular(6),
            //         child: Padding(
            //           padding: const EdgeInsets.symmetric(
            //             horizontal: 4,
            //             vertical: 2,
            //           ),
            //           child: Row(
            //             mainAxisSize: MainAxisSize.min,
            //             children: [
            //               Icon(
            //                 Icons.history_rounded,
            //                 size: 14,
            //                 color: isDark
            //                     ? const Color(0xFF34D399)
            //                     : const Color(0xFF0E7A68),
            //               ),
            //               const SizedBox(width: 4),
            //               Text(
            //                 'My Requests',
            //                 style: TextStyle(
            //                   fontSize: 11.5,
            //                   fontWeight: FontWeight.w600,
            //                   color: isDark
            //                       ? const Color(0xFF34D399)
            //                       : const Color(0xFF0E7A68),
            //                 ),
            //               ),
            //             ],
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

class _CompactFlowTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color accentColor;
  final List<Color> bgGradient;
  final VoidCallback onTap;

  const _CompactFlowTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accentColor,
    required this.bgGradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: bgGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: bgGradient.first.withValues(alpha: 0.25),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          splashColor: Colors.white.withValues(alpha: 0.2),
          highlightColor: Colors.white.withValues(alpha: 0.1),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Circular icon
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(icon, size: 17, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.2,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.85),
                    fontSize: 9.5,
                    fontWeight: FontWeight.w400,
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
