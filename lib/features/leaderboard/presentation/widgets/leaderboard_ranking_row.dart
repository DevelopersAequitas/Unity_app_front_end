import 'package:flutter/material.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/widgets/app_avatar.dart';
import '../../domain/entities/leaderboard_entry_entity.dart';
import 'coin_badge.dart';

class LeaderboardRankingRow extends StatelessWidget {
  final LeaderboardEntryEntity entry;
  final bool isLast;
  final bool isImpact;

  const LeaderboardRankingRow({
    super.key,
    required this.entry,
    this.isLast = false,
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

  @override
  Widget build(BuildContext context) {
    final hasDesignationOrCompany =
        (entry.designation != null && entry.designation!.trim().isNotEmpty) ||
        (entry.companyName != null && entry.companyName!.trim().isNotEmpty);
    final hasCity = entry.city != null && entry.city!.trim().isNotEmpty;
    final hasCategory =
        entry.category != null && entry.category!.trim().isNotEmpty;
    final hasImpact = entry.impactCount != null && entry.impactCount! > 0;
    final isTopTen = entry.rank <= 10;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 3),
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
        color: AppColor.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: () => _navigateToProfile(context),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Avatar with Top-Right Overlaid Rank Badge ──
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    AppAvatar(
                      imageUrl: entry.profilePhotoUrl,
                      name: entry.name,
                      size: 38,
                      showOnlineBadge: false,
                      isPro: entry.isPro,
                    ),
                    Positioned(
                      right: -4,
                      top: -4,
                      child: _buildRankBadge(isTopTen),
                    ),
                  ],
                ),
                const SizedBox(width: 8),

                // ── Peer Info ──
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Row 1: UPPERCASE Name + verified + PRO badge
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              entry.name.toUpperCase(),
                              style: const TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w500,
                                color: AppColor.lightTextPrimary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (entry.isVerified) ...[
                            const SizedBox(width: 3),
                            const Icon(
                              Icons.verified_rounded,
                              size: 13,
                              color: AppColor.primaryBlue,
                            ),
                          ],
                          if (entry.isPro) ...[
                            const SizedBox(width: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 5,
                                vertical: 1.5,
                              ),
                              decoration: BoxDecoration(
                                gradient: AppColor.brandGradient,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'PRO',
                                style: TextStyle(
                                  fontSize: 8,
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.white,
                                  letterSpacing: 0.4,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),

                      // Row 2: City directly below peer name
                      if (hasCity) ...[
                        const SizedBox(height: 1.5),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on_rounded,
                              size: 10,
                              color: AppColor.lightTextSecondary,
                            ),
                            const SizedBox(width: 2.5),
                            Text(
                              entry.city!.trim(),
                              style: const TextStyle(
                                fontSize: 10.5,
                                color: AppColor.lightTextSecondary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ],

                      // Row 3: Designation · Company
                      if (hasDesignationOrCompany) ...[
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            const Icon(
                              Icons.business_center_rounded,
                              size: 10,
                              color: AppColor.lightTextSecondary,
                            ),
                            const SizedBox(width: 3),
                            Expanded(
                              child: Text(
                                [
                                  if (entry.designation != null &&
                                      entry.designation!.trim().isNotEmpty)
                                    entry.designation!.trim(),
                                  if (entry.companyName != null &&
                                      entry.companyName!.trim().isNotEmpty)
                                    entry.companyName!.trim(),
                                ].join(' · '),
                                style: const TextStyle(
                                  fontSize: 10.5,
                                  color: AppColor.lightTextSecondary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],

                      // Row 4: Category (Gradient Colored Text, No Background)
                      if (hasCategory) ...[
                        const SizedBox(height: 2.5),
                        ShaderMask(
                          blendMode: BlendMode.srcIn,
                          shaderCallback: (bounds) => AppColor.brandGradient.createShader(
                            Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.sell_outlined,
                                size: 9.0,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 3.0),
                              Flexible(
                                child: Text(
                                  entry.category!.trim(),
                                  style: const TextStyle(
                                    fontSize: 10.0,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                    letterSpacing: 0.1,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 6),

                // ── Right Corner: Coins & Impact badge ──
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isImpact) ...[
                      // Primary Impact Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFDF4FF),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: const Color(0xFFF0ABFC),
                            width: 0.8,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.auto_awesome_rounded,
                              size: 12,
                              color: Color(0xFFC026D3),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _formatImpact(entry.impactCount ?? entry.coins),
                              style: const TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFFC026D3),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (entry.coins > 0) ...[
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColor.lightSurfaceMuted,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: AppColor.lightBorder.withValues(alpha: 0.8),
                              width: 0.6,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const CoinStackIcon(
                                size: 10,
                                color: AppColor.primaryBlue,
                              ),
                              const SizedBox(width: 3),
                              Text(
                                _formatCoins(entry.coins),
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.primaryBlue,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ] else ...[
                      // Primary Coin Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColor.lightSurfaceMuted,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: AppColor.lightBorder.withValues(alpha: 0.8),
                            width: 0.8,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const CoinStackIcon(
                              size: 13,
                              color: AppColor.primaryBlue,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _formatCoins(entry.coins),
                              style: const TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w500,
                                color: AppColor.primaryBlue,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Optional Secondary Impact badge
                      if (hasImpact) ...[
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColor.lightSurfaceMuted,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: AppColor.lightBorder.withValues(alpha: 0.8),
                              width: 0.6,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.auto_awesome_rounded,
                                size: 10,
                                color: Color(0xFFD946EF),
                              ),
                              const SizedBox(width: 3),
                              Text(
                                _formatImpact(entry.impactCount!),
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFFD946EF),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ],
                ),
            ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRankBadge(bool isTopTen) {
    return Container(
      padding: const EdgeInsets.all(2.5),
      constraints: const BoxConstraints(
        minWidth: 19,
        minHeight: 19,
      ),
      decoration: BoxDecoration(
        gradient: isTopTen
            ? const LinearGradient(
                colors: [Color(0xFF1D4ED8), Color(0xFF3B82F6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : const LinearGradient(
                colors: [Color(0xFF64748B), Color(0xFF475569)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 1.4),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Center(
        child: Text(
          '${entry.rank}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 9.5,
            fontWeight: FontWeight.w500,
            height: 1.0,
          ),
        ),
      ),
    );
  }

  String _formatCoins(int number) {
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

  String _formatImpact(int number) {
    if (number >= 1000000000) {
      final val = (number / 1000000000).toStringAsFixed(1);
      return '${val.endsWith('.0') ? val.substring(0, val.length - 2) : val}B';
    }
    if (number >= 1000000) {
      final val = (number / 1000000).toStringAsFixed(1);
      return '${val.endsWith('.0') ? val.substring(0, val.length - 2) : val}M';
    }
    if (number >= 10000) {
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
}
