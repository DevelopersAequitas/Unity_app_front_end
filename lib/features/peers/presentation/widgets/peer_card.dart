import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/widgets/app_avatar.dart';
import '../../domain/entities/peer_entity.dart';

class PeerCard extends StatelessWidget {
  final PeerEntity peer;
  final VoidCallback? onConnect;
  final VoidCallback onMessage;
  final VoidCallback onBookmark;
  final VoidCallback? onScheduleP2P;
  final VoidCallback? onTap;

  const PeerCard({
    super.key,
    required this.peer,
    this.onConnect,
    required this.onMessage,
    required this.onBookmark,
    this.onScheduleP2P,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 2.5),
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
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 6),
                _buildActions(),
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
                        fontWeight: FontWeight.w800,
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
                ],
              ),
              const SizedBox(height: 1.5),
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
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                  decoration: BoxDecoration(
                    color: AppColor.badgeBlueBg,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    peer.category!,
                    style: const TextStyle(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w600,
                      color: AppColor.primaryBlue,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
              Icons.auto_awesome_rounded,
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
                fontWeight: FontWeight.w800,
                color: AppColor.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions() {
    final statusLower = peer.connectionStatus.toLowerCase();
    final isPending = statusLower == 'pending' ||
        statusLower == 'pending_sent' ||
        statusLower == 'requested';
    final isConnected = statusLower == 'connected' ||
        statusLower == 'approved' ||
        statusLower == 'accepted' ||
        onScheduleP2P != null;
    final hasScheduleP2P = onScheduleP2P != null;

    return Row(
      children: [
        Expanded(
          flex: 4,
          child: Container(
            height: 28,
            decoration: BoxDecoration(
              gradient: (!isPending && (!isConnected || hasScheduleP2P))
                  ? AppColor.brandGradient
                  : null,
              color: (isPending || (isConnected && !hasScheduleP2P))
                  ? AppColor.lightSurfaceSubtle
                  : null,
              borderRadius: BorderRadius.circular(7),
            ),
            child: Material(
              color: AppColor.transparent,
              child: InkWell(
                onTap: hasScheduleP2P
                    ? onScheduleP2P
                    : ((!isPending && !isConnected) ? onConnect : null),
                borderRadius: BorderRadius.circular(7),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (hasScheduleP2P) ...[
                        const Icon(
                          Icons.calendar_month_rounded,
                          color: AppColor.white,
                          size: 12,
                        ),
                        const SizedBox(width: 3),
                        const Text(
                          'SCHEDULE P2P',
                          style: TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.2,
                            color: AppColor.white,
                          ),
                        ),
                      ] else ...[
                        if (!isPending && !isConnected) ...[
                          const Icon(
                            Icons.add_rounded,
                            color: AppColor.white,
                            size: 13,
                          ),
                          const SizedBox(width: 2),
                        ],
                        Text(
                          isPending
                              ? 'REQUESTED'
                              : (isConnected ? 'CONNECTED' : 'CONNECT'),
                          style: TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.2,
                            color: (!isPending && !isConnected)
                                ? AppColor.white
                                : AppColor.lightTextSecondary,
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
        const SizedBox(width: 5),
        Expanded(
          flex: 4,
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
                onTap: onMessage,
                borderRadius: BorderRadius.circular(7),
                child: const Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.chat_bubble_outline_rounded,
                        size: 12,
                        color: AppColor.lightTextPrimary,
                      ),
                      SizedBox(width: 3),
                      Text(
                        'MESSAGE',
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.2,
                          color: AppColor.lightTextPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 5),
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
    );
  }
}
