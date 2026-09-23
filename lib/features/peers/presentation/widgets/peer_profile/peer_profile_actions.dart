import 'package:flutter/material.dart';
import 'package:unity_app/core/router/app_router.dart';
import 'package:unity_app/core/theme/app_color.dart';
import 'package:unity_app/core/utils/paywall_gate_helper.dart';
import 'package:unity_app/core/widgets/app_snack_bar.dart';
import 'package:unity_app/core/widgets/offline_prompt_dialog.dart';
import 'package:unity_app/features/peers/domain/entities/peer_entity.dart';
import 'package:unity_app/features/profile/domain/entities/profile_entity.dart';

class PeerProfileActions extends StatelessWidget {
  final ProfileEntity profile;
  final VoidCallback onConnect;
  final VoidCallback onCancelRequest;
  final VoidCallback onFollowToggle;

  const PeerProfileActions({
    super.key,
    required this.profile,
    required this.onConnect,
    required this.onCancelRequest,
    required this.onFollowToggle,
  });

  @override
  Widget build(BuildContext context) {
    final status = profile.connectionStatus.toLowerCase();
    final isPending = profile.isRequested ||
        status == 'pending' ||
        status == 'requested' ||
        status == 'pending_sent';
    final isConnected =
        profile.isConnected || status == 'connected' || status == 'approved';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          // 1. Connect / Say Hi / Cancel Request (Gradient Background)
          Expanded(
            child: SizedBox(
              height: 34,
              child: Container(
                decoration: BoxDecoration(
                  gradient: isPending ? null : AppColor.brandGradient,
                  color: isPending ? AppColor.lightSurfaceSubtle : null,
                  borderRadius: BorderRadius.circular(8),
                  border: isPending
                      ? Border.all(color: AppColor.lightBorder)
                      : null,
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () {
                      if (!OfflineGuard.check(context, actionName: isPending ? 'cancel requests' : (isConnected ? 'chat with peers' : 'send connection requests'))) return;
                      if (profile.isBlocked) {
                        AppSnackBar.showError(
                          context,
                          'You have blocked this peer. Unblock them to interact.',
                        );
                        return;
                      }
                      if (isPending) {
                        onCancelRequest();
                      } else if (isConnected) {
                        if (!PaywallGateHelper.checkPro(context, message: 'Upgrade to Pro to chat with peers.')) {
                          return;
                        }
                        Navigator.pushNamed(
                          context,
                          AppRoutes.directChat,
                          arguments: {
                            'peer_id': profile.id,
                            'peer_name': profile.displayName,
                            'peer_avatar': profile.profilePhotoUrl,
                          },
                        );
                      } else {
                        if (!PaywallGateHelper.checkPro(context, message: 'Upgrade to Pro to send connection requests.')) {
                          return;
                        }
                        onConnect();
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            isPending
                                ? Icons.schedule_rounded
                                : (isConnected
                                    ? Icons.waving_hand_outlined
                                    : Icons.person_add_outlined),
                            size: 14,
                            color: isPending
                                ? AppColor.lightTextSecondary
                                : Colors.white,
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              isPending
                                  ? 'CANCEL'
                                  : (isConnected ? 'SAY HI' : 'CONNECT'),
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.1,
                                color: isPending
                                    ? AppColor.lightTextSecondary
                                    : Colors.white,
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
          const SizedBox(width: 6),

          // 2. Follow / Following (Gradient Border + Gradient Icon & Text)
          Expanded(
            child: SizedBox(
              height: 34,
              child: Container(
                decoration: BoxDecoration(
                  gradient: AppColor.brandGradient,
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(1.2), // Gradient border
                child: Container(
                  decoration: BoxDecoration(
                    color: profile.isFollowing
                        ? const Color(0xFFEFF4FF)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(6.8),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(6.8),
                      onTap: () {
                        if (!OfflineGuard.check(context, actionName: 'follow peers')) return;
                        if (profile.isBlocked) {
                          AppSnackBar.showError(
                            context,
                            'You have blocked this peer. Unblock them to interact.',
                          );
                          return;
                        }
                        onFollowToggle();
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
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
                                profile.isFollowing
                                    ? Icons.check_rounded
                                    : Icons.person_add_alt_1_outlined,
                                size: 14,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  profile.isFollowing ? 'FOLLOWING' : 'FOLLOW',
                                  style: const TextStyle(
                                    fontSize: 11,
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
          ),
          const SizedBox(width: 6),

          // 3. Meeting Schedule (Gradient Background)
          Expanded(
            child: SizedBox(
              height: 34,
              child: Container(
                decoration: BoxDecoration(
                  gradient: AppColor.brandGradient,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () {
                      if (!OfflineGuard.check(context, actionName: 'schedule P2P meetings')) return;
                      if (profile.isBlocked) {
                        AppSnackBar.showError(
                          context,
                          'You have blocked this peer. Unblock them to interact.',
                        );
                        return;
                      }
                      final peer = PeerEntity(
                        id: profile.id,
                        displayName: profile.displayName,
                        firstName: profile.firstName,
                        lastName: profile.lastName,
                        profilePhotoUrl: profile.profilePhotoUrl,
                        city: profile.city?.name,
                        category: profile.mainBusinessCategory ??
                            profile.businessCategory,
                        companyName: profile.companyName,
                        designation: profile.designation,
                        connectionStatus: profile.connectionStatus,
                        isVerified: profile.isVerified,
                        isPro: profile.isPro,
                        isFollowing: profile.isFollowing,
                        isBookmarked: profile.isBookmark,
                      );
                      Navigator.pushNamed(
                        context,
                        AppRoutes.addP2pMeeting,
                        arguments: peer,
                      );
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.calendar_month_outlined,
                            size: 14,
                            color: Colors.white,
                          ),
                          SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              'SCHEDULE',
                              style: TextStyle(
                                fontSize: 11,
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
        ],
      ),
    );
  }
}
