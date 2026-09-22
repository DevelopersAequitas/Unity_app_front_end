import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/utils/paywall_gate_helper.dart';
import '../../../../core/widgets/app_avatar.dart';
import '../../../../core/widgets/app_gradient_text.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../domain/entities/geo_peer_entity.dart';

class NearMeDirectionsSheet extends StatelessWidget {
  final GeoPeerEntity peer;
  final double? userLatitude;
  final double? userLongitude;

  const NearMeDirectionsSheet({
    super.key,
    required this.peer,
    this.userLatitude,
    this.userLongitude,
  });

  static Future<void> show(
    BuildContext context, {
    required GeoPeerEntity peer,
    double? userLatitude,
    double? userLongitude,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => NearMeDirectionsSheet(
        peer: peer,
        userLatitude: userLatitude,
        userLongitude: userLongitude,
      ),
    );
  }

  Future<void> _handleGetDirections(BuildContext context) async {
    // 1. Pro check with paywall redirection for free/expired users
    if (!PaywallGateHelper.checkPro(
      context,
      message: 'Upgrade to Pro to get directions to nearby peers.',
    )) {
      return;
    }

    // 2. Open Google Maps with origin & destination
    try {
      String mapsUrl;
      final hasPeerCoords = peer.latitude != 0 && peer.longitude != 0;
      final hasUserCoords = userLatitude != null &&
          userLongitude != null &&
          userLatitude != 0 &&
          userLongitude != 0;

      if (hasPeerCoords) {
        if (hasUserCoords) {
          mapsUrl =
              'https://www.google.com/maps/dir/?api=1&origin=$userLatitude,$userLongitude&destination=${peer.latitude},${peer.longitude}&travelmode=driving';
        } else {
          mapsUrl =
              'https://www.google.com/maps/dir/?api=1&destination=${peer.latitude},${peer.longitude}&travelmode=driving';
        }
      } else if (peer.city != null && peer.city!.trim().isNotEmpty) {
        final encodedCity = Uri.encodeComponent(peer.city!.trim());
        if (hasUserCoords) {
          mapsUrl =
              'https://www.google.com/maps/dir/?api=1&origin=$userLatitude,$userLongitude&destination=$encodedCity&travelmode=driving';
        } else {
          mapsUrl = 'https://www.google.com/maps/search/?api=1&query=$encodedCity';
        }
      } else {
        AppSnackBar.showInfo(context, 'Location not available for this peer.');
        return;
      }

      final uri = Uri.parse(mapsUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        await launchUrl(uri, mode: LaunchMode.platformDefault);
      }
    } catch (e) {
      if (context.mounted) {
        AppSnackBar.showError(context, 'Could not open navigation map.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDark ? AppColor.darkSurface : AppColor.lightSurface;
    final borderColor = isDark ? AppColor.darkBorder : AppColor.lightBorder;
    final primaryTextColor =
        isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary;
    final secondaryTextColor =
        isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary;

    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
        border: Border.all(color: borderColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(
        20,
        12,
        20,
        20 + MediaQuery.of(context).padding.bottom,
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Drag Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: isDark ? AppColor.darkBorder : const Color(0xFFCBD5E1),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // Peer Info Row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppAvatar(
                  imageUrl: peer.profilePhotoUrl,
                  name: peer.displayName,
                  size: 56,
                  showOnlineBadge: true,
                  isOnline: peer.isOnline,
                  isPro: peer.isPro,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              peer.displayName,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: primaryTextColor,
                                letterSpacing: -0.2,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (peer.isVerified) ...[
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.verified_rounded,
                              size: 16,
                              color: AppColor.primaryBlue,
                            ),
                          ],
                          if (peer.isPro) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                gradient: AppColor.brandGradient,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'PRO',
                                style: TextStyle(
                                  fontSize: 8.5,
                                  fontWeight: FontWeight.w700,
                                  color: AppColor.white,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      if (peer.designation != null ||
                          peer.companyName != null) ...[
                        const SizedBox(height: 3),
                        Text(
                          [
                            if (peer.designation != null) peer.designation!,
                            if (peer.companyName != null) peer.companyName!,
                          ].join(' · '),
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w500,
                            color: secondaryTextColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      if (peer.category != null &&
                          peer.category!.isNotEmpty) ...[
                        const SizedBox(height: 5),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColor.badgeBlueBg,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color:
                                  AppColor.primaryBlue.withValues(alpha: 0.15),
                              width: 0.8,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ShaderMask(
                                blendMode: BlendMode.srcIn,
                                shaderCallback: (bounds) =>
                                    AppColor.brandGradient.createShader(
                                  Rect.fromLTWH(
                                      0, 0, bounds.width, bounds.height),
                                ),
                                child: const Icon(
                                  Icons.sell_outlined,
                                  size: 10,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Flexible(
                                child: AppGradientText(
                                  peer.category!,
                                  style: const TextStyle(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w600,
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
            ),

            const SizedBox(height: 16),

            // Location & Distance Highlights Box
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColor.darkSurfaceSubtle
                    : const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: borderColor, width: 0.8),
              ),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColor.primaryBlue.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.location_on_rounded,
                      color: AppColor.primaryBlue,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          peer.city != null && peer.city!.isNotEmpty
                              ? peer.city!
                              : 'Nearby Location',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: primaryTextColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${peer.distanceKm.toStringAsFixed(1)} km from your current location',
                          style: TextStyle(
                            fontSize: 11.5,
                            color: secondaryTextColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // Get Directions Button (Primary)
            Container(
              height: 46,
              decoration: BoxDecoration(
                gradient: AppColor.brandGradient,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppColor.primaryBlue.withValues(alpha: 0.28),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _handleGetDirections(context),
                  borderRadius: BorderRadius.circular(12),
                  child: const Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.directions_rounded,
                          color: AppColor.white,
                          size: 19,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'GET DIRECTIONS',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.4,
                            color: AppColor.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // View Profile Button (Secondary)
            OutlinedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamed(
                  context,
                  AppRoutes.peerProfile,
                  arguments: peer.id,
                );
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: borderColor, width: 1.2),
                foregroundColor: primaryTextColor,
                minimumSize: const Size.fromHeight(44),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person_outline_rounded, size: 18),
                  SizedBox(width: 6),
                  Text(
                    'View Full Profile',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
