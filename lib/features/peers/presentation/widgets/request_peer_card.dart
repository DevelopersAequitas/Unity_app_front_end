import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/widgets/app_avatar.dart';
import '../../domain/entities/peer_request_entity.dart';

class RequestPeerCard extends StatelessWidget {
  final PeerRequestEntity request;
  final bool isSent;
  final VoidCallback onAccept;
  final VoidCallback onDecline;
  final VoidCallback onCancel;
  final VoidCallback onBookmark;
  final VoidCallback? onTap;

  const RequestPeerCard({
    super.key,
    required this.request,
    this.isSent = false,
    required this.onAccept,
    required this.onDecline,
    required this.onCancel,
    required this.onBookmark,
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
                _buildHeader(context),
                const SizedBox(height: 12),
                _buildActionRow(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final peer = request.peer;
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
                ShaderMask(
                  blendMode: BlendMode.srcIn,
                  shaderCallback: (bounds) =>
                      AppColor.brandGradient.createShader(
                    Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.sell_outlined,
                        size: 9,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 3),
                      Flexible(
                        child: Text(
                          peer.category!.trim(),
                          style: const TextStyle(
                            fontSize: 9.5,
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
      ],
    );
  }

  Widget _buildActionRow(BuildContext context) {
    if (isSent) {
      return Row(
        children: [
          Expanded(
            child: Container(
              height: 28,
              decoration: BoxDecoration(
                color: AppColor.lightSurface,
                borderRadius: BorderRadius.circular(7),
                border: Border.all(color: AppColor.error.withValues(alpha: 0.5)),
              ),
              child: Material(
                color: AppColor.transparent,
                child: InkWell(
                  onTap: onCancel,
                  borderRadius: BorderRadius.circular(7),
                  child: const Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.close_rounded,
                          size: 13,
                          color: AppColor.error,
                        ),
                        SizedBox(width: 3),
                        Text(
                          'CANCEL REQUEST',
                          style: TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.2,
                            color: AppColor.error,
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
          _buildBookmarkButton(),
        ],
      );
    }

    return Row(
      children: [
        Expanded(
          flex: 4,
          child: Container(
            height: 28,
            decoration: BoxDecoration(
              color: AppColor.primaryBlue,
              borderRadius: BorderRadius.circular(7),
            ),
            child: Material(
              color: AppColor.transparent,
              child: InkWell(
                onTap: onAccept,
                borderRadius: BorderRadius.circular(7),
                child: const Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle_outline_rounded,
                          color: Colors.white, size: 13),
                      SizedBox(width: 3),
                      Text(
                        'ACCEPT',
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.2,
                          color: Colors.white,
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
                onTap: onDecline,
                borderRadius: BorderRadius.circular(7),
                child: const Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.cancel_outlined,
                        size: 13,
                        color: AppColor.lightTextPrimary,
                      ),
                      SizedBox(width: 3),
                      Text(
                        'DECLINE',
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
        _buildBookmarkButton(),
      ],
    );
  }

  Widget _buildBookmarkButton() {
    final peer = request.peer;
    return Container(
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
    );
  }
}
