import 'package:flutter/material.dart';
import 'package:unity_app/core/router/app_router.dart';
import 'package:unity_app/core/theme/app_color.dart';
import 'package:unity_app/core/theme/app_typography.dart';
import 'package:unity_app/core/widgets/app_avatar.dart';
import 'package:unity_app/core/widgets/app_gradient_text.dart';
import 'package:unity_app/core/utils/app_date_formatter.dart';
import 'package:unity_app/features/p2p_meetings/domain/entities/p2p_meeting_entity.dart';

class P2pCompletedCard extends StatelessWidget {
  final P2pMeetingEntity meeting;
  final VoidCallback onTap;

  const P2pCompletedCard({
    super.key,
    required this.meeting,
    required this.onTap,
  });

  void _onPeerTap(BuildContext context) {
    if (meeting.peerUserId != null && meeting.peerUserId!.isNotEmpty) {
      Navigator.pushNamed(
        context,
        AppRoutes.peerProfile,
        arguments: meeting.peerUserId,
      );
    }
  }

  void _openImagePreview(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(16),
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: InteractiveViewer(
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => Container(
                    padding: const EdgeInsets.all(24),
                    color: Colors.white,
                    child: const Text('Failed to load image'),
                  ),
                ),
              ),
            ),
            IconButton(
              icon: const CircleAvatar(
                backgroundColor: Colors.black54,
                radius: 16,
                child: Icon(Icons.close, color: Colors.white, size: 18),
              ),
              onPressed: () => Navigator.pop(ctx),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateStr = AppDateFormatter.formatDateTime(meeting.createdAt);
    final meetingDateStr = AppDateFormatter.format(meeting.meetingDate);
    final designation = meeting.peerDesignation?.trim() ?? '';
    final company = meeting.peerCompany?.trim() ?? '';
    final city = meeting.peerLocation?.trim() ?? '';
    final category = meeting.peerCategory?.trim() ?? '';
    final location = meeting.meetingPlace?.trim() ?? '';
    final remarks = meeting.remarks?.trim() ?? '';
    final hasMedia = meeting.mediaUrls.isNotEmpty;

    final subLine = [
      if (designation.isNotEmpty) designation,
      if (company.isNotEmpty) company,
    ].join(' · ');

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColor.lightSurface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColor.lightBorder, width: 0.9),
          boxShadow: [
            BoxShadow(
              color: AppColor.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Row 1: Timestamp + Completed badge ──
            Row(
              children: [
                if (dateStr.isNotEmpty)
                  Expanded(
                    child: Text(
                      dateStr,
                      style: const TextStyle(
                        color: AppColor.lightTextTertiary,
                        fontSize: 10.5,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  )
                else
                  const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFF059669).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'Completed',
                    style: TextStyle(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF059669),
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // ── Row 2: Avatar + Peer Info ──
            GestureDetector(
              onTap: () => _onPeerTap(context),
              behavior: HitTestBehavior.opaque,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppAvatar(
                    imageUrl: meeting.peerPhotoUrl,
                    name: meeting.peerName,
                    size: 44,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Name + PRO badge
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                meeting.peerName.toUpperCase(),
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
                            if (meeting.isPeerPro) ...[
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

                        // City
                        if (city.isNotEmpty) ...[
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on_outlined,
                                size: 10.5,
                                color: AppColor.lightTextTertiary,
                              ),
                              const SizedBox(width: 2),
                              Flexible(
                                child: Text(
                                  city,
                                  style: AppTypography.labelSmall.copyWith(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w400,
                                    color: AppColor.lightTextTertiary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],

                        // Designation · Company
                        if (subLine.isNotEmpty) ...[
                          const SizedBox(height: 2),
                          Text(
                            subLine,
                            style: AppTypography.bodySmall.copyWith(
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                              color: AppColor.lightTextSecondary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],

                        // Category (gradient)
                        if (category.isNotEmpty) ...[
                          const SizedBox(height: 2),
                          AppGradientText(
                            category,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // ── Row 3: Meeting meta pills (date + venue) ──
            Row(
              children: [
                if (meetingDateStr.isNotEmpty) ...[
                  _MetaPill(
                    icon: Icons.calendar_today_outlined,
                    label: meetingDateStr,
                  ),
                  if (location.isNotEmpty) const SizedBox(width: 8),
                ],
                if (location.isNotEmpty)
                  Expanded(
                    child: _MetaPill(
                      icon: Icons.location_on_outlined,
                      label: location,
                      maxLines: 1,
                    ),
                  ),
              ],
            ),

            // ── Row 4: Remarks + single media thumbnail ──
            if (remarks.isNotEmpty || hasMedia) ...[
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (remarks.isNotEmpty)
                    Expanded(
                      child: Text(
                        '"$remarks"',
                        style: AppTypography.bodySmall.copyWith(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w400,
                          color: AppColor.lightTextPrimary.withValues(alpha: 0.88),
                          height: 1.4,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  if (hasMedia && remarks.isNotEmpty) const SizedBox(width: 10),
                  if (hasMedia)
                    GestureDetector(
                      onTap: () => _openImagePreview(context, meeting.mediaUrls.first),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(9),
                        child: Container(
                          width: 58,
                          height: 58,
                          decoration: BoxDecoration(
                            color: AppColor.lightBackground,
                            border: Border.all(color: AppColor.lightBorder, width: 0.8),
                            borderRadius: BorderRadius.circular(9),
                          ),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.network(
                                meeting.mediaUrls.first,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => const Center(
                                  child: Icon(
                                    Icons.broken_image_outlined,
                                    size: 20,
                                    color: AppColor.lightTextTertiary,
                                  ),
                                ),
                              ),
                              if (meeting.mediaUrls.length > 1)
                                Positioned(
                                  bottom: 3,
                                  right: 3,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                                    decoration: BoxDecoration(
                                      color: Colors.black54,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      '+${meeting.mediaUrls.length - 1}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 9,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _MetaPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final int maxLines;

  const _MetaPill({
    required this.icon,
    required this.label,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: AppColor.lightBackground,
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: AppColor.lightBorder, width: 0.7),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppColor.lightTextSecondary),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              label,
              style: AppTypography.labelSmall.copyWith(
                fontSize: 11,
                fontWeight: FontWeight.w400,
                color: AppColor.lightTextSecondary,
              ),
              maxLines: maxLines,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
