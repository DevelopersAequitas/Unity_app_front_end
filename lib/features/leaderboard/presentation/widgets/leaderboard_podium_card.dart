import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_color.dart';
import '../../domain/entities/leaderboard_entry_entity.dart';
import 'coin_badge.dart';
import 'impact_badge.dart';
import 'podium_3d_painter.dart';

class LeaderboardPodiumCard extends StatelessWidget {
  final LeaderboardEntryEntity entry;
  final int rank;
  final bool isCenter;
  final bool isImpact;

  const LeaderboardPodiumCard({
    super.key,
    required this.entry,
    required this.rank,
    this.isCenter = false,
    this.isImpact = false,
  });

  void _navigateToProfile(BuildContext context) {
    if (entry.isCurrentUser) {
      Navigator.pushNamed(context, AppRoutes.profile);
      return;
    }
    final memberId = entry.userId.isNotEmpty ? entry.userId : entry.id;
    if (memberId.isEmpty) return;
    Navigator.pushNamed(
      context,
      AppRoutes.peerProfile,
      arguments: memberId,
    );
  }

  LinearGradient _getRankBadgeGradient() {
    switch (rank) {
      case 1:
        return const LinearGradient(
          colors: [Color(0xFFFDE047), Color(0xFFF59E0B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 2:
        return const LinearGradient(
          colors: [Color(0xFFCBD5E1), Color(0xFF94A3B8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 3:
      default:
        return const LinearGradient(
          colors: [Color(0xFFFED7AA), Color(0xFFFB923C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
    }
  }

  Color _getPedestalCaptionColor() {
    switch (rank) {
      case 1:
        return const Color(0xFF2563EB); // Royal Blue
      case 2:
        return const Color(0xFF0284C7); // Ocean Sky Blue
      case 3:
      default:
        return const Color(0xFFE11D48); // Rose / Berry
    }
  }

  @override
  Widget build(BuildContext context) {
    final avatarSize = isCenter ? 76.0 : 60.0;
    final badgeSize = isCenter ? 23.0 : 19.0;
    final cardHeight = isCenter ? 260.0 : (rank == 2 ? 230.0 : 224.0);
    final caption = entry.defaultPodiumCaption;

    return GestureDetector(
      onTap: () => _navigateToProfile(context),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        height: cardHeight,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            // ── 1. Custom Painted Symmetrical 3D Tiered Card & Base ──
            Positioned.fill(
              top: avatarSize * 0.44,
              child: CustomPaint(
                painter: PodiumCardPainter(
                  rank: rank,
                  isCenter: isCenter,
                ),
              ),
            ),

            // ── 2. Card Content Column ──
            Positioned.fill(
              top: avatarSize * 0.44,
              child: Column(
                children: [
                  // Space below avatar to push text down comfortably into the card
                  SizedBox(height: isCenter ? 74.0 : 58.0),

                  // 1. Peer Name (UPPER CASE & refined font size)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      entry.name.toUpperCase(),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: isCenter ? 11.0 : 9.5,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF0F172A),
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),

                  // 2. City
                  if (entry.city != null && entry.city!.trim().isNotEmpty) ...[
                    const SizedBox(height: 2.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Text(
                        entry.city!.trim(),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: isCenter ? 9.5 : 8.0,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                    ),
                  ],

                  // 3. Company Name
                  if (entry.companyName != null && entry.companyName!.trim().isNotEmpty) ...[
                    const SizedBox(height: 2.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Text(
                        entry.companyName!.trim(),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: isCenter ? 8.5 : 7.5,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF94A3B8),
                        ),
                      ),
                    ),
                  ],

                  // 4. Category Tag (Gradient Colored Text, No Background)
                  if (entry.category != null && entry.category!.trim().isNotEmpty) ...[
                    const SizedBox(height: 2.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: ShaderMask(
                        blendMode: BlendMode.srcIn,
                        shaderCallback: (bounds) => AppColor.brandGradient.createShader(
                          Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.sell_outlined,
                              size: isCenter ? 7.5 : 6.5,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 2.0),
                            Flexible(
                              child: Text(
                                entry.category!.trim(),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: isCenter ? 8.5 : 7.5,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                  letterSpacing: 0.1,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],

                  // 5. Coin / Impact Count Badge
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: isImpact
                          ? ImpactBadge(
                              impactCount: entry.impactCount ?? entry.coins,
                              isPodium: true,
                            )
                          : CoinBadge(
                              coins: entry.coins,
                              isPodium: true,
                            ),
                    ),
                  ),

                  const Spacer(),

                  // Milestone Caption (Inside 3D Cylinder Step with bold typography)
                  Container(
                    height: isCenter ? 48.0 : 40.0,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        caption,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: isCenter ? 11.5 : 10.0,
                          fontWeight: FontWeight.w500,
                          color: _getPedestalCaptionColor(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── 3. Floating Avatar with Metallic Rank Badge on Top-Right ──
            Positioned(
              top: isCenter ? 20.0 : 16.0,
              child: _buildAvatar(avatarSize, badgeSize),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(double avatarSize, double badgeSize) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        // Avatar Circle with crisp white border and drop shadow
        Container(
          width: avatarSize,
          height: avatarSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white,
              width: isCenter ? 2.5 : 2.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: isCenter ? 8 : 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipOval(
            child: entry.profilePhotoUrl != null && entry.profilePhotoUrl!.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: entry.profilePhotoUrl!,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: AppColor.lightSurfaceSubtle,
                      child: const Center(
                        child: SizedBox(
                          width: 12,
                          height: 12,
                          child: CircularProgressIndicator(strokeWidth: 1.5),
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => _buildInitials(avatarSize),
                  )
                : _buildInitials(avatarSize),
          ),
        ),

        // Metallic Rank Badge (Top-Right)
        Positioned(
          top: -2,
          right: -2,
          child: Container(
            width: badgeSize,
            height: badgeSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: _getRankBadgeGradient(),
              border: Border.all(color: Colors.white, width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.20),
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Center(
              child: Text(
                '$rank',
                style: TextStyle(
                  fontSize: isCenter ? 11.5 : 10.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  height: 1.0,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInitials(double avatarSize) {
    final initials = entry.name.trim().isNotEmpty
        ? entry.name.trim().split(' ').map((e) => e.isNotEmpty ? e[0] : '').take(2).join()
        : 'P';
    return Container(
      color: AppColor.primaryBlue.withValues(alpha: 0.1),
      child: Center(
        child: Text(
          initials.toUpperCase(),
          style: TextStyle(
            fontSize: avatarSize * 0.36,
            fontWeight: FontWeight.w500,
            color: AppColor.primaryBlue,
          ),
        ),
      ),
    );
  }
}
