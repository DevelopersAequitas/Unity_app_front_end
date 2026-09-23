import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/paywall_gate_helper.dart';
import '../../../../core/widgets/app_avatar.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/offline_prompt_dialog.dart';
import '../../../peers/domain/entities/peer_entity.dart';
import '../../../peers/domain/usecases/get_all_peers_usecase.dart';
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

  // Mention Autocomplete State
  Timer? _debounceTimer;
  List<PeerEntity> _mentionSuggestions = [];
  bool _isSearchingMentions = false;
  int _mentionQueryStartIndex = -1;
  final Map<String, PeerEntity> _selectedMentions = {};

  @override
  void initState() {
    super.initState();
    _contentController.addListener(_handleTextChanged);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _contentController.removeListener(_handleTextChanged);
    _contentController.dispose();
    _focusNode.dispose();
    _videoPlayerController?.dispose();
    super.dispose();
  }

  void _handleTextChanged() {
    final text = _contentController.text;
    final selection = _contentController.selection;
    if (selection.baseOffset <= 0) {
      _clearMentionSuggestions();
      return;
    }

    final textBeforeCursor = text.substring(0, selection.baseOffset);
    final lastAtIndex = textBeforeCursor.lastIndexOf('@');
    if (lastAtIndex == -1) {
      _clearMentionSuggestions();
      return;
    }

    final query = textBeforeCursor.substring(lastAtIndex + 1);
    // If there's a space or newline between @ and cursor, it's not an active mention query
    if (query.contains(' ') || query.contains('\n')) {
      _clearMentionSuggestions();
      return;
    }

    // Check if user has written at least 3 characters after @
    if (query.length >= 3) {
      _triggerMentionSearch(query, lastAtIndex);
    } else {
      _clearMentionSuggestions();
    }
  }

  void _clearMentionSuggestions() {
    if (_mentionSuggestions.isNotEmpty || _isSearchingMentions) {
      setState(() {
        _mentionSuggestions = [];
        _isSearchingMentions = false;
        _mentionQueryStartIndex = -1;
      });
    }
  }

  void _triggerMentionSearch(String query, int startIndex) {
    _debounceTimer?.cancel();
    _mentionQueryStartIndex = startIndex;
    setState(() => _isSearchingMentions = true);

    _debounceTimer = Timer(const Duration(milliseconds: 250), () async {
      try {
        final peers = await context.read<GetAllPeersUseCase>()(
          search: query,
          page: 1,
          limit: 8,
        );
        if (mounted) {
          setState(() {
            _mentionSuggestions = peers;
            _isSearchingMentions = false;
          });
        }
      } catch (_) {
        if (mounted) {
          setState(() {
            _mentionSuggestions = [];
            _isSearchingMentions = false;
          });
        }
      }
    });
  }

  void _selectMentionPeer(PeerEntity peer) {
    final text = _contentController.text;
    final selection = _contentController.selection;
    final startIndex = _mentionQueryStartIndex;

    if (startIndex < 0 || startIndex >= text.length) return;

    final cursor = selection.baseOffset > startIndex ? selection.baseOffset : text.length;
    final beforeMention = text.substring(0, startIndex);
    final afterMention = text.substring(cursor);

    // Clean user-friendly mention format in UI: @DisplayName
    final mentionText = '@${peer.displayName} ';
    final newText = '$beforeMention$mentionText$afterMention';
    final newCursorPos = beforeMention.length + mentionText.length;

    _selectedMentions[peer.id] = peer;

    _contentController.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newCursorPos),
    );

    setState(() {
      _mentionSuggestions = [];
      _isSearchingMentions = false;
      _mentionQueryStartIndex = -1;
    });
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

    if (!PaywallGateHelper.checkPro(context, message: 'Upgrade to Pro to create and publish posts.')) {
      return;
    }

    if (!OfflineGuard.check(context, actionName: 'publish posts')) {
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

      final List<Map<String, dynamic>> mentionsPayload = [];
      for (final peer in _selectedMentions.values) {
        final mentionName = peer.displayName.trim();
        if (text.toLowerCase().contains('@${mentionName.toLowerCase()}') ||
            text.toLowerCase().contains(mentionName.toLowerCase())) {
          mentionsPayload.add({
            'id': peer.id,
            'name': mentionName,
            if (peer.profilePhotoUrl != null && peer.profilePhotoUrl!.isNotEmpty) 'profile_photo_url': peer.profilePhotoUrl,
          });
        }
      }

      await createPostUseCase(
        contentText: text.isEmpty ? '\u200B' : text,
        visibility: 'public',
        media: mediaList,
        mentions: mentionsPayload,
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

  Widget _buildMentionSuggestionsList(bool isDark, Color surfaceColor, Color primaryTextColor) {
    if (_mentionSuggestions.isEmpty && !_isSearchingMentions) {
      return const SizedBox.shrink();
    }

    final borderColor = isDark ? AppColor.darkBorder : AppColor.lightBorder;
    final secondaryTextColor = isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary;

    return Container(
      constraints: const BoxConstraints(maxHeight: 220),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? AppColor.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor, width: 0.8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 8),
            child: Row(
              children: [
                const Icon(Icons.alternate_email_rounded, size: 14, color: AppColor.primaryBlue),
                const SizedBox(width: 6),
                Text(
                  'Matching Peers',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: secondaryTextColor,
                    letterSpacing: 0.2,
                  ),
                ),
                const Spacer(),
                if (_isSearchingMentions)
                  const SizedBox(
                    width: 12,
                    height: 12,
                    child: CircularProgressIndicator(
                      strokeWidth: 1.8,
                      valueColor: AlwaysStoppedAnimation(AppColor.primaryBlue),
                    ),
                  ),
              ],
            ),
          ),
          Divider(height: 1, thickness: 0.6, color: borderColor),
          if (_mentionSuggestions.isEmpty && _isSearchingMentions)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Text(
                  'Searching peers...',
                  style: TextStyle(fontSize: 11.5, color: secondaryTextColor),
                ),
              ),
            )
          else if (_mentionSuggestions.isEmpty)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Text(
                  'No matching peers found',
                  style: TextStyle(fontSize: 11.5, color: secondaryTextColor),
                ),
              ),
            )
          else
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: _mentionSuggestions.length,
                separatorBuilder: (context, index) => Divider(height: 1, thickness: 0.5, color: borderColor.withValues(alpha: 0.5)),
                itemBuilder: (context, index) {
                  final peer = _mentionSuggestions[index];
                  final subtitle = [
                    if (peer.designation?.isNotEmpty == true) peer.designation!,
                    if (peer.companyName?.isNotEmpty == true) peer.companyName!,
                  ].join(' • ');

                  return InkWell(
                    onTap: () => _selectMentionPeer(peer),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: Row(
                        children: [
                          AppAvatar(
                            imageUrl: peer.profilePhotoUrl,
                            name: peer.displayName,
                            size: 34,
                          ),
                          const SizedBox(width: 10),
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
                                          fontSize: 12.5,
                                          fontWeight: FontWeight.w600,
                                          color: primaryTextColor,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    if (peer.isVerified) ...[
                                      const SizedBox(width: 4),
                                      const Icon(Icons.verified_rounded, size: 13, color: AppColor.primaryBlue),
                                    ],
                                  ],
                                ),
                                if (subtitle.isNotEmpty) ...[
                                  const SizedBox(height: 2),
                                  Text(
                                    subtitle,
                                    style: TextStyle(
                                      fontSize: 10.5,
                                      color: secondaryTextColor,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ],
                            ),
                          ),
                          const Icon(Icons.north_west_rounded, size: 14, color: AppColor.primaryBlue),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
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
                          hintText: "What do you want to share with peers? (Use @ to mention)",
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
              _buildMentionSuggestionsList(isDark, surfaceColor, primaryTextColor),
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
