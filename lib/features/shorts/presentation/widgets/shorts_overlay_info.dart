import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/router/app_router.dart';
import '../../domain/entities/intro_video_entity.dart';

class ShortsOverlayInfo extends StatelessWidget {
  final IntroVideoEntity video;

  const ShortsOverlayInfo({super.key, required this.video});

  void _onProfileTap(BuildContext context) {
    if (video.connectionStatus == 'self') {
      Navigator.pushNamed(context, AppRoutes.profile);
    } else {
      Navigator.pushNamed(
        context,
        AppRoutes.peerProfile,
        arguments: video.userId,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => _onProfileTap(context),
          behavior: HitTestBehavior.opaque,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  video.displayName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    letterSpacing: -0.2,
                    shadows: [Shadow(color: Colors.black54, blurRadius: 4)],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (video.isVerified) ...[
                const SizedBox(width: 4),
                const Icon(Icons.verified, color: AppColor.primaryBlue, size: 16),
              ],
              if (video.isPro) ...[
                const SizedBox(width: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                  decoration: BoxDecoration(
                    gradient: AppColor.brandGradient,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'PRO',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        if (video.designation != null || video.companyName != null) ...[
          const SizedBox(height: 3),
          Text(
            [video.designation, video.companyName]
                .where((e) => e != null && e.isNotEmpty)
                .join(' • '),
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 12.5,
              fontWeight: FontWeight.w400,
              shadows: const [Shadow(color: Colors.black54, blurRadius: 4)],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
        if (video.level4Category != null && video.level4Category!.isNotEmpty) ...[
          const SizedBox(height: 5),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white24, width: 0.8),
            ),
            child: Text(
              video.level4Category!,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w400,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
        if (video.cityName != null && video.cityName!.isNotEmpty) ...[
          const SizedBox(height: 4),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.location_on_outlined, color: Colors.white70, size: 13),
              const SizedBox(width: 3),
              Text(
                video.cityName!,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
