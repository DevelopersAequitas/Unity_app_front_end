import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/profile_entity.dart';
import '../bloc/profile_edit_bloc.dart';
import '../bloc/profile_edit_event.dart';
import '../bloc/profile_edit_state.dart';

class EditSocialLinksScreen extends StatefulWidget {
  final ProfileEntity profile;

  const EditSocialLinksScreen({
    super.key,
    required this.profile,
  });

  @override
  State<EditSocialLinksScreen> createState() => _EditSocialLinksScreenState();
}

class _EditSocialLinksScreenState extends State<EditSocialLinksScreen> {
  late TextEditingController _websiteController;
  late TextEditingController _linkedinController;
  late TextEditingController _instagramController;
  late TextEditingController _twitterController;
  late TextEditingController _facebookController;
  late TextEditingController _youtubeController;
  late TextEditingController _otherWebsiteController;

  @override
  void initState() {
    super.initState();
    final p = widget.profile;
    _websiteController = TextEditingController(text: p.socialLinks?.website ?? p.businessWebsite ?? '');
    _linkedinController = TextEditingController(text: p.socialLinks?.linkedin ?? '');
    _instagramController = TextEditingController(text: p.socialLinks?.instagram ?? '');
    _twitterController = TextEditingController(text: p.socialLinks?.twitter ?? '');
    _facebookController = TextEditingController(text: p.socialLinks?.facebook ?? '');
    _youtubeController = TextEditingController(text: p.socialLinks?.youtube ?? '');
    _otherWebsiteController = TextEditingController(text: p.socialLinks?.otherWebsite ?? '');
  }

  @override
  void dispose() {
    _websiteController.dispose();
    _linkedinController.dispose();
    _instagramController.dispose();
    _twitterController.dispose();
    _facebookController.dispose();
    _youtubeController.dispose();
    _otherWebsiteController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    final payload = <String, dynamic>{
      'website': _websiteController.text.trim(),
      'linkedin_profile': _linkedinController.text.trim(),
      'instagram_handle': _instagramController.text.trim(),
      'twitter_handle': _twitterController.text.trim(),
      'facebook_profile': _facebookController.text.trim(),
      'youtube_channel': _youtubeController.text.trim(),
      'other_website': _otherWebsiteController.text.trim(),
      'social_links': {
        'website': _websiteController.text.trim(),
        'linkedin': _linkedinController.text.trim(),
        'instagram': _instagramController.text.trim(),
        'twitter': _twitterController.text.trim(),
        'facebook': _facebookController.text.trim(),
        'youtube': _youtubeController.text.trim(),
      },
    };

    context.read<ProfileEditBloc>().add(
          ProfileSaveSectionRequested(
            sectionName: 'Social & Links',
            updateData: payload,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        title: Text(
          'Social & Links',
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
          if (state.status == ProfileEditStatus.saved) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.successMessage ?? 'Social links updated successfully!'),
                backgroundColor: const Color(0xFF10B981),
              ),
            );
            Navigator.of(context).pop();
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
          final isSaving = state.status == ProfileEditStatus.saving;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSocialField(
                  controller: _websiteController,
                  label: 'Website',
                  icon: Icons.language_rounded,
                  hintText: 'https://yourdomain.com',
                ),
                const SizedBox(height: AppSpacing.sm),

                _buildSocialField(
                  controller: _linkedinController,
                  label: 'LinkedIn URL',
                  icon: Icons.link_rounded,
                  hintText: 'https://linkedin.com/in/username',
                ),
                const SizedBox(height: AppSpacing.sm),

                _buildSocialField(
                  controller: _instagramController,
                  label: 'Instagram URL',
                  icon: Icons.camera_alt_outlined,
                  hintText: 'https://instagram.com/username',
                ),
                const SizedBox(height: AppSpacing.sm),

                _buildSocialField(
                  controller: _twitterController,
                  label: 'Twitter / X URL',
                  icon: Icons.tag_rounded,
                  hintText: 'https://x.com/username',
                ),
                const SizedBox(height: AppSpacing.sm),

                _buildSocialField(
                  controller: _facebookController,
                  label: 'Facebook URL',
                  icon: Icons.public_rounded,
                  hintText: 'https://facebook.com/profile',
                ),
                const SizedBox(height: AppSpacing.sm),

                _buildSocialField(
                  controller: _youtubeController,
                  label: 'YouTube Channel',
                  icon: Icons.smart_display_outlined,
                  hintText: 'https://youtube.com/@channel',
                ),
                const SizedBox(height: AppSpacing.sm),

                _buildSocialField(
                  controller: _otherWebsiteController,
                  label: 'Other Website',
                  icon: Icons.open_in_new_rounded,
                  hintText: 'https://...',
                ),
                const SizedBox(height: AppSpacing.xl),

                // Save Button
                Container(
                  width: double.infinity,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: AppColor.brandGradient,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    boxShadow: [
                      BoxShadow(
                        color: AppColor.primary.withValues(alpha: 0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: isSaving ? null : _saveChanges,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      child: Center(
                        child: isSaving
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                'Save Changes',
                                style: AppTypography.labelLarge.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSocialField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String hintText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            color: AppColor.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        TextFormField(
          controller: controller,
          keyboardType: TextInputType.url,
          style: AppTypography.bodyMedium.copyWith(color: AppColor.textPrimary),
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColor.white,
            hintText: hintText,
            hintStyle: AppTypography.bodySmall.copyWith(color: AppColor.textTertiary),
            prefixIcon: Icon(icon, size: 18, color: AppColor.textTertiary),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              borderSide: const BorderSide(color: AppColor.borderSubtle),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              borderSide: const BorderSide(color: AppColor.borderSubtle),
            ),
          ),
        ),
      ],
    );
  }
}
