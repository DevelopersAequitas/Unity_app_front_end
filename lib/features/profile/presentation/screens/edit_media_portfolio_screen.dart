import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/profile_entity.dart';
import '../bloc/profile_edit_bloc.dart';
import '../bloc/profile_edit_event.dart';
import '../bloc/profile_edit_state.dart';

class EditMediaPortfolioScreen extends StatefulWidget {
  final ProfileEntity profile;

  const EditMediaPortfolioScreen({
    super.key,
    required this.profile,
  });

  @override
  State<EditMediaPortfolioScreen> createState() => _EditMediaPortfolioScreenState();
}

class _EditMediaPortfolioScreenState extends State<EditMediaPortfolioScreen> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickAndUploadImage({
    required ImageSource source,
    required bool isCover,
  }) async {
    try {
      final pickedFile = await _picker.pickImage(source: source, imageQuality: 85);
      if (pickedFile != null && mounted) {
        context.read<ProfileEditBloc>().add(
              ProfileUploadPhotoRequested(
                file: File(pickedFile.path),
                isCover: isCover,
              ),
            );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to pick image: $e')),
        );
      }
    }
  }

  Future<void> _pickAndUploadVideo() async {
    try {
      final pickedFile = await _picker.pickVideo(source: ImageSource.gallery);
      if (pickedFile != null && mounted) {
        context.read<ProfileEditBloc>().add(
              ProfileUploadVideoRequested(
                file: File(pickedFile.path),
              ),
            );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to pick video: $e')),
        );
      }
    }
  }

  void _showMediaSourceSheet({required bool isCover, bool isVideo = false}) {
    if (isVideo) {
      _pickAndUploadVideo();
      return;
    }

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusLg)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.photo_library_outlined, color: AppColor.primary),
                  title: const Text('Choose from Gallery'),
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    _pickAndUploadImage(source: ImageSource.gallery, isCover: isCover);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.camera_alt_outlined, color: AppColor.primary),
                  title: const Text('Take a Photo'),
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    _pickAndUploadImage(source: ImageSource.camera, isCover: isCover);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        title: Text(
          'Media & Portfolio',
          style: AppTypography.titleMedium.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColor.textPrimary,
          ),
        ),
        centerTitle: false,
        backgroundColor: AppColor.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: AppColor.textPrimary),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ),
      body: BlocConsumer<ProfileEditBloc, ProfileEditState>(
        listener: (context, state) {
          if (state.status == ProfileEditStatus.uploaded) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.successMessage ?? 'Media updated successfully!'),
                backgroundColor: const Color(0xFF10B981),
              ),
            );
          } else if (state.status == ProfileEditStatus.failure && state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          final isUploading = state.status == ProfileEditStatus.uploading;
          final currentProfile = state.updatedProfile ?? widget.profile;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isUploading) ...[
                  const LinearProgressIndicator(color: AppColor.primary),
                  const SizedBox(height: AppSpacing.sm),
                ],

                // Profile Photo Card
                _buildMediaSection(
                  title: 'Profile Photo',
                  subtitle: 'Recommended size: 400x400px (Square)',
                  imageUrl: currentProfile.profilePhotoUrl,
                  isAvatar: true,
                  onUpload: () => _showMediaSourceSheet(isCover: false),
                ),
                const SizedBox(height: AppSpacing.md),

                // Cover Photo Card
                _buildMediaSection(
                  title: 'Cover Banner Photo',
                  subtitle: 'Recommended size: 1200x400px (3:1 aspect ratio)',
                  imageUrl: currentProfile.coverPhotoUrl,
                  isAvatar: false,
                  onUpload: () => _showMediaSourceSheet(isCover: true),
                ),
                const SizedBox(height: AppSpacing.md),

                // Profile Video
                _buildVideoSection(
                  title: 'Profile Introduction Video',
                  subtitle: 'Upload a 30-60 second pitch video introducing yourself',
                  videoUrl: currentProfile.profileVideoUrl,
                  onUpload: () => _showMediaSourceSheet(isCover: false, isVideo: true),
                ),
                const SizedBox(height: AppSpacing.md),

                // Portfolio Items
                _buildPortfolioGallery(currentProfile.media),
                const SizedBox(height: AppSpacing.xl),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMediaSection({
    required String title,
    required String subtitle,
    required String? imageUrl,
    required bool isAvatar,
    required VoidCallback onUpload,
  }) {
    final hasImage = imageUrl != null && imageUrl.isNotEmpty;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColor.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTypography.labelLarge.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColor.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColor.textTertiary,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              OutlinedButton.icon(
                onPressed: onUpload,
                icon: const Icon(Icons.upload_rounded, size: 14),
                label: Text(hasImage ? 'Change' : 'Upload'),
                style: OutlinedButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          if (hasImage)
            isAvatar
                ? Center(
                    child: CircleAvatar(
                      radius: 40,
                      backgroundImage: CachedNetworkImageProvider(imageUrl),
                    ),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    child: SizedBox(
                      height: 120,
                      width: double.infinity,
                      child: CachedNetworkImage(
                        imageUrl: imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
          else
            Container(
              height: isAvatar ? 80 : 100,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColor.backgroundSubtle,
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                border: Border.all(color: AppColor.borderSubtle, style: BorderStyle.solid),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      isAvatar ? Icons.account_circle_outlined : Icons.image_outlined,
                      size: 28,
                      color: AppColor.textTertiary,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'No image uploaded',
                      style: AppTypography.labelSmall.copyWith(color: AppColor.textTertiary),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildVideoSection({
    required String title,
    required String subtitle,
    required String? videoUrl,
    required VoidCallback onUpload,
  }) {
    final hasVideo = videoUrl != null && videoUrl.isNotEmpty;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColor.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTypography.labelLarge.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColor.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColor.textTertiary,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
              OutlinedButton.icon(
                onPressed: onUpload,
                icon: const Icon(Icons.video_call_rounded, size: 16),
                label: Text(hasVideo ? 'Change' : 'Upload'),
                style: OutlinedButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Container(
            height: 100,
            width: double.infinity,
            decoration: BoxDecoration(
              color: hasVideo ? AppColor.black : AppColor.backgroundSubtle,
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: Center(
              child: hasVideo
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.play_circle_fill, color: Colors.white, size: 28),
                        const SizedBox(width: 8),
                        Text(
                          'Introduction Video Attached',
                          style: AppTypography.labelMedium.copyWith(color: Colors.white),
                        ),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.videocam_outlined, size: 28, color: AppColor.textTertiary),
                        const SizedBox(height: 4),
                        Text(
                          'No intro video uploaded',
                          style: AppTypography.labelSmall.copyWith(color: AppColor.textTertiary),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPortfolioGallery(List<MediaItemEntity> media) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColor.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Portfolio & Work Gallery (${media.length})',
                style: AppTypography.labelLarge.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColor.textPrimary,
                ),
              ),
              InkWell(
                onTap: () => _showMediaSourceSheet(isCover: false),
                borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  child: Row(
                    children: [
                      const Icon(Icons.add_photo_alternate_outlined, size: 14, color: AppColor.primary),
                      const SizedBox(width: 2),
                      Text(
                        'Add',
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColor.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          if (media.isEmpty)
            Container(
              height: 80,
              decoration: BoxDecoration(
                color: AppColor.backgroundSubtle,
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              child: Center(
                child: Text(
                  'No portfolio items added yet.',
                  style: AppTypography.labelSmall.copyWith(color: AppColor.textTertiary),
                ),
              ),
            )
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 6,
                mainAxisSpacing: 6,
                childAspectRatio: 1,
              ),
              itemCount: media.length,
              itemBuilder: (context, index) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  child: CachedNetworkImage(
                    imageUrl: media[index].url,
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
