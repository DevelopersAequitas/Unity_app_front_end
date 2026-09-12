import 'package:flutter/material.dart';
import 'package:unity_app/core/theme/app_color.dart';
import 'package:unity_app/core/widgets/app_snack_bar.dart';
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
    final isPending = profile.isRequested || status == 'pending' || status == 'requested' || status == 'pending_sent';
    final isConnected = profile.isConnected || status == 'connected' || status == 'approved';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: SizedBox(
              height: 36,
              child: ElevatedButton.icon(
                onPressed: isPending
                    ? onCancelRequest
                    : (isConnected
                        ? () => AppSnackBar.showInfo(context, 'Saying Hi to ${profile.displayName} 👋')
                        : onConnect),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  backgroundColor: isPending ? AppColor.lightSurfaceSubtle : AppColor.primaryBlue,
                  foregroundColor: isPending ? AppColor.lightTextSecondary : Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: isPending ? const BorderSide(color: AppColor.lightBorder) : BorderSide.none,
                  ),
                ),
                icon: Icon(
                  isPending
                      ? Icons.schedule_rounded
                      : (isConnected ? Icons.waving_hand_outlined : Icons.person_add_outlined),
                  size: 16,
                  color: isPending ? AppColor.lightTextSecondary : Colors.white,
                ),
                label: Text(
                  isPending ? 'CANCEL REQUEST' : (isConnected ? 'SAY HI' : 'CONNECT'),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.2,
                    color: isPending ? AppColor.lightTextSecondary : Colors.white,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 5,
            child: SizedBox(
              height: 36,
              child: OutlinedButton.icon(
                onPressed: onFollowToggle,
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  backgroundColor: profile.isFollowing ? AppColor.primaryBlue.withValues(alpha: 0.08) : Colors.transparent,
                  side: BorderSide(color: profile.isFollowing ? AppColor.primaryBlue : AppColor.lightBorder),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                icon: Icon(
                  profile.isFollowing ? Icons.check_rounded : Icons.person_add_alt_1_outlined,
                  size: 16,
                  color: profile.isFollowing ? AppColor.primaryBlue : AppColor.lightTextPrimary,
                ),
                label: Text(
                  profile.isFollowing ? 'FOLLOWING' : 'FOLLOW',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.2,
                    color: profile.isFollowing ? AppColor.primaryBlue : AppColor.lightTextPrimary,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            height: 36,
            width: 36,
            decoration: BoxDecoration(
              color: AppColor.lightSurface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColor.lightBorder),
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              onPressed: () => AppSnackBar.showInfo(context, 'Schedule P2P with ${profile.displayName}'),
              icon: const Icon(Icons.calendar_month_outlined, size: 18, color: AppColor.lightTextPrimary),
            ),
          ),
        ],
      ),
    );
  }
}
