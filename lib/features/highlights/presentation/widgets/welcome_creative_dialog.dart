import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gal/gal.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/primary_pill_button.dart';
import '../../../profile/domain/entities/profile_entity.dart';
import '../../../profile/presentation/bloc/profile_bloc.dart';
import '../screens/welcome_creative_template_screen.dart';
import 'welcome_creative_card.dart';

class WelcomeCreativeDialog extends StatefulWidget {
  final ProfileEntity? profile;

  const WelcomeCreativeDialog({super.key, this.profile});

  static Future<void> show(BuildContext context, {ProfileEntity? profile}) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (_) => WelcomeCreativeDialog(profile: profile),
    );
  }

  @override
  State<WelcomeCreativeDialog> createState() => _WelcomeCreativeDialogState();
}

class _WelcomeCreativeDialogState extends State<WelcomeCreativeDialog> {
  final GlobalKey _dialogCardKey = GlobalKey();
  bool _isExporting = false;

  Future<Uint8List?> _captureCardBytes() async {
    try {
      final RenderRepaintBoundary? boundary = _dialogCardKey.currentContext
          ?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return null;

      if (boundary.debugNeedsPaint) {
        await Future.delayed(const Duration(milliseconds: 150));
      } else {
        await Future.delayed(const Duration(milliseconds: 80));
      }

      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      return byteData?.buffer.asUint8List();
    } catch (e) {
      debugPrint('Error capturing dialog welcome creative: $e');
      return null;
    }
  }

  Future<void> _handleSave() async {
    if (_isExporting) return;
    setState(() => _isExporting = true);

    try {
      if (mounted) {
        AppSnackBar.showInfo(context, 'Saving creative to Gallery...');
      }

      final bytes = await _captureCardBytes();
      if (bytes == null || bytes.isEmpty) {
        if (mounted) {
          AppSnackBar.showError(context, 'Failed to capture creative image.');
        }
        return;
      }

      final fileName =
          'Peers_Welcome_Creative_${DateTime.now().millisecondsSinceEpoch}';

      bool saved = false;
      try {
        final hasAccess = await Gal.hasAccess();
        if (!hasAccess) {
          await Gal.requestAccess();
        }
        await Gal.putImageBytes(bytes, name: fileName);
        saved = true;
      } catch (e) {
        debugPrint('Gal.putImageBytes failed: $e. Trying file fallback...');
        try {
          final tempDir = await getTemporaryDirectory();
          final file = File('${tempDir.path}/$fileName.png');
          await file.writeAsBytes(bytes);
          await Gal.putImage(file.path);
          saved = true;
        } catch (err) {
          debugPrint('Gal.putImage file fallback failed: $err');
        }
      }

      if (saved) {
        if (mounted) {
          AppSnackBar.showSuccess(
            context,
            'Welcome Creative saved to Gallery successfully!',
          );
        }
      } else {
        if (mounted) {
          AppSnackBar.showError(
            context,
            'Could not save image to gallery.',
          );
        }
      }
    } catch (e) {
      debugPrint('Gal save error: $e');
      if (mounted) {
        AppSnackBar.showError(context, 'Could not save to gallery: $e');
      }
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  Future<void> _handleShare() async {
    if (_isExporting) return;
    setState(() => _isExporting = true);

    try {
      final bytes = await _captureCardBytes();
      if (bytes == null || bytes.isEmpty) {
        if (mounted) {
          AppSnackBar.showError(context, 'Failed to prepare creative for sharing.');
        }
        return;
      }

      final tempDir = await getTemporaryDirectory();
      final fileName =
          'Peers_Welcome_Creative_${DateTime.now().millisecondsSinceEpoch}.png';
      final file = File('${tempDir.path}/$fileName');
      await file.writeAsBytes(bytes);

      const shareText =
          'Proud to be a member of Peers Global Unity network!\n\nConnect with us: https://peersunity.com\n\n#PeersGlobal #UnityPeer #Networking';

      await SharePlus.instance.share(
        ShareParams(
          text: shareText,
          files: [XFile(file.path)],
          subject: 'Peers Global Welcome Creative',
        ),
      );
    } catch (e) {
      if (mounted) {
        AppSnackBar.showError(context, 'Could not share creative: $e');
      }
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeProfile =
        widget.profile ?? context.watch<ProfileBloc>().state.profile;

    final memberName = activeProfile?.displayName ??
        '${activeProfile?.firstName ?? 'Valued'} ${activeProfile?.lastName ?? 'Member'}';
    final cityName = activeProfile?.city?.name ??
        activeProfile?.city?.formattedLocation ??
        activeProfile?.businessCity ??
        activeProfile?.state;
    final companyName = activeProfile?.companyName;
    final designation = activeProfile?.designation;

    // Exact category text matching profile header card
    final categoryText =
        (activeProfile?.isOtherCategory == true
            ? activeProfile?.otherCategoryName
            : null) ??
        activeProfile?.businessSubCategory ??
        activeProfile?.businessCategory ??
        activeProfile?.mainBusinessCategory ??
        activeProfile?.otherCategoryName ??
        (activeProfile?.categories.isNotEmpty == true
            ? (activeProfile!.categories.first.level4 ??
                activeProfile.categories.first.level3 ??
                activeProfile.categories.first.level2 ??
                activeProfile.categories.first.level1)
            : activeProfile?.businessType);

    final avatarUrl = activeProfile?.profilePhotoUrl;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        decoration: BoxDecoration(
          color: isDark ? AppColor.darkSurface : AppColor.lightSurface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.5 : 0.2),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header with Close
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 12, 0),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Color(0xFFEFF4FF),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.celebration_rounded,
                        size: 18,
                        color: AppColor.primaryBlue,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Welcome to the Community!',
                      style: AppTypography.titleSmall.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: isDark
                            ? AppColor.darkTextPrimary
                            : AppColor.lightTextPrimary,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, size: 20),
                      onPressed: () => Navigator.of(context).pop(),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),
              const Divider(height: 16),

              // Card Preview inside RepaintBoundary
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  clipBehavior: Clip.antiAlias,
                  child: InteractiveViewer(
                    minScale: 1.0,
                    maxScale: 2.5,
                    boundaryMargin: EdgeInsets.zero,
                    clipBehavior: Clip.hardEdge,
                    child: RepaintBoundary(
                      key: _dialogCardKey,
                      child: WelcomeCreativeCard(
                        memberName: memberName,
                        cityName: cityName,
                        companyName: companyName,
                        designation: designation,
                        category: categoryText,
                        avatarUrl: avatarUrl,
                      ),
                    ),
                  ),
                ),
              ),

              // Action Buttons
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Save & Share Quick Actions
                    Row(
                      children: [
                        Expanded(
                          child: PrimaryPillButton(
                            label: 'Save Image',
                            iconData: Icons.download_rounded,
                            height: 38,
                            isOutlined: true,
                            isLoading: _isExporting,
                            onPressed: _isExporting ? null : _handleSave,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: PrimaryPillButton(
                            label: 'Share',
                            iconData: Icons.share_rounded,
                            height: 38,
                            isLoading: _isExporting,
                            onPressed: _isExporting ? null : _handleShare,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // View / Customize Creative
                    SizedBox(
                      width: double.infinity,
                      height: 42,
                      child: TextButton.icon(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) =>
                                  const WelcomeCreativeTemplateScreen(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.palette_outlined, size: 16),
                        label: const Text(
                          'Customize Caption & Post Details',
                          style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600),
                        ),
                        style: TextButton.styleFrom(
                          foregroundColor: isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
