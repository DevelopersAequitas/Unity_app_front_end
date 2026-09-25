import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gal/gal.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_common_bar.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/primary_pill_button.dart';
import '../../../profile/presentation/bloc/profile_bloc.dart';
import '../widgets/welcome_creative_card.dart';

class WelcomeCreativeTemplateScreen extends StatefulWidget {
  const WelcomeCreativeTemplateScreen({super.key});

  @override
  State<WelcomeCreativeTemplateScreen> createState() =>
      _WelcomeCreativeTemplateScreenState();
}

class _WelcomeCreativeTemplateScreenState
    extends State<WelcomeCreativeTemplateScreen> {
  final GlobalKey _cardKey = GlobalKey();
  final TextEditingController _noteController = TextEditingController(
    text:
        'Excited to be part of the Peers Global Unity network! Let us connect and grow together.',
  );
  bool _isExporting = false;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<Uint8List?> _captureHighResImageBytes() async {
    try {
      // Flush pending frames so CachedNetworkImage / RepaintBoundary is fully painted
      await SchedulerBinding.instance.endOfFrame;
      await Future.delayed(const Duration(milliseconds: 150));

      final RenderRepaintBoundary? boundary =
          _cardKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return null;

      if (boundary.debugNeedsPaint) {
        await Future.delayed(const Duration(milliseconds: 200));
      }

      // 3.0x ultra-crisp resolution for printing & sharing
      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      return byteData?.buffer.asUint8List();
    } catch (e) {
      debugPrint('Error capturing welcome creative: $e');
      return null;
    }
  }

  Future<void> _handleSaveToGallery() async {
    if (_isExporting) return;
    setState(() => _isExporting = true);

    try {
      if (mounted) {
        AppSnackBar.showInfo(context, 'Saving creative to Gallery...');
      }

      final bytes = await _captureHighResImageBytes();
      if (bytes == null || bytes.isEmpty) {
        if (mounted) {
          AppSnackBar.showError(context, 'Failed to generate creative image.');
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
            'Could not save image to gallery. Please check storage permissions.',
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
      final bytes = await _captureHighResImageBytes();
      if (bytes == null || bytes.isEmpty) {
        if (mounted) {
          AppSnackBar.showError(
            context,
            'Failed to prepare creative for sharing.',
          );
        }
        return;
      }

      final tempDir = await getTemporaryDirectory();
      final fileName =
          'Peers_Welcome_Creative_${DateTime.now().millisecondsSinceEpoch}.png';
      final file = File('${tempDir.path}/$fileName');
      await file.writeAsBytes(bytes);

      final customNote = _noteController.text.trim();
      final shareText = customNote.isNotEmpty
          ? '$customNote\n\nConnect with us: https://peersunity.com\n\n#PeersGlobal #UnityPeer #Networking'
          : 'Proud to be a member of Peers Global Unity network!\n\nConnect with us: https://peersunity.com\n\n#PeersGlobal #UnityPeer #Networking';

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
    final profile = context.watch<ProfileBloc>().state.profile;

    final memberName =
        profile?.displayName ??
        '${profile?.firstName ?? 'Valued'} ${profile?.lastName ?? 'Member'}';
    final cityName =
        profile?.city?.name ??
        profile?.city?.formattedLocation ??
        profile?.businessCity ??
        profile?.state;
    final companyName = profile?.companyName;
    final designation = profile?.designation;

    // Exact category text matching profile header card
    final categoryText =
        (profile?.isOtherCategory == true
            ? profile?.otherCategoryName
            : null) ??
        profile?.businessSubCategory ??
        profile?.businessCategory ??
        profile?.mainBusinessCategory ??
        profile?.otherCategoryName ??
        (profile?.categories.isNotEmpty == true
            ? (profile!.categories.first.level4 ??
                  profile.categories.first.level3 ??
                  profile.categories.first.level2 ??
                  profile.categories.first.level1)
            : profile?.businessType);

    final avatarUrl = profile?.profilePhotoUrl;

    return Scaffold(
      backgroundColor: isDark
          ? AppColor.darkBackground
          : AppColor.lightBackground,
      appBar: const AppCommonBar(
        title: 'Welcome Creative',
        showBack: true,
        showSearch: false,
        showNotifications: false,
        showProfile: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Info Banner
              // Container(
              //   padding: const EdgeInsets.all(12),
              //   decoration: BoxDecoration(
              //     color: isDark
              //         ? AppColor.darkSurface
              //         : const Color(0xFFEFF4FF),
              //     borderRadius: BorderRadius.circular(12),
              //     border: Border.all(
              //       color: isDark
              //           ? AppColor.darkBorder
              //           : const Color(0xFFD4E2FF),
              //       width: 0.9,
              //     ),
              //   ),
              //   child: Row(
              //     children: [
              //       Container(
              //         padding: const EdgeInsets.all(7),
              //         decoration: const BoxDecoration(
              //           color: AppColor.primaryBlue,
              //           shape: BoxShape.circle,
              //         ),
              //         child: const Icon(
              //           Icons.auto_awesome_rounded,
              //           size: 16,
              //           color: Colors.white,
              //         ),
              //       ),
              //       const SizedBox(width: 10),
              //       Expanded(
              //         child: Text(
              //           'Your personalized member creative is ready to download and share with your network!',
              //           style: AppTypography.bodySmall.copyWith(
              //             fontSize: 12,
              //             color: isDark
              //                 ? AppColor.darkTextSecondary
              //                 : const Color(0xFF1E3A8A),
              //             fontWeight: FontWeight.w500,
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              const SizedBox(height: 16),

              // Creative Preview Canvas
              Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 420),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(
                          alpha: isDark ? 0.35 : 0.12,
                        ),
                        blurRadius: 18,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    clipBehavior: Clip.antiAlias,
                    child: InteractiveViewer(
                      minScale: 1.0,
                      maxScale: 3.5,
                      boundaryMargin: EdgeInsets.zero,
                      clipBehavior: Clip.hardEdge,
                      child: RepaintBoundary(
                        key: _cardKey,
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
              ),
              const SizedBox(height: 20),

              // Custom Note Input
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? AppColor.darkSurface : AppColor.lightSurface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark ? AppColor.darkBorder : AppColor.lightBorder,
                    width: 0.8,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sharing Note / Caption',
                      style: AppTypography.labelMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppColor.darkTextPrimary
                            : AppColor.lightTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _noteController,
                      maxLines: 2,
                      style: AppTypography.bodyMedium.copyWith(
                        fontSize: 13,
                        color: isDark
                            ? AppColor.darkTextPrimary
                            : AppColor.lightTextPrimary,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Add a message for your post...',
                        hintStyle: TextStyle(
                          color: isDark
                              ? AppColor.darkTextDisabled
                              : AppColor.lightTextDisabled,
                          fontSize: 12.5,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Actions (Save & Share)
              Row(
                children: [
                  Expanded(
                    child: PrimaryPillButton(
                      label: 'Save Image',
                      iconData: Icons.download_rounded,
                      height: 40,
                      isOutlined: true,
                      isLoading: _isExporting,
                      onPressed: _isExporting ? null : _handleSaveToGallery,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: PrimaryPillButton(
                      label: 'Share Creative',
                      iconData: Icons.share_rounded,
                      height: 40,
                      isLoading: _isExporting,
                      onPressed: _isExporting ? null : _handleShare,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
