import 'package:flutter/material.dart';
import 'package:unity_app/core/theme/app_color.dart';
import 'package:unity_app/core/widgets/app_avatar.dart';
import 'package:unity_app/features/peers/domain/entities/peer_entity.dart';

class PeerCard extends StatelessWidget {
  final PeerEntity peer;
  final bool isCurrentUser;
  final VoidCallback? onConnect;
  final VoidCallback? onFollow;
  final VoidCallback onMessage;
  final VoidCallback onBookmark;
  final VoidCallback? onScheduleP2P;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? margin;
  final bool showBorder;

  const PeerCard({
    super.key,
    required this.peer,
    this.isCurrentUser = false,
    this.onConnect,
    this.onFollow,
    required this.onMessage,
    required this.onBookmark,
    this.onScheduleP2P,
    this.onTap,
    this.margin,
    this.showBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 14, vertical: 2.5),
      decoration: BoxDecoration(
        color: showBorder ? AppColor.lightSurface : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: showBorder ? Border.all(color: AppColor.lightBorder) : null,
        boxShadow: showBorder
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ]
            : null,
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
                if (!isCurrentUser) ...[
                  const SizedBox(height: 6),
                  _buildActions(context),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final hasDesignationOrCompany =
        (peer.designation != null && peer.designation!.trim().isNotEmpty) ||
        (peer.companyName != null && peer.companyName!.trim().isNotEmpty);
    final hasCity = peer.city != null && peer.city!.trim().isNotEmpty;
    final hasCategory = peer.category != null && peer.category!.trim().isNotEmpty;

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
              // Row 1: Name + verified + YOU
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
                  if (isCurrentUser) ...[
                    const SizedBox(width: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 1),
                      decoration: BoxDecoration(
                        color: AppColor.primaryBlue.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'YOU',
                        style: TextStyle(
                          fontSize: 8.5,
                          fontWeight: FontWeight.w500,
                          color: AppColor.primaryBlue,
                        ),
                      ),
                    ),
                  ],
                ],
              ),

              // Row 2: Designation · Company
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
                          if (peer.designation != null && peer.designation!.trim().isNotEmpty)
                            peer.designation!.trim(),
                          if (peer.companyName != null && peer.companyName!.trim().isNotEmpty)
                            peer.companyName!.trim(),
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

              // Row 3: City · Category
              if (hasCity || hasCategory) ...[
                const SizedBox(height: 2.5),
                Row(
                  children: [
                    if (hasCity) ...[
                      const Icon(
                        Icons.location_on_rounded,
                        size: 10,
                        color: AppColor.lightTextSecondary,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        peer.city!.trim(),
                        style: const TextStyle(
                          fontSize: 10.5,
                          color: AppColor.lightTextSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    if (hasCity && hasCategory) ...[
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4),
                        child: Text(
                          '·',
                          style: TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w500,
                            color: AppColor.lightTextSecondary,
                          ),
                        ),
                      ),
                    ],
                    if (hasCategory) ...[
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                          decoration: BoxDecoration(
                            color: AppColor.badgeBlueBg,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: AppColor.primaryBlue.withValues(alpha: 0.15),
                              width: 0.8,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.sell_outlined,
                                size: 8.5,
                                color: AppColor.primaryBlue,
                              ),
                              const SizedBox(width: 2.5),
                              Flexible(
                                child: Text(
                                  peer.category!.trim(),
                                  style: const TextStyle(
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.w500,
                                    color: AppColor.primaryBlue,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ],
          ),
        ),

        // Right Corner: Impact Badge
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
          const Icon(
            Icons.auto_awesome_rounded,
            size: 13,
            color: Color(0xFFD946EF),
          ),
          const SizedBox(width: 3),
          Text(
            '$count',
            style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: Color(0xFFD946EF),
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
    final hasScheduleP2P = isConnected && onScheduleP2P != null;

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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          peer.isFollowing
                              ? Icons.check_rounded
                              : Icons.person_add_alt_1_outlined,
                          size: 11.5,
                          color: AppColor.primaryBlue,
                        ),
                        const SizedBox(width: 2.5),
                        Flexible(
                          child: Text(
                            peer.isFollowing ? 'FOLLOWING' : 'FOLLOW',
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.1,
                              color: AppColor.primaryBlue,
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
                onTap: onMessage,
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
        const SizedBox(width: 4),

        // 4. Bookmark Button
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
