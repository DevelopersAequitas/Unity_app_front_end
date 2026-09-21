import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/profile_entity.dart';
import '../bloc/profile_edit_bloc.dart';
import '../bloc/profile_edit_event.dart';
import '../bloc/profile_edit_state.dart';
import '../widgets/profile_chip_input.dart';

class EditInterestsGoalsScreen extends StatefulWidget {
  final ProfileEntity profile;

  const EditInterestsGoalsScreen({
    super.key,
    required this.profile,
  });

  @override
  State<EditInterestsGoalsScreen> createState() => _EditInterestsGoalsScreenState();
}

class _EditInterestsGoalsScreenState extends State<EditInterestsGoalsScreen> {
  List<String> _interests = [];
  List<String> _iCanHelpWith = [];
  List<String> _iAmLookingFor = [];
  List<String> _collaborationGoals = [];
  List<String> _sustainabilityAreas = [];
  bool _willingToMentor = false;
  bool _openToCrossCityCollaboration = false;
  bool _openToSpeakingAtEvents = false;

  @override
  void initState() {
    super.initState();
    final p = widget.profile;
    _interests = List<String>.from(p.interests);
    _iCanHelpWith = List<String>.from(p.iCanHelpWith);
    _iAmLookingFor = List<String>.from(p.iAmLookingFor);
    _collaborationGoals = List<String>.from(p.collaborationGoals);
    _sustainabilityAreas = List<String>.from(p.sustainabilityAreas);
    _willingToMentor = p.willingToMentor;
    _openToCrossCityCollaboration = p.openToCrossCityCollaboration;
    _openToSpeakingAtEvents = p.openToSpeakingAtEvents;
  }

  void _saveChanges() {
    final payload = <String, dynamic>{
      'interests': _interests,
      'i_can_help_with': _iCanHelpWith,
      'i_am_looking_for': _iAmLookingFor,
      'collaboration_goals': _collaborationGoals,
      'sustainability_areas': _sustainabilityAreas,
      'willing_to_mentor': _willingToMentor,
      'open_to_cross_city_collaboration': _openToCrossCityCollaboration,
      'open_to_speaking_at_events': _openToSpeakingAtEvents,
    };

    context.read<ProfileEditBloc>().add(
          ProfileSaveSectionRequested(
            sectionName: 'Interests & Goals',
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
          'Interests & Goals',
          style: AppTypography.titleMedium.copyWith(
            fontWeight: FontWeight.w500,
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
                content: Text(state.successMessage ?? 'Interests & goals updated successfully!'),
                backgroundColor: const Color(0xFF10B981),
              ),
            );
            Navigator.of(context).pop();
          } else if (state.status == ProfileEditStatus.failure && state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage!), backgroundColor: Colors.red),
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
                ProfileChipInput(
                  label: 'General Interests',
                  items: _interests,
                  hintText: 'e.g. Technology, Education',
                  accentColor: AppColor.primaryBlue,
                  onChanged: (updated) => setState(() => _interests = updated),
                ),
                const SizedBox(height: AppSpacing.md),
                ProfileChipInput(
                  label: 'I Can Help With',
                  items: _iCanHelpWith,
                  hintText: 'e.g. Business Strategy, Pitching',
                  accentColor: const Color(0xFF10B981),
                  onChanged: (updated) => setState(() => _iCanHelpWith = updated),
                ),
                const SizedBox(height: AppSpacing.md),
                ProfileChipInput(
                  label: 'I Am Looking For',
                  items: _iAmLookingFor,
                  hintText: 'e.g. Co-Founders, Tech Talent',
                  accentColor: const Color(0xFF8B5CF6),
                  onChanged: (updated) => setState(() => _iAmLookingFor = updated),
                ),
                const SizedBox(height: AppSpacing.md),
                ProfileChipInput(
                  label: 'Collaboration Goals',
                  items: _collaborationGoals,
                  hintText: 'e.g. Joint Ventures, Co-Marketing',
                  accentColor: AppColor.primaryPink,
                  onChanged: (updated) => setState(() => _collaborationGoals = updated),
                ),
                const SizedBox(height: AppSpacing.md),
                ProfileChipInput(
                  label: 'Sustainability Areas',
                  items: _sustainabilityAreas,
                  hintText: 'e.g. Clean Energy, Waste Reduction',
                  accentColor: const Color(0xFF059669),
                  onChanged: (updated) => setState(() => _sustainabilityAreas = updated),
                ),
                const SizedBox(height: AppSpacing.md),

                // Networking Preferences
                Text(
                  'NETWORKING PREFERENCES',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColor.textTertiary,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                _buildSwitchTile('Willing to Mentor', _willingToMentor, (v) => setState(() => _willingToMentor = v)),
                _buildSwitchTile('Open to Cross-City Collab', _openToCrossCityCollaboration, (v) => setState(() => _openToCrossCityCollaboration = v)),
                _buildSwitchTile('Open to Speaking at Events', _openToSpeakingAtEvents, (v) => setState(() => _openToSpeakingAtEvents = v)),
                const SizedBox(height: AppSpacing.xl),

                // Save Changes CTA
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: isSaving ? null : _saveChanges,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.primaryBlue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    ),
                    child: isSaving
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : Text('Save Changes', style: AppTypography.labelLarge.copyWith(color: Colors.white, fontWeight: FontWeight.w500)),
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

  Widget _buildSwitchTile(String title, bool value, ValueChanged<bool> onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColor.borderSubtle),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w500, color: AppColor.textPrimary)),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: AppColor.primaryBlue,
          ),
        ],
      ),
    );
  }
}
