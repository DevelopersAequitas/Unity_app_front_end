import 'package:flutter/material.dart';
import 'package:unity_app/core/router/app_router.dart';
import 'package:unity_app/core/theme/app_color.dart';
import 'package:unity_app/core/theme/app_typography.dart';
import 'package:unity_app/core/utils/app_date_formatter.dart';
import 'package:unity_app/core/widgets/app_avatar.dart';
import 'package:unity_app/core/widgets/app_gradient_text.dart';
import 'package:unity_app/features/p2p_meetings/domain/entities/p2p_meeting_request_entity.dart';
import 'package:unity_app/features/peers/domain/entities/peer_entity.dart';

class P2pRequestCard extends StatelessWidget {
  final P2pMeetingRequestEntity request;
  final bool isInbox;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;
  final VoidCallback? onReschedule;
  final VoidCallback? onCancel;

  const P2pRequestCard({
    super.key,
    required this.request,
    required this.isInbox,
    this.onAccept,
    this.onReject,
    this.onReschedule,
    this.onCancel,
  });

  void _onPeerTap(BuildContext context) {
    final peerId = isInbox ? request.requesterId : request.inviteeId;
    if (peerId != null && peerId.isNotEmpty) {
      Navigator.pushNamed(
        context,
        AppRoutes.peerProfile,
        arguments: peerId,
      );
    }
  }

  void _onLogMeeting(BuildContext context) {
    final peerId = isInbox ? request.requesterId : request.inviteeId;
    final peerName = isInbox ? request.requesterName : request.inviteeName;
    final peerPhoto = isInbox ? request.requesterPhotoUrl : request.inviteePhotoUrl;
    final peerDesignation =
        isInbox ? request.requesterDesignation : request.inviteeDesignation;
    final peerCompany =
        isInbox ? request.requesterCompany : request.inviteeCompany;
    final peerCity = isInbox ? request.requesterCity : request.inviteeCity;
    final peerCategory =
        isInbox ? request.requesterCategory : request.inviteeCategory;

    final peer = PeerEntity(
      id: peerId ?? '',
      displayName: peerName,
      profilePhotoUrl: peerPhoto,
      designation: peerDesignation,
      companyName: peerCompany,
      city: peerCity,
      category: peerCategory,
    );

    DateTime? parsedDate = AppDateFormatter.parseUtc(request.scheduledAt);

    Navigator.pushNamed(
      context,
      AppRoutes.addP2pMeeting,
      arguments: {
        'peer': peer,
        'date': parsedDate,
        'place': request.place,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final peerName = isInbox ? request.requesterName : request.inviteeName;
    final peerPhoto = isInbox ? request.requesterPhotoUrl : request.inviteePhotoUrl;
    final designation =
        (isInbox ? request.requesterDesignation : request.inviteeDesignation)?.trim() ?? '';
    final company =
        (isInbox ? request.requesterCompany : request.inviteeCompany)?.trim() ?? '';
    final city =
        (isInbox ? request.requesterCity : request.inviteeCity)?.trim() ?? '';
    final category =
        (isInbox ? request.requesterCategory : request.inviteeCategory)?.trim() ?? '';
    final isPro = isInbox ? request.isRequesterPro : request.isInviteePro;
    final location = request.place?.trim() ?? '';
    final message = request.message?.trim() ?? '';

    final subLine = [
      if (designation.isNotEmpty) designation,
      if (company.isNotEmpty) company,
    ].join(' · ');

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColor.lightSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColor.lightBorder, width: 0.9),
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withValues(alpha: 0.025),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => _onPeerTap(context),
                child: AppAvatar(
                  imageUrl: peerPhoto,
                  name: peerName,
                  size: 42,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => _onPeerTap(context),
                      child: Row(
                        children: [
                          Flexible(
                            child: Text(
                              peerName.toUpperCase(),
                              style: AppTypography.titleMedium.copyWith(
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                                letterSpacing: 0.3,
                                color: AppColor.lightTextPrimary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (isPro) ...[
                            const SizedBox(width: 5),
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
                    ),
                    if (subLine.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        subLine,
                        style: AppTypography.bodySmall.copyWith(
                          fontSize: 11,
                          color: AppColor.lightTextSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    if (category.isNotEmpty) ...[
                      const SizedBox(height: 1.5),
                      AppGradientText(
                        category,
                        style: const TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    if (city.isNotEmpty) ...[
                      const SizedBox(height: 1.5),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            size: 10.5,
                            color: AppColor.lightTextTertiary,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            city,
                            style: AppTypography.labelSmall.copyWith(
                              fontSize: 10.5,
                              color: AppColor.lightTextTertiary,
                            ),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 2),
                    Text(
                      isInbox ? 'Sent you a meeting invite' : 'You sent meeting invite',
                      style: AppTypography.labelSmall.copyWith(
                        fontSize: 10,
                        color: AppColor.lightTextTertiary,
                      ),
                    ),
                  ],
                ),
              ),
              _StatusBadge(status: request.status),
            ],
          ),
          if (request.scheduledAt != null && request.scheduledAt!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              decoration: BoxDecoration(
                color: AppColor.lightBackground,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.access_time_rounded,
                    size: 13,
                    color: AppColor.lightTextSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    AppDateFormatter.formatDateTime(request.scheduledAt),
                    style: AppTypography.bodySmall.copyWith(
                      fontSize: 11.5,
                      color: AppColor.lightTextSecondary,
                    ),
                  ),
                  if (location.isNotEmpty) ...[
                    const SizedBox(width: 8),
                    const Text('·', style: TextStyle(color: AppColor.lightTextTertiary)),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.location_on_outlined,
                      size: 13,
                      color: AppColor.lightTextSecondary,
                    ),
                    const SizedBox(width: 3),
                    Expanded(
                      child: Text(
                        location,
                        style: AppTypography.bodySmall.copyWith(
                          fontSize: 11.5,
                          color: AppColor.lightTextSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
          if (message.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              '“$message”',
              style: AppTypography.bodySmall.copyWith(
                fontSize: 12,
                color: AppColor.lightTextPrimary.withValues(alpha: 0.88),
                height: 1.35,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          if (request.isPending ||
              request.isAccepted ||
              request.isScheduled ||
              request.isCompleted) ...[
            const SizedBox(height: 10),
            _ActionButtonsRow(
              isInbox: isInbox,
              status: request.status.toLowerCase(),
              onAccept: onAccept,
              onReject: onReject,
              onReschedule: onReschedule,
              onCancel: onCancel,
              onLogMeeting: () => _onLogMeeting(context),
            ),
          ],
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color bg = AppColor.lightBorder;
    Color fg = AppColor.lightTextSecondary;
    if (status == 'accepted' || status == 'scheduled') {
      bg = AppColor.success.withValues(alpha: 0.12);
      fg = const Color(0xFF059669);
    } else if (status == 'pending') {
      bg = AppColor.primaryBlue.withValues(alpha: 0.12);
      fg = AppColor.primaryBlue;
    } else if (status == 'reschedule_requested') {
      bg = AppColor.warning.withValues(alpha: 0.12);
      fg = const Color(0xFFD97706);
    } else if (status == 'rejected' || status == 'cancelled') {
      bg = AppColor.error.withValues(alpha: 0.12);
      fg = AppColor.error;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        status.replaceAll('_', ' ').toUpperCase(),
        style: TextStyle(
          fontSize: 9.5,
          fontWeight: FontWeight.w500,
          color: fg,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

class _ActionButtonsRow extends StatelessWidget {
  final bool isInbox;
  final String status;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;
  final VoidCallback? onReschedule;
  final VoidCallback? onCancel;
  final VoidCallback? onLogMeeting;

  const _ActionButtonsRow({
    required this.isInbox,
    required this.status,
    this.onAccept,
    this.onReject,
    this.onReschedule,
    this.onCancel,
    this.onLogMeeting,
  });

  @override
  Widget build(BuildContext context) {
    if (isInbox && status == 'pending') {
      return Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: onReject,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColor.error, width: 0.8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(vertical: 7),
              ),
              child: const Text(
                'Decline',
                style: TextStyle(
                  color: AppColor.error,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: OutlinedButton(
              onPressed: onReschedule,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColor.primaryBlue, width: 0.8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(vertical: 7),
              ),
              child: const Text(
                'Reschedule',
                style: TextStyle(
                  color: AppColor.primaryBlue,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ElevatedButton(
              onPressed: onAccept,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.success,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(vertical: 7),
                elevation: 0,
              ),
              child: const Text(
                'Accept',
                style: TextStyle(
                  color: AppColor.white,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      );
    }

    if (!isInbox && (status == 'pending' || status == 'reschedule_requested')) {
      return Align(
        alignment: Alignment.centerRight,
        child: OutlinedButton(
          onPressed: onCancel,
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: AppColor.error, width: 0.8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          ),
          child: const Text(
            'Cancel Invite',
            style: TextStyle(
              color: AppColor.error,
              fontSize: 11.5,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    }

    if (status == 'accepted' ||
        status == 'scheduled' ||
        status == 'completed' ||
        status == 'approved' ||
        status == 'confirmed') {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: onLogMeeting,
          icon: const Icon(Icons.check_circle_outline, size: 15, color: Colors.white),
          label: const Text(
            'Log Completed Meeting',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColor.primaryBlue,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            padding: const EdgeInsets.symmetric(vertical: 8),
            elevation: 0,
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
