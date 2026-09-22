import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../domain/entities/profile_entity.dart';
import '../bloc/profile_edit_bloc.dart';
import '../bloc/profile_edit_event.dart';
import '../bloc/profile_edit_state.dart';

class EditAdditionalInfoScreen extends StatefulWidget {
  final ProfileEntity profile;

  const EditAdditionalInfoScreen({
    super.key,
    required this.profile,
  });

  @override
  State<EditAdditionalInfoScreen> createState() => _EditAdditionalInfoScreenState();
}

class _EditAdditionalInfoScreenState extends State<EditAdditionalInfoScreen> {
  late TextEditingController _bioController;
  late TextEditingController _superpowerController;

  String? _preferredMeetingFormat;
  String? _contactVisibility;
  String? _directoryListing;

  bool _willingToMentor = false;
  bool _openToCrossCityCollaboration = false;
  bool _openToSpeakingAtEvents = false;

  final List<String> _meetingFormats = ['Video Call', 'In Person', 'Phone Call', 'Hybrid'];
  final List<String> _contactVisibilities = ['public', 'connected_only', 'private'];
  final List<String> _directoryOptions = ['Yes', 'No', 'Members Only'];

  @override
  void initState() {
    super.initState();
    final p = widget.profile;
    _bioController = TextEditingController(text: p.bio ?? '');
    _superpowerController = TextEditingController(text: p.superpower ?? '');

    _preferredMeetingFormat = p.preferredMeetingFormat ?? 'Video Call';
    _contactVisibility = p.contactVisibility ?? 'connected_only';
    _directoryListing = p.communityDirectoryListing ?? 'Yes';

    _willingToMentor = p.willingToMentor;
    _openToCrossCityCollaboration = p.openToCrossCityCollaboration;
    _openToSpeakingAtEvents = p.openToSpeakingAtEvents;
  }

  @override
  void dispose() {
    _bioController.dispose();
    _superpowerController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    final payload = <String, dynamic>{
      'bio': _bioController.text.trim(),
      'superpower': _superpowerController.text.trim(),
      'preferred_meeting_format': _preferredMeetingFormat,
      'contact_visibility': _contactVisibility,
      'community_directory_listing': _directoryListing,
      'willing_to_mentor': _willingToMentor,
      'open_to_cross_city_collaboration': _openToCrossCityCollaboration,
      'open_to_speaking_at_events': _openToSpeakingAtEvents,
    };

    context.read<ProfileEditBloc>().add(
          ProfileSaveSectionRequested(
            sectionName: 'Additional Information',
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
          'Additional Information',
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
        listenWhen: (previous, current) =>
            previous.status != current.status &&
            (current.status == ProfileEditStatus.saved ||
                current.status == ProfileEditStatus.failure),
        listener: (context, state) {
          if (state.status == ProfileEditStatus.saved) {
            AppSnackBar.showSuccess(
              context,
              state.successMessage ?? 'Additional information updated successfully!',
            );
            context.read<ProfileEditBloc>().add(const ProfileEditResetRequested());
            Navigator.of(context).pop();
          } else if (state.status == ProfileEditStatus.failure && state.errorMessage != null) {
            AppSnackBar.showError(context, state.errorMessage!);
            context.read<ProfileEditBloc>().add(const ProfileEditResetRequested());
          }
        },
        builder: (context, state) {
          final isSaving = state.status == ProfileEditStatus.saving;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextField(
                  controller: _bioController,
                  label: 'Bio',
                  hintText: 'A short overview about you and your journey...',
                  maxLines: 4,
                ),
                const SizedBox(height: AppSpacing.sm),

                _buildTextField(
                  controller: _superpowerController,
                  label: 'My Superpower',
                  hintText: 'e.g. Rapid Problem Solver, Master Networker',
                ),
                const SizedBox(height: AppSpacing.sm),

                _buildDropdown(
                  label: 'Preferred Meeting Format',
                  value: _preferredMeetingFormat,
                  items: _meetingFormats,
                  onChanged: (v) => setState(() => _preferredMeetingFormat = v),
                ),
                const SizedBox(height: AppSpacing.sm),

                _buildDropdown(
                  label: 'Contact Visibility',
                  value: _contactVisibility,
                  items: _contactVisibilities,
                  onChanged: (v) => setState(() => _contactVisibility = v),
                ),
                const SizedBox(height: AppSpacing.sm),

                _buildDropdown(
                  label: 'Directory Listing',
                  value: _directoryListing,
                  items: _directoryOptions,
                  onChanged: (v) => setState(() => _directoryListing = v),
                ),
                const SizedBox(height: AppSpacing.md),

                // Community Availability Toggles
                Text(
                  'COMMUNITY PREFERENCES',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColor.textTertiary,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),

                _buildToggleCard(
                  title: 'Willing to Mentor',
                  subtitle: 'Open to mentoring peers in your expertise area',
                  value: _willingToMentor,
                  onChanged: (v) => setState(() => _willingToMentor = v),
                ),
                const SizedBox(height: AppSpacing.xs),

                _buildToggleCard(
                  title: 'Cross-City Collaboration',
                  subtitle: 'Open to working on initiatives across chapters',
                  value: _openToCrossCityCollaboration,
                  onChanged: (v) => setState(() => _openToCrossCityCollaboration = v),
                ),
                const SizedBox(height: AppSpacing.xs),

                _buildToggleCard(
                  title: 'Speaking at Events',
                  subtitle: 'Interested in keynote/panel speaker opportunities',
                  value: _openToSpeakingAtEvents,
                  onChanged: (v) => setState(() => _openToSpeakingAtEvents = v),
                ),
                const SizedBox(height: AppSpacing.xl),

                // Save Changes CTA
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hintText,
    int maxLines = 1,
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
          maxLines: maxLines,
          style: AppTypography.bodyMedium.copyWith(color: AppColor.textPrimary),
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColor.white,
            hintText: hintText,
            hintStyle: AppTypography.bodySmall.copyWith(color: AppColor.textTertiary),
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

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
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
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            border: Border.all(color: AppColor.borderSubtle),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: items.contains(value) ? value : null,
              items: items
                  .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(e, style: AppTypography.bodySmall),
                      ))
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildToggleCard({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs + 2),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColor.borderSubtle),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: AppTypography.labelLarge.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColor.textPrimary,
                    fontSize: 13,
                  ),
                ),
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
          Switch.adaptive(
            value: value,
            activeTrackColor: AppColor.primary,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
