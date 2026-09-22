import 'package:flutter/material.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/utils/paywall_gate_helper.dart';
import '../../../../core/widgets/app_avatar.dart';
import '../../../../core/widgets/app_gradient_text.dart';
import '../../domain/entities/geo_peer_entity.dart';

class NearMePeerCard extends StatelessWidget {
  final GeoPeerEntity peer;
  final VoidCallback onConnect;
  final VoidCallback? onFollow;
  final VoidCallback? onMessage;
  final VoidCallback? onScheduleP2P;
  final VoidCallback? onBookmark;
  final VoidCallback? onTap;

  const NearMePeerCard({
    super.key,
    required this.peer,
    required this.onConnect,
    this.onFollow,
    this.onMessage,
    this.onScheduleP2P,
    this.onBookmark,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 4.5),
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
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 12),
                _buildActions(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppAvatar(
          imageUrl: peer.profilePhotoUrl,
          name: peer.displayName,
          size: 38,
          showOnlineBadge: true,
          isOnline: peer.isOnline,
          isPro: peer.isPro,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      peer.displayName.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500,
                        color: AppColor.lightTextPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (peer.isVerified) ...[
                    const SizedBox(width: 3),
                    const Icon(
                      Icons.verified_rounded,
                      size: 13,
                      color: AppColor.primaryBlue,
                    ),
                  ],
                  if (peer.isPro) ...[
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
              if (peer.city != null && peer.city!.isNotEmpty) ...[
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_rounded,
                      size: 10,
                      color: AppColor.lightTextSecondary,
                    ),
                    const SizedBox(width: 2),
                    Expanded(
                      child: Text(
                        peer.city!,
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
              if (peer.designation != null || peer.companyName != null) ...[
                Row(
                  children: [
                    const Icon(
                      Icons.business_center_rounded,
                      size: 10,
                      color: AppColor.lightTextSecondary,
                    ),
                    const SizedBox(width: 2),
                    Expanded(
                      child: Text(
                        [
                          if (peer.designation != null) peer.designation!,
                          if (peer.companyName != null) peer.companyName!,
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
              if (peer.category != null && peer.category!.isNotEmpty) ...[
                const SizedBox(height: 2),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                  decoration: BoxDecoration(
                    color: AppColor.badgeBlueBg,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: AppColor.primaryBlue.withValues(alpha: 0.15),
                      width: 0.8,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ShaderMask(
                        blendMode: BlendMode.srcIn,
                        shaderCallback: (bounds) =>
                            AppColor.brandGradient.createShader(
                          Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                        ),
                        child: const Icon(
                          Icons.sell_outlined,
                          size: 9,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 3),
                      Flexible(
                        child: AppGradientText(
                          peer.category!,
                          style: const TextStyle(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w500,
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
        if (peer.lifeImpactedCount != null) ...[
          const SizedBox(width: 6),
          _buildImpactBadge(peer.lifeImpactedCount!),
        ],
      ],
    );
  }

  Widget _buildImpactBadge(int count) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2.5),
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
          ShaderMask(
            shaderCallback: (bounds) =>
                AppColor.brandGradient.createShader(bounds),
            child: const Icon(
              Icons.person_rounded,
              size: 13,
              color: AppColor.white,
            ),
          ),
          const SizedBox(width: 3),
          ShaderMask(
            shaderCallback: (bounds) =>
                AppColor.brandGradient.createShader(bounds),
            child: Text(
              '$count',
              style: const TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w500,
                color: AppColor.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    final statusLower = peer.connectionStatus.toLowerCase();
    final isPending = peer.isRequested ||
        statusLower == 'pending' ||
        statusLower == 'pending_sent' ||
        statusLower == 'requested';
    final isConnected = peer.isConnected ||
        statusLower == 'connected' ||
        statusLower == 'approved' ||
        statusLower == 'accepted';
    final hasScheduleP2P = isConnected;

    return Row(
      children: [
        // 1. Left Button: CONNECT / REQUESTED / SCHEDULE P2P
        Expanded(
          child: Container(
            height: 28,
            decoration: BoxDecoration(
              gradient: (!isPending) ? AppColor.brandGradient : null,
              color: isPending ? AppColor.lightSurfaceSubtle : null,
              borderRadius: BorderRadius.circular(7),
              border: isPending ? Border.all(color: AppColor.lightBorder) : null,
            ),
            child: Material(
              color: AppColor.transparent,
              child: InkWell(
                onTap: hasScheduleP2P
                    ? (onScheduleP2P ??
                        () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.addP2pMeeting,
                            arguments: peer,
                          );
                        })
                    : ((!isPending && !isConnected)
                        ? () {
                            if (!PaywallGateHelper.checkPro(context, message: 'Upgrade to Pro to send connection requests.')) {
                              return;
                            }
                            onConnect();
                          }
                        : null),
                borderRadius: BorderRadius.circular(7),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (hasScheduleP2P) ...[
                        const Icon(
                          Icons.calendar_month_rounded,
                          color: AppColor.white,
                          size: 11.5,
                        ),
                        const SizedBox(width: 2.5),
                        const Flexible(
                          child: Text(
                            'SCHEDULE',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.1,
                              color: AppColor.white,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ] else ...[
                        if (!isPending) ...[
                          const Icon(
                            Icons.person_add_outlined,
                            color: AppColor.white,
                            size: 11.5,
                          ),
                          const SizedBox(width: 2.5),
                        ],
                        Flexible(
                          child: Text(
                            isPending ? 'REQUESTED' : 'CONNECT',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.1,
                              color: (!isPending)
                                  ? AppColor.white
                                  : AppColor.lightTextSecondary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 4),

        // 2. Middle Button: FOLLOW / FOLLOWING (Gradient Border)
        Expanded(
          child: Container(
            height: 28,
            decoration: BoxDecoration(
              gradient: AppColor.brandGradient,
              borderRadius: BorderRadius.circular(7),
            ),
            padding: const EdgeInsets.all(1.0),
            child: Container(
              decoration: BoxDecoration(
                color: peer.isFollowing
                    ? const Color(0xFFEFF4FF)
                    : Colors.white,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Material(
                color: AppColor.transparent,
                child: InkWell(
                  onTap: onFollow,
                  borderRadius: BorderRadius.circular(6),
                  child: Center(
                    child: ShaderMask(
                      blendMode: BlendMode.srcIn,
                      shaderCallback: (bounds) =>
                          AppColor.brandGradient.createShader(
                        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            peer.isFollowing
                                ? Icons.check_rounded
                                : Icons.person_add_alt_1_outlined,
                            size: 11.5,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 2.5),
                          Flexible(
                            child: Text(
                              peer.isFollowing ? 'FOLLOWING' : 'FOLLOW',
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.1,
                                color: Colors.white,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 4),

        // 3. Right Button: MESSAGE
        Expanded(
          child: Container(
            height: 28,
            decoration: BoxDecoration(
              color: AppColor.lightSurface,
              borderRadius: BorderRadius.circular(7),
              border: Border.all(color: AppColor.lightBorder),
            ),
            child: Material(
              color: AppColor.transparent,
              child: InkWell(
                onTap: () {
                  if (!PaywallGateHelper.checkPro(context, message: 'Upgrade to Pro to message peers.')) {
                    return;
                  }
                  if (onMessage != null) {
                    onMessage!();
                  } else {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.directChat,
                      arguments: {
                        'peer_id': peer.id,
                        'peer_name': peer.displayName,
                        'peer_avatar': peer.profilePhotoUrl,
                      },
                    );
                  }
                },
                borderRadius: BorderRadius.circular(7),
                child: const Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.chat_bubble_outline_rounded,
                        size: 11.5,
                        color: AppColor.lightTextPrimary,
                      ),
                      SizedBox(width: 2.5),
                      Flexible(
                        child: Text(
                          'MESSAGE',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.1,
                            color: AppColor.lightTextPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        if (onBookmark != null) ...[
          const SizedBox(width: 4),
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: AppColor.lightSurface,
              borderRadius: BorderRadius.circular(7),
              border: Border.all(color: AppColor.lightBorder),
            ),
            child: Material(
              color: AppColor.transparent,
              child: InkWell(
                onTap: onBookmark,
                borderRadius: BorderRadius.circular(7),
                child: Icon(
                  peer.isBookmarked
                      ? Icons.bookmark_rounded
                      : Icons.bookmark_border_rounded,
                  size: 15,
                  color: peer.isBookmarked
                      ? AppColor.primaryBlue
                      : AppColor.lightTextPrimary,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
