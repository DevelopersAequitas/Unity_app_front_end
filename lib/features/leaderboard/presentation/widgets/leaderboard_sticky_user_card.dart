import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/widgets/app_avatar.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../profile/presentation/bloc/profile_bloc.dart';
import '../../domain/entities/leaderboard_entry_entity.dart';
import 'coin_badge.dart';

class LeaderboardStickyUserCard extends StatelessWidget {
  final LeaderboardEntryEntity userEntry;
  final bool isImpact;

  const LeaderboardStickyUserCard({
    super.key,
    required this.userEntry,
    this.isImpact = false,
  });

  void _navigateToProfile(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.profile);
  }

  @override
  Widget build(BuildContext context) {
    // Fallback to globally cached profile/auth state if userEntry has missing fields
    final profile = context.read<ProfileBloc?>()?.state.profile;
    final authUser = context.read<AuthBloc?>()?.state.user;

    final profileDisplayName = profile?.displayName;
    final profileCityName = profile?.city?.name;
    final profileBizCity = profile?.businessCity;
    final profileCompany = profile?.companyName;
    final profileDesignation = profile?.designation;
    final profileBizCat = profile?.businessCategory;
    final profileMainCat = profile?.mainBusinessCategory;

    final effectiveName = (userEntry.name.trim().isNotEmpty &&
            userEntry.name != 'Peers Member' &&
            userEntry.name != 'You')
        ? userEntry.name.trim()
        : (profileDisplayName != null && profileDisplayName.trim().isNotEmpty
            ? profileDisplayName.trim()
            : (authUser?.effectiveDisplayName ?? 'You'));

    final effectiveAvatar = (userEntry.profilePhotoUrl != null &&
            userEntry.profilePhotoUrl!.trim().isNotEmpty)
        ? userEntry.profilePhotoUrl!.trim()
        : (profile?.profilePhotoUrl ?? authUser?.avatarUrl);

    final effectiveCity = (userEntry.city != null && userEntry.city!.trim().isNotEmpty)
        ? userEntry.city!.trim()
        : (profileCityName != null && profileCityName.trim().isNotEmpty
            ? profileCityName.trim()
            : (profileBizCity?.trim() ?? ''));

    final effectiveCompany = (userEntry.companyName != null &&
            userEntry.companyName!.trim().isNotEmpty)
        ? userEntry.companyName!.trim()
        : (profileCompany?.trim() ?? '');

    final effectiveDesignation = (userEntry.designation != null &&
            userEntry.designation!.trim().isNotEmpty)
        ? userEntry.designation!.trim()
        : (profileDesignation?.trim() ?? '');

    final effectiveCategory = (userEntry.category != null &&
            userEntry.category!.trim().isNotEmpty)
        ? userEntry.category!.trim()
        : (profileBizCat != null && profileBizCat.trim().isNotEmpty
            ? profileBizCat.trim()
            : (profileMainCat?.trim() ?? ''));

    final effectiveCoins = userEntry.coins > 0
        ? userEntry.coins
        : (profile?.coinsBalance ?? authUser?.coinsBalance ?? 0);

    final effectiveImpact = (userEntry.impactCount != null && userEntry.impactCount! > 0)
        ? userEntry.impactCount
        : (profile?.lifeImpactedCount ?? authUser?.lifeImpactedCount);

    final effectiveIsPro = userEntry.isPro || (profile?.isPro == true);
    final effectiveIsVerified = userEntry.isVerified || (profile?.isVerified == true);

    final hasDesignationOrCompany =
        effectiveDesignation.isNotEmpty || effectiveCompany.isNotEmpty;
    final hasCity = effectiveCity.isNotEmpty;
    final hasCategory = effectiveCategory.isNotEmpty;
    final hasImpact = effectiveImpact != null && effectiveImpact > 0;
    final isTopTen = userEntry.rank > 0 && userEntry.rank <= 10;

    return Material(
      color: Colors.white,
      elevation: 0,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
          border: const Border(
            top: BorderSide(
              color: Color(0xFFE2E8F0),
              width: 1.0,
            ),
          ),
        ),
        padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFF3B82F6).withValues(alpha: 0.35),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF1D4ED8).withValues(alpha: 0.08),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
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
                        imageUrl: effectiveAvatar,
                        name: effectiveName,
                        size: 38,
                        showOnlineBadge: false,
                        isPro: effectiveIsPro,
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
                        // Row 1: UPPERCASE Name + verified + YOU badge + PRO badge
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                effectiveName.toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.lightTextPrimary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (effectiveIsVerified) ...[
                              const SizedBox(width: 3),
                              const Icon(
                                Icons.verified_rounded,
                                size: 13,
                                color: AppColor.primaryBlue,
                              ),
                            ],
                            const SizedBox(width: 4),
                            // YOU Badge
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 5,
                                vertical: 1.5,
                              ),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF1D4ED8), Color(0xFFE11D48)],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'YOU',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 8,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.4,
                                ),
                              ),
                            ),
                            if (effectiveIsPro) ...[
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
                                effectiveCity,
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
                                    if (effectiveDesignation.isNotEmpty)
                                      effectiveDesignation,
                                    if (effectiveCompany.isNotEmpty)
                                      effectiveCompany,
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
                                    effectiveCategory,
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
                            color: const Color(0xFFEFF6FF),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: const Color(0xFFBFDBFE),
                              width: 0.8,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.person_rounded,
                                size: 12,
                                color: AppColor.primaryBlue,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                _formatImpact(effectiveImpact ?? effectiveCoins),
                                style: const TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.primaryBlue,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (effectiveCoins > 0) ...[
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
                                  _formatCoins(effectiveCoins),
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
                            color: const Color(0xFFEFF6FF),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: const Color(0xFFBFDBFE),
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
                                _formatCoins(effectiveCoins),
                                style: const TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.primaryBlue,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Optional Impact badge
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
                                  Icons.person_rounded,
                                  size: 10,
                                  color: AppColor.primaryBlue,
                                ),
                                const SizedBox(width: 3),
                                Text(
                                  _formatImpact(effectiveImpact),
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
                      ],
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

  Widget _buildRankBadge(bool isTopTen) {
    final rankString = userEntry.rank > 0 ? '${userEntry.rank}' : '--';
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
          rankString,
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
