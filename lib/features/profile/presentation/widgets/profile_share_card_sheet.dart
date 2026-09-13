import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/constants/app_environment.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/widgets/app_avatar.dart';
import '../../../../core/widgets/app_gradient_text.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../domain/entities/profile_entity.dart';

class ProfileShareCardSheet extends StatefulWidget {
  final ProfileEntity profile;
  final bool isOwnProfile;

  const ProfileShareCardSheet({
    super.key,
    required this.profile,
    this.isOwnProfile = false,
  });

  static Future<void> show(
    BuildContext context, {
    required ProfileEntity profile,
    bool isOwnProfile = false,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) =>
          ProfileShareCardSheet(profile: profile, isOwnProfile: isOwnProfile),
    );
  }

  @override
  State<ProfileShareCardSheet> createState() => _ProfileShareCardSheetState();
}

class _ProfileShareCardSheetState extends State<ProfileShareCardSheet> {
  final GlobalKey _cardKey = GlobalKey();
  bool _isSharing = false;

  String get _shareUrl => AppEnvironment.getPeerProfileDeepLink(widget.profile.id);

  String? get _effectiveCategory {
    final p = widget.profile;

    // For peer profile: exactly matches PeerProfileHeader category fields
    if (!widget.isOwnProfile) {
      final peerCat = p.businessSubCategory ??
          p.businessCategory ??
          p.mainBusinessCategory ??
          p.businessType ??
          (p.categories.isNotEmpty
              ? (p.categories.first.level4 ?? p.categories.first.circleName)
              : null) ??
          p.otherCategoryName;

      if (peerCat != null && peerCat.trim().isNotEmpty) {
        return peerCat.trim();
      }
    }

    // For own profile: exactly matches ProfileHeaderCard category fields
    final ownCat = (p.isOtherCategory ? p.otherCategoryName : null) ??
        p.businessSubCategory ??
        p.otherCategoryName ??
        (p.categories.isNotEmpty
            ? (p.categories.first.level4 ?? p.categories.first.circleName)
            : null) ??
        p.businessCategory ??
        p.mainBusinessCategory ??
        p.businessType;

    if (ownCat != null && ownCat.trim().isNotEmpty) {
      return ownCat.trim();
    }
    return null;
  }

  void _onCopyLink() {
    Clipboard.setData(ClipboardData(text: _shareUrl));
    Navigator.pop(context);
    AppSnackBar.showSuccess(context, 'Profile link copied to clipboard!');
  }

  Future<void> _onShare() async {
    if (_isSharing) return;
    setState(() => _isSharing = true);

    try {
      final boundary =
          _cardKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary != null) {
        final image = await boundary.toImage(pixelRatio: 3.0);
        final byteData =
            await image.toByteData(format: ui.ImageByteFormat.png);
        if (byteData != null) {
          final pngBytes = byteData.buffer.asUint8List();
          final tempDir = await getTemporaryDirectory();
          final cleanId = widget.profile.id
              .replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_');
          final filePath = '${tempDir.path}/peers_card_$cleanId.png';
          final file = File(filePath);
          await file.writeAsBytes(pngBytes);

          final title = widget.isOwnProfile
              ? 'Connect with me on ${AppEnvironment.appName}'
              : 'Connect with ${widget.profile.displayName} on ${AppEnvironment.appName}';
          final text = '$title:\n$_shareUrl';

          await SharePlus.instance.share(
            ShareParams(
              files: [XFile(filePath)],
              text: text,
              subject: '${widget.profile.displayName} - Peers Profile Card',
            ),
          );
          return;
        }
      }
    } catch (e) {
      debugPrint('[ProfileShareCardSheet] Error capturing card image: $e');
    } finally {
      if (mounted) {
        setState(() => _isSharing = false);
      }
    }

    // Fallback if image capture is unavailable
    final title = widget.isOwnProfile
        ? 'Connect with me on ${AppEnvironment.appName}'
        : 'Connect with ${widget.profile.displayName} on ${AppEnvironment.appName}';
    final text = '$title:\n$_shareUrl';
    await SharePlus.instance.share(
      ShareParams(
        text: text,
        subject: '${widget.profile.displayName} - Peers Profile',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColor.lightSurface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag Handle
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColor.lightBorder,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 10),

              // Modal Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.isOwnProfile
                        ? 'Share My Profile Card'
                        : 'Share Peer Profile Card',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColor.lightTextPrimary,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.close_rounded,
                      size: 20,
                      color: AppColor.lightTextSecondary,
                    ),
                    onPressed: () => Navigator.pop(context),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Card Container with RepaintBoundary for high-res image sharing
              RepaintBoundary(
                key: _cardKey,
                child: _buildShareCard(context),
              ),
              const SizedBox(height: 12),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _onCopyLink,
                      icon: const Icon(Icons.copy_rounded, size: 15),
                      label: const Text(
                        'Copy Link',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColor.lightTextPrimary,
                        side: const BorderSide(color: AppColor.lightBorder),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _isSharing ? null : _onShare,
                      icon: _isSharing
                          ? const SizedBox(
                              width: 14,
                              height: 14,
                              child: CircularProgressIndicator(
                                strokeWidth: 1.8,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.share_outlined, size: 15),
                      label: Text(
                        _isSharing ? 'Preparing...' : 'Share Card',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.primaryBlue,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShareCard(BuildContext context) {
    final profile = widget.profile;
    final company = profile.companyName ?? '';
    final designation = profile.designation ?? '';
    final workText = [
      if (designation.isNotEmpty) designation,
      if (company.isNotEmpty) company,
    ].join(' • ');
    final cityName =
        profile.city?.name ?? profile.city?.formattedLocation ?? '';
    final stateName = profile.state ?? '';
    final locationText = [
      if (cityName.isNotEmpty) cityName,
      if (stateName.isNotEmpty) stateName,
    ].join(', ');
    final category = _effectiveCategory;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColor.lightBorder.withValues(alpha: 0.8)),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          // Profile Header Row: Avatar + Details
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColor.primaryBlue.withValues(alpha: 0.3),
                    width: 1.5,
                  ),
                ),
                child: AppAvatar(
                  imageUrl: profile.profilePhotoUrl,
                  name: profile.displayName,
                  size: 48,
                  showOnlineBadge: false,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name & Verified Badge
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            profile.displayName.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w500,
                              color: AppColor.lightTextPrimary,
                              letterSpacing: 0.3,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (profile.isVerified) ...[
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.verified_rounded,
                            size: 14,
                            color: AppColor.primaryBlue,
                          ),
                        ],
                      ],
                    ),

                    // Designation & Company
                    if (workText.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        workText,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: AppColor.primaryBlue,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],

                    // Category (From Profile Header)
                    if (category != null && category.isNotEmpty) ...[
                      const SizedBox(height: 3),
                      Row(
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
                          const SizedBox(width: 3.5),
                          Flexible(
                            child: AppGradientText(
                              category,
                              style: const TextStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],

                    // Location
                    if (locationText.isNotEmpty) ...[
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            size: 11,
                            color: AppColor.lightTextTertiary,
                          ),
                          const SizedBox(width: 3),
                          Flexible(
                            child: Text(
                              locationText,
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w400,
                                color: AppColor.lightTextSecondary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(height: 1, thickness: 0.7, color: AppColor.lightBorder),
          const SizedBox(height: 8),

          // Key Impact Metrics
          Row(
            children: [
              Expanded(
                child: _buildMetricItem(
                  'Impact',
                  profile.lifeImpactedCount.toString(),
                  const Color(0xFF10B981),
                ),
              ),
              _buildMetricDivider(),
              Expanded(
                child: _buildMetricItem(
                  'Meetings',
                  profile.p2pMeetingsCount.toString(),
                  const Color(0xFF3B82F6),
                ),
              ),
              _buildMetricDivider(),
              Expanded(
                child: _buildMetricItem(
                  'Referrals',
                  profile.referralsCount.toString(),
                  const Color(0xFFF59E0B),
                ),
              ),
              _buildMetricDivider(),
              Expanded(
                child: _buildMetricItem(
                  'Deals',
                  profile.businessDealsCount.toString(),
                  const Color(0xFF8B5CF6),
                ),
              ),
              if (profile.badgesCount > 0) ...[
                _buildMetricDivider(),
                Expanded(
                  child: _buildMetricItem(
                    'Badges',
                    profile.badgesCount.toString(),
                    const Color(0xFFEC4899),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),
          const Divider(height: 1, thickness: 0.7, color: AppColor.lightBorder),
          const SizedBox(height: 10),

          // Big, Clean & Instantly Scannable QR Code with Gradient styling and 20px Radius Logo
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColor.lightBorder),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    ShaderMask(
                      shaderCallback: (Rect bounds) {
                        return AppColor.brandGradient.createShader(bounds);
                      },
                      blendMode: BlendMode.srcIn,
                      child: QrImageView(
                        data: _shareUrl,
                        version: QrVersions.auto,
                        errorCorrectionLevel: QrErrorCorrectLevel.H,
                        size: 155.0,
                        padding: EdgeInsets.zero,
                        gapless: false,
                        eyeStyle: const QrEyeStyle(
                          eyeShape: QrEyeShape.square,
                          color: Colors.black,
                        ),
                        dataModuleStyle: const QrDataModuleStyle(
                          dataModuleShape: QrDataModuleShape.square,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Container(
                      width: 38,
                      height: 38,
                      padding: const EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColor.primaryBlue.withValues(alpha: 0.25),
                          width: 1.0,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(0),
                        child: Image.asset(
                          'assets/images/icon-bg.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  AppEnvironment.appName.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: AppColor.primaryBlue,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Scan with any camera or QR app to connect',
                  style: TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w400,
                    color: AppColor.lightTextTertiary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricItem(String label, String value, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w500,
            color: color,
          ),
        ),
        const SizedBox(height: 1.5),
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontSize: 8,
            fontWeight: FontWeight.w500,
            color: AppColor.lightTextSecondary,
            letterSpacing: 0.2,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildMetricDivider() {
    return Container(
      width: 1,
      height: 20,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      color: AppColor.lightBorder,
    );
  }
}
