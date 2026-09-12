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
  List<String> _industriesOfInterest = [];
  List<String> _collaborationGoals = [];
  List<String> _sustainabilityAreas = [];
  List<String> _greenpreneurGoals = [];

  @override
  void initState() {
    super.initState();
    final p = widget.profile;
    _interests = List<String>.from(p.interests);
    _iCanHelpWith = List<String>.from(p.iCanHelpWith);
    _iAmLookingFor = List<String>.from(p.iAmLookingFor);
    _industriesOfInterest = List<String>.from(p.industriesOfInterest);
    _collaborationGoals = List<String>.from(p.collaborationGoals);
    _sustainabilityAreas = List<String>.from(p.sustainabilityAreas);
    _greenpreneurGoals = List<String>.from(p.greenpreneurGoals);
  }

  void _saveChanges() {
    final payload = <String, dynamic>{
      'interests': _interests,
      'i_can_help_with': _iCanHelpWith,
      'i_am_looking_for': _iAmLookingFor,
      'industries_of_interest': _industriesOfInterest,
      'collaboration_goals': _collaborationGoals,
      'sustainability_areas': _sustainabilityAreas,
      'greenpreneur_goals': _greenpreneurGoals,
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
                content: Text(state.successMessage ?? 'Interests & goals updated successfully!'),
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
                // General Interests
                ProfileChipInput(
                  label: 'General Interests',
                  items: _interests,
                  hintText: 'e.g. Technology, Education',
                  accentColor: AppColor.primary,
                  onChanged: (updated) => setState(() => _interests = updated),
                ),
                const SizedBox(height: AppSpacing.md),

                // I Can Help With
                ProfileChipInput(
                  label: 'I Can Help With',
                  items: _iCanHelpWith,
                  hintText: 'e.g. Business Strategy, Pitching',
                  accentColor: const Color(0xFF10B981),
                  onChanged: (updated) => setState(() => _iCanHelpWith = updated),
                ),
                const SizedBox(height: AppSpacing.md),

                // I Am Looking For
                ProfileChipInput(
                  label: 'I Am Looking For',
                  items: _iAmLookingFor,
                  hintText: 'e.g. Co-Founders, Tech Talent',
                  accentColor: const Color(0xFF8B5CF6),
                  onChanged: (updated) => setState(() => _iAmLookingFor = updated),
                ),
                const SizedBox(height: AppSpacing.md),

                // Industries of Interest
                ProfileChipInput(
                  label: 'Industries of Interest',
                  items: _industriesOfInterest,
                  hintText: 'e.g. Healthcare, Fintech',
                  accentColor: const Color(0xFF0284C7),
                  onChanged: (updated) => setState(() => _industriesOfInterest = updated),
                ),
                const SizedBox(height: AppSpacing.md),

                // Collaboration Goals
                ProfileChipInput(
                  label: 'Collaboration Goals',
                  items: _collaborationGoals,
                  hintText: 'e.g. Joint Ventures, Co-Marketing',
                  accentColor: AppColor.primaryGradientEnd,
                  onChanged: (updated) => setState(() => _collaborationGoals = updated),
                ),
                const SizedBox(height: AppSpacing.md),

                // Sustainability & Greenpreneur
                ProfileChipInput(
                  label: 'Sustainability Areas',
                  items: _sustainabilityAreas,
                  hintText: 'e.g. Clean Energy, Waste Reduction',
                  accentColor: const Color(0xFF059669),
                  onChanged: (updated) => setState(() => _sustainabilityAreas = updated),
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
}
