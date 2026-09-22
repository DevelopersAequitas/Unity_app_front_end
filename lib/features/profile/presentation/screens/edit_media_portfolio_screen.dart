import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/image_source_picker_sheet.dart';
import '../../../../core/widgets/video_source_picker_sheet.dart';
import '../../domain/entities/profile_entity.dart';
import '../bloc/profile_edit_bloc.dart';
import '../bloc/profile_edit_event.dart';
import '../bloc/profile_edit_state.dart';

class EditMediaPortfolioScreen extends StatefulWidget {
  final ProfileEntity profile;

  const EditMediaPortfolioScreen({super.key, required this.profile});

  @override
  State<EditMediaPortfolioScreen> createState() => _EditMediaPortfolioScreenState();
}

class _EditMediaPortfolioScreenState extends State<EditMediaPortfolioScreen> {
  @override
  void dispose() {
    context.read<ProfileEditBloc>().add(const ProfileEditResetRequested());
    super.dispose();
  }

  Future<void> _pickAndUploadPhoto({required bool isCover}) async {
    try {
      final croppedFile = isCover
          ? await ImageSourcePickerSheet.showCoverPhotoCropper(context)
          : await ImageSourcePickerSheet.showProfilePhotoCropper(context);

      if (croppedFile != null && mounted) {
        context.read<ProfileEditBloc>().add(
              ProfileUploadPhotoRequested(
                file: File(croppedFile.path),
                isCover: isCover,
              ),
            );
      }
    } catch (e) {
      if (mounted) {
        AppSnackBar.showError(context, 'Failed to process image: $e');
      }
    }
  }

  Future<void> _pickAndUploadVideo() async {
    try {
      final pickedFile = await VideoSourcePickerSheet.show(
        context,
        maxDurationSeconds: 30,
      );
      if (pickedFile != null && mounted) {
        context.read<ProfileEditBloc>().add(
              ProfileUploadVideoRequested(file: File(pickedFile.path)),
            );
      }
    } catch (e) {
      if (mounted) {
        AppSnackBar.showError(context, 'Failed to process video: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.lightScaffoldBg,
      appBar: AppBar(
        title: Text(
          'Media & Portfolio',
          style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w500, color: AppColor.lightTextPrimary),
        ),
        centerTitle: false,
        backgroundColor: AppColor.lightSurface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: AppColor.lightTextPrimary),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ),
      body: BlocConsumer<ProfileEditBloc, ProfileEditState>(
        listenWhen: (previous, current) =>
            previous.status != current.status &&
            (current.status == ProfileEditStatus.uploaded ||
                current.status == ProfileEditStatus.failure),
        listener: (context, state) {
          if (state.status == ProfileEditStatus.uploaded) {
            AppSnackBar.showSuccess(
              context,
              state.successMessage ?? 'Media updated successfully!',
            );
            context.read<ProfileEditBloc>().add(const ProfileEditResetRequested());
          } else if (state.status == ProfileEditStatus.failure && state.errorMessage != null) {
            AppSnackBar.showError(context, state.errorMessage!);
            context.read<ProfileEditBloc>().add(const ProfileEditResetRequested());
          }
        },
        builder: (context, state) {
          final isUploading = state.status == ProfileEditStatus.uploading;
          final currentProfile = state.updatedProfile ?? widget.profile;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isUploading) ...[
                  _buildUploadProgress(state),
                  const SizedBox(height: 12),
                ],
                _buildMediaSection(
                  title: 'Profile Photo',
                  subtitle: 'Recommended size: 400x400px (1:1 Square)',
                  imageUrl: currentProfile.profilePhotoUrl,
                  isAvatar: true,
                  onUpload: () => _pickAndUploadPhoto(isCover: false),
                ),
                const SizedBox(height: 12),
                _buildMediaSection(
                  title: 'Cover Banner Photo',
                  subtitle: 'Recommended size: 1200x400px (3:1 banner)',
                  imageUrl: currentProfile.coverPhotoUrl,
                  isAvatar: false,
                  onUpload: () => _pickAndUploadPhoto(isCover: true),
                ),
                const SizedBox(height: 12),
                _buildVideoSection(
                  title: 'Profile Introduction Video',
                  subtitle: 'Record or upload a pitch video (Max 30 seconds)',
                  videoUrl: currentProfile.profileVideoUrl,
                  onUpload: _pickAndUploadVideo,
                ),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildUploadProgress(ProfileEditState state) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColor.lightSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColor.primaryBlue.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColor.primaryBlue),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Uploading ${state.uploadType ?? "Media"}... Please wait',
                  style: AppTypography.bodySmall.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColor.lightTextPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: const LinearProgressIndicator(
              backgroundColor: AppColor.lightSurfaceSubtle,
              valueColor: AlwaysStoppedAnimation<Color>(AppColor.primaryBlue),
              minHeight: 4,
            ),
          ),
        ],
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
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColor.lightSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColor.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w500, fontSize: 13, color: AppColor.lightTextPrimary)),
                    const SizedBox(height: 2),
                    Text(subtitle, style: AppTypography.bodySmall.copyWith(fontSize: 10.5, color: AppColor.lightTextTertiary)),
                  ],
                ),
              ),
              GestureDetector(
                onTap: onUpload,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    gradient: AppColor.brandGradient,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: AppColor.primaryPink.withValues(alpha: 0.25),
                        blurRadius: 4,
                        offset: const Offset(0, 1.5),
                      ),
                    ],
                  ),
                  child: Text(
                    hasImage ? 'Change' : 'Upload',
                    style: AppTypography.labelSmall.copyWith(fontSize: 11, fontWeight: FontWeight.w500, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (hasImage)
            isAvatar
                ? Center(
                    child: CircleAvatar(
                      radius: 36,
                      backgroundImage: CachedNetworkImageProvider(imageUrl),
                    ),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: SizedBox(
                      height: 110,
                      width: double.infinity,
                      child: CachedNetworkImage(imageUrl: imageUrl, fit: BoxFit.cover),
                    ),
                  )
          else
            Container(
              height: isAvatar ? 72 : 90,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColor.lightSurfaceSubtle,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Icon(isAvatar ? Icons.account_circle_outlined : Icons.image_outlined, size: 28, color: AppColor.lightTextTertiary),
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
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColor.lightSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColor.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w500, fontSize: 13, color: AppColor.lightTextPrimary)),
                    const SizedBox(height: 2),
                    Text(subtitle, style: AppTypography.bodySmall.copyWith(fontSize: 10.5, color: AppColor.lightTextTertiary)),
                  ],
                ),
              ),
              GestureDetector(
                onTap: onUpload,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    gradient: AppColor.brandGradient,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: AppColor.primaryPink.withValues(alpha: 0.25),
                        blurRadius: 4,
                        offset: const Offset(0, 1.5),
                      ),
                    ],
                  ),
                  child: Text(
                    hasVideo ? 'Change' : 'Upload',
                    style: AppTypography.labelSmall.copyWith(fontSize: 11, fontWeight: FontWeight.w500, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            height: 90,
            width: double.infinity,
            decoration: BoxDecoration(
              color: hasVideo ? Colors.black : AppColor.lightSurfaceSubtle,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: hasVideo
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.play_circle_fill, color: Colors.white, size: 24),
                        const SizedBox(width: 8),
                        Text('Intro Video Attached', style: AppTypography.bodySmall.copyWith(color: Colors.white, fontWeight: FontWeight.w500)),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.videocam_outlined, size: 24, color: AppColor.lightTextTertiary),
                        const SizedBox(height: 2),
                        Text('No intro video attached', style: AppTypography.bodySmall.copyWith(fontSize: 11, color: AppColor.lightTextTertiary)),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
