import 'package:flutter/material.dart';
import 'package:unity_app/core/theme/app_color.dart';
import 'package:unity_app/core/theme/app_typography.dart';
import 'package:unity_app/core/widgets/app_avatar.dart';
import 'package:unity_app/core/widgets/app_gradient_text.dart';
import 'package:unity_app/features/p2p_meetings/domain/entities/p2p_meeting_entity.dart';

class P2pCompletedDetailSheet extends StatelessWidget {
  final P2pMeetingEntity meeting;

  const P2pCompletedDetailSheet({
    super.key,
    required this.meeting,
  });

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
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: AppColor.lightSurface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColor.lightBorder,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  AppAvatar(
                    imageUrl: meeting.peerPhotoUrl,
                    name: meeting.peerName,
                    size: 48,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                meeting.peerName.toUpperCase(),
                                style: AppTypography.titleMedium.copyWith(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: AppColor.lightTextPrimary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (meeting.isPeerPro) ...[
                              const SizedBox(width: 6),
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
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        if (meeting.peerCompany != null && meeting.peerCompany!.isNotEmpty) ...[
                          const SizedBox(height: 2),
                          Text(
                            meeting.peerCompany!,
                            style: AppTypography.bodySmall.copyWith(
                              fontSize: 12,
                              color: AppColor.lightTextSecondary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                        if (meeting.peerCategory != null && meeting.peerCategory!.isNotEmpty) ...[
                          const SizedBox(height: 2),
                          AppGradientText(
                            meeting.peerCategory!,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(height: 1, color: AppColor.lightBorder),
              const SizedBox(height: 14),
              if (meeting.meetingDate != null) ...[
                _DetailRow(
                  icon: Icons.calendar_today_outlined,
                  label: 'Meeting Date',
                  value: meeting.meetingDate!,
                ),
                const SizedBox(height: 12),
              ],
              if (meeting.meetingPlace != null && meeting.meetingPlace!.isNotEmpty) ...[
                _DetailRow(
                  icon: Icons.location_on_outlined,
                  label: 'Location / Venue',
                  value: meeting.meetingPlace!,
                ),
                const SizedBox(height: 12),
              ],
              if (meeting.remarks != null && meeting.remarks!.isNotEmpty) ...[
                _DetailRow(
                  icon: Icons.notes_outlined,
                  label: 'Meeting Discussion & Takeaways',
                  value: meeting.remarks!,
                ),
                const SizedBox(height: 12),
              ],
              if (meeting.mediaUrls.isNotEmpty) ...[
                Text(
                  'Media / Creative Attachment',
                  style: AppTypography.labelSmall.copyWith(
                    fontSize: 11,
                    color: AppColor.lightTextTertiary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 100,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: meeting.mediaUrls.length,
                    separatorBuilder: (context, index) => const SizedBox(width: 10),
                    itemBuilder: (ctx, idx) {
                      final url = meeting.mediaUrls[idx];
                      return GestureDetector(
                        onTap: () => _openImagePreview(context, url),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: AppColor.lightBackground,
                              border: Border.all(color: AppColor.lightBorder),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.network(
                                  url,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => const Center(
                                    child: Icon(
                                      Icons.broken_image_outlined,
                                      color: AppColor.lightTextTertiary,
                                    ),
                                  ),
                                ),

                                Positioned(
                                  bottom: 4,
                                  right: 4,
                                  child: Container(
                                    padding: const EdgeInsets.all(3),
                                    decoration: const BoxDecoration(
                                      color: Colors.black54,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.fullscreen_rounded,
                                      size: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
              ],
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                height: 44,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColor.lightBorder),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Close',
                    style: TextStyle(
                      color: AppColor.lightTextPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AppColor.lightTextSecondary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTypography.labelSmall.copyWith(
                  fontSize: 11,
                  color: AppColor.lightTextTertiary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: AppTypography.bodySmall.copyWith(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColor.lightTextPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
