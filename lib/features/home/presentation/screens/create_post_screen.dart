import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../profile/presentation/bloc/profile_bloc.dart';
import '../../../profile/presentation/bloc/profile_posts_bloc.dart';
import '../../../profile/presentation/bloc/profile_posts_event.dart';
import '../../domain/usecases/create_post_usecase.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../widgets/create_post/create_post_bottom_bar.dart';
import '../widgets/create_post/create_post_media_preview.dart';
import '../widgets/create_post/create_post_options_sheet.dart';
import '../widgets/create_post/create_post_user_header.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final TextEditingController _contentController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  File? _selectedMediaFile;
  String _selectedMediaType = 'image';
  VideoPlayerController? _videoPlayerController;
  Duration? _videoDuration;

  bool _isSubmitting = false;
  double _uploadProgress = 0.0;
  String _statusText = '';

  @override
  void dispose() {
    _contentController.dispose();
    _focusNode.dispose();
    _videoPlayerController?.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    if (_isSubmitting) return;
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 1920,
        maxHeight: 1920,
      );
      if (picked == null) return;

      final cropped = await ImageCropper().cropImage(
        sourcePath: picked.path,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: AppColor.primaryBlue,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
          ),
          IOSUiSettings(title: 'Crop Image'),
        ],
      );

      if (cropped != null && mounted) {
        _cleanupVideoController();
        setState(() {
          _selectedMediaFile = File(cropped.path);
          _selectedMediaType = 'image';
        });
      }
    } catch (e) {
      if (mounted) AppSnackBar.showError(context, 'Failed to select image: $e');
    }
  }

  Future<void> _recordVideo() async {
    if (_isSubmitting) return;
    try {
      final picker = ImagePicker();
      final picked = await picker.pickVideo(
        source: ImageSource.camera,
        maxDuration: const Duration(minutes: 1),
      );
      if (picked == null) return;
      await _processSelectedVideo(File(picked.path), maxAllowedSeconds: 60, isRecorded: true);
    } catch (e) {
      if (mounted) AppSnackBar.showError(context, 'Failed to record video: $e');
    }
  }

  Future<void> _pickVideoFromGallery() async {
    if (_isSubmitting) return;
    try {
      final picker = ImagePicker();
      final picked = await picker.pickVideo(source: ImageSource.gallery);
      if (picked == null) return;
      await _processSelectedVideo(File(picked.path), maxAllowedSeconds: 120, isRecorded: false);
    } catch (e) {
      if (mounted) AppSnackBar.showError(context, 'Failed to select video: $e');
    }
  }

  Future<void> _processSelectedVideo(
    File videoFile, {
    required int maxAllowedSeconds,
    required bool isRecorded,
  }) async {
    Duration? duration;
    VideoPlayerController? tempController;
    try {
      tempController = VideoPlayerController.file(videoFile);
      await tempController.initialize();
      duration = tempController.value.duration;
    } catch (_) {}

    if (duration != null && duration.inSeconds > (maxAllowedSeconds + 1)) {
      await tempController?.dispose();
      if (mounted) {
        final limitStr = isRecorded ? '1-minute' : '2-minute';
        AppSnackBar.showInfo(
          context,
          'Video exceeds the $limitStr limit (${duration.inMinutes}m ${duration.inSeconds % 60}s). Please select a shorter video.',
        );
      }
      return;
    }

    _cleanupVideoController();
    if (tempController != null && tempController.value.isInitialized) {
      _videoPlayerController = tempController;
      _videoPlayerController!.setLooping(true);
    }

    if (mounted) {
      setState(() {
        _selectedMediaFile = videoFile;
        _selectedMediaType = 'video';
        _videoDuration = duration;
      });
    }
  }

  void _cleanupVideoController() {
    _videoPlayerController?.dispose();
    _videoPlayerController = null;
    _videoDuration = null;
  }

  void _removeSelectedMedia() {
    _cleanupVideoController();
    setState(() => _selectedMediaFile = null);
  }

  Future<void> _handleSubmit() async {
    if (_isSubmitting) return;
    final text = _contentController.text.trim();
    final hasMedia = _selectedMediaFile != null;

    if (text.isEmpty && !hasMedia) {
      AppSnackBar.showInfo(context, 'Please write a description or attach media to post.');
      return;
    }

    setState(() {
      _isSubmitting = true;
      _uploadProgress = 0.0;
      _statusText = hasMedia ? 'Uploading media...' : 'Publishing post...';
    });

    try {
      final createPostUseCase = context.read<CreatePostUseCase>();
      final List<Map<String, String>> mediaList = [];

      if (hasMedia) {
        final fileId = await createPostUseCase.uploadFile(
          _selectedMediaFile!,
          onProgress: (progress) {
            if (mounted) {
              setState(() {
                _uploadProgress = progress;
                _statusText = 'Uploading media (${(progress * 100).toInt()}%)...';
              });
            }
          },
        );
        mediaList.add({'id': fileId, 'type': _selectedMediaType});
        if (mounted) setState(() => _statusText = 'Publishing post...');
      }

      await createPostUseCase(
        contentText: text.isEmpty ? '\u200B' : text,
        visibility: 'public',
        media: mediaList,
      );

      if (mounted) {
        AppSnackBar.showSuccess(context, 'Post published successfully!');
        try {
          context.read<HomeBloc>().add(const HomeFeedRefreshRequested());
        } catch (_) {}
        try {
          context.read<ProfilePostsBloc>().add(const ProfilePostsRefreshRequested());
        } catch (_) {}
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSubmitting = false);
        AppSnackBar.showError(context, 'Failed to create post: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColor.darkBackground : AppColor.lightScaffoldBg;
    final surfaceColor = isDark ? AppColor.darkSurface : AppColor.lightSurface;
    final primaryTextColor = isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary;

    final profileState = context.watch<ProfileBloc>().state;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: surfaceColor,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: Icon(Icons.close_rounded, color: primaryTextColor, size: 22),
          onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Create Post',
          style: AppTypography.titleMedium.copyWith(
            fontWeight: FontWeight.w500,
            color: primaryTextColor,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12, top: 10, bottom: 10),
            child: SizedBox(
              height: 34,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _handleSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primaryBlue,
                  disabledBackgroundColor: AppColor.primaryBlue.withValues(alpha: 0.5),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  elevation: 0,
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(
                        'Post',
                        style: AppTypography.labelLarge.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              if (_isSubmitting)
                LinearProgressIndicator(
                  value: _uploadProgress > 0 ? _uploadProgress : null,
                  backgroundColor: AppColor.primaryBlue.withValues(alpha: 0.2),
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColor.primaryBlue),
                  minHeight: 3,
                ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CreatePostUserHeader(profile: profileState.profile, isDark: isDark),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _contentController,
                        focusNode: _focusNode,
                        maxLines: null,
                        minLines: 4,
                        enabled: !_isSubmitting,
                        style: AppTypography.bodyMedium.copyWith(color: primaryTextColor),
                        decoration: InputDecoration(
                          hintText: "What do you want to share with peers?",
                          hintStyle: AppTypography.bodyMedium.copyWith(
                            color: isDark ? AppColor.darkTextSecondary : AppColor.lightTextDisabled,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (_selectedMediaFile != null) ...[
                        CreatePostMediaPreview(
                          file: _selectedMediaFile!,
                          mediaType: _selectedMediaType,
                          videoPlayerController: _videoPlayerController,
                          videoDuration: _videoDuration,
                          isSubmitting: _isSubmitting,
                          isDark: isDark,
                          onRemove: _removeSelectedMedia,
                          onToggleVideoPlayback: () {
                            if (_videoPlayerController != null) {
                              setState(() {
                                if (_videoPlayerController!.value.isPlaying) {
                                  _videoPlayerController!.pause();
                                } else {
                                  _videoPlayerController!.play();
                                }
                              });
                            }
                          },
                        ),
                        const SizedBox(height: 16),
                      ],
                    ],
                  ),
                ),
              ),
              CreatePostBottomBar(
                isSubmitting: _isSubmitting,
                isDark: isDark,
                onPickCameraPhoto: () => _pickImage(ImageSource.camera),
                onPickGalleryPhoto: () => _pickImage(ImageSource.gallery),
                onRecordVideo: _recordVideo,
                onPickGalleryVideo: _pickVideoFromGallery,
                onShowAllOptions: () => CreatePostOptionsSheet.show(
                  context,
                  isDark: isDark,
                  onPickCameraPhoto: () => _pickImage(ImageSource.camera),
                  onPickGalleryPhoto: () => _pickImage(ImageSource.gallery),
                  onRecordVideo: _recordVideo,
                  onPickGalleryVideo: _pickVideoFromGallery,
                ),
              ),
            ],
          ),
          if (_isSubmitting)
            Container(
              color: Colors.black.withValues(alpha: 0.3),
              alignment: Alignment.center,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      width: 36,
                      height: 36,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        valueColor: AlwaysStoppedAnimation<Color>(AppColor.primaryBlue),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _statusText.isNotEmpty ? _statusText : 'Processing...',
                      style: AppTypography.bodySmall.copyWith(
                        fontWeight: FontWeight.w500,
                        color: primaryTextColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
