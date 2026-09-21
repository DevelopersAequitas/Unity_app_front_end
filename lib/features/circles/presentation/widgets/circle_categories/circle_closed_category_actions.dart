import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/router/app_router.dart';
import '../../../../../core/theme/app_color.dart';
import '../../../../../core/widgets/app_snack_bar.dart';
import '../../../../peers/domain/entities/peer_entity.dart';
import '../../../../peers/presentation/bloc/peers_bloc.dart';
import '../../../../peers/presentation/bloc/peers_event.dart';

class CircleClosedCategoryActions extends StatelessWidget {
  final PeerEntity peer;
  final bool isDark;
  final Color borderColor;
  final Color secondaryText;

  const CircleClosedCategoryActions({
    super.key,
    required this.peer,
    required this.isDark,
    required this.borderColor,
    required this.secondaryText,
  });

  @override
  Widget build(BuildContext context) {
    final statusLower = peer.connectionStatus.toLowerCase();
    final isPending = peer.isRequested ||
        statusLower == 'pending' ||
        statusLower == 'pending_sent' ||
        statusLower == 'requested';
    final isConnected = peer.isConnected ||
        statusLower == 'connected' ||
        statusLower == 'approved' ||
        statusLower == 'accepted';

    return Row(
      children: [
        // 1. Left Button: CONNECT / REQUESTED / SCHEDULE
        Expanded(
          child: Container(
            height: 26,
            decoration: BoxDecoration(
              gradient: (!isPending) ? AppColor.brandGradient : null,
              color: isPending
                  ? (isDark
                      ? AppColor.darkSurfaceSubtle
                      : AppColor.lightSurfaceSubtle)
                  : null,
              borderRadius: BorderRadius.circular(6),
              border: isPending ? Border.all(color: borderColor, width: 0.8) : null,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: isConnected
                    ? () {
                        AppSnackBar.showInfo(
                          context,
                          'Scheduling P2P with ${peer.displayName}',
                        );
                      }
                    : ((!isPending)
                        ? () {
                            context.read<PeersBloc>().add(
                                  PeerConnectRequested(peer.id),
                                );
                          }
                        : null),
                borderRadius: BorderRadius.circular(6),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (isConnected) ...[
                        const Icon(
                          Icons.calendar_month_rounded,
                          color: Colors.white,
                          size: 11,
                        ),
                        const SizedBox(width: 2),
                        const Flexible(
                          child: Text(
                            'SCHEDULE',
                            style: TextStyle(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.1,
                              color: Colors.white,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ] else ...[
                        if (!isPending) ...[
                          const Icon(
                            Icons.person_add_outlined,
                            color: Colors.white,
                            size: 11,
                          ),
                          const SizedBox(width: 2),
                        ],
                        Flexible(
                          child: Text(
                            isPending ? 'REQUESTED' : 'CONNECT',
                            style: TextStyle(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.1,
                              color: (!isPending)
                                  ? Colors.white
                                  : secondaryText,
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
            height: 26,
            decoration: BoxDecoration(
              gradient: AppColor.brandGradient,
              borderRadius: BorderRadius.circular(6),
            ),
            padding: const EdgeInsets.all(1.0),
            child: Container(
              decoration: BoxDecoration(
                color: peer.isFollowing
                    ? (isDark
                        ? AppColor.primaryBlue.withValues(alpha: 0.2)
                        : const Color(0xFFEFF4FF))
                    : (isDark ? AppColor.darkSurface : Colors.white),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    context.read<PeersBloc>().add(
                          PeerFollowToggled(
                            peerId: peer.id,
                            isCurrentlyFollowing: peer.isFollowing,
                          ),
                        );
                  },
                  borderRadius: BorderRadius.circular(5),
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
                            size: 11,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 2),
                          Flexible(
                            child: Text(
                              peer.isFollowing ? 'FOLLOWING' : 'FOLLOW',
                              style: const TextStyle(
                                fontSize: 9.5,
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
            height: 26,
            decoration: BoxDecoration(
              color: isDark ? AppColor.darkSurfaceSubtle : Colors.white,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: borderColor, width: 0.8),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => Navigator.pushNamed(
                  context,
                  AppRoutes.directChat,
                  arguments: {
                    'peer_id': peer.id,
                    'peer_name': peer.displayName,
                    'peer_avatar': peer.profilePhotoUrl,
                  },
                ),
                borderRadius: BorderRadius.circular(6),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.chat_bubble_outline_rounded,
                        size: 11,
                        color: isDark
                            ? AppColor.darkTextPrimary
                            : AppColor.lightTextPrimary,
                      ),
                      const SizedBox(width: 2),
                      Flexible(
                        child: Text(
                          'MESSAGE',
                          style: TextStyle(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.1,
                            color: isDark
                                ? AppColor.darkTextPrimary
                                : AppColor.lightTextPrimary,
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
          width: 26,
          height: 26,
          decoration: BoxDecoration(
            color: isDark ? AppColor.darkSurfaceSubtle : Colors.white,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: borderColor, width: 0.8),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                context.read<PeersBloc>().add(
                      PeerBookmarkToggled(
                        peerId: peer.id,
                        isCurrentlyBookmarked: peer.isBookmarked,
                      ),
                    );
              },
              borderRadius: BorderRadius.circular(6),
              child: Icon(
                peer.isBookmarked
                    ? Icons.bookmark_rounded
                    : Icons.bookmark_border_rounded,
                size: 13,
                color: peer.isBookmarked
                    ? AppColor.primaryBlue
                    : (isDark
                        ? AppColor.darkTextPrimary
                        : AppColor.lightTextPrimary),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
