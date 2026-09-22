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
import '../widgets/profile_chip_input.dart';

class EditProfessionalJourneyScreen extends StatefulWidget {
  final ProfileEntity profile;

  const EditProfessionalJourneyScreen({
    super.key,
    required this.profile,
  });

  @override
  State<EditProfessionalJourneyScreen> createState() => _EditProfessionalJourneyScreenState();
}

class _EditProfessionalJourneyScreenState extends State<EditProfessionalJourneyScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _experienceYearsController;
  late TextEditingController _experienceSummaryController;

  List<String> _skills = [];
  List<String> _leadershipRoles = [];
  List<String> _specialRecognitions = [];

  @override
  void initState() {
    super.initState();
    final p = widget.profile;
    _experienceYearsController =
        TextEditingController(text: p.experienceYears != null ? '${p.experienceYears}' : '');
    _experienceSummaryController = TextEditingController(text: p.experienceSummary ?? '');
    _skills = List<String>.from(p.skills);
    _leadershipRoles = List<String>.from(p.leadershipRoles);
    _specialRecognitions = List<String>.from(p.specialRecognitions);
  }

  @override
  void dispose() {
    _experienceYearsController.dispose();
    _experienceSummaryController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    if (!_formKey.currentState!.validate()) return;

    final years = int.tryParse(_experienceYearsController.text.trim());

    final payload = <String, dynamic>{
      'experience_years': years,
      'experience_summary': _experienceSummaryController.text.trim(),
      'skills': _skills,
      'leadership_roles': _leadershipRoles,
      'special_recognitions': _specialRecognitions,
    };

    context.read<ProfileEditBloc>().add(
          ProfileSaveSectionRequested(
            sectionName: 'Professional Journey',
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
          'Professional Journey',
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
              state.successMessage ?? 'Professional journey updated successfully!',
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

          return Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTextField(
                    controller: _experienceYearsController,
                    label: 'Total Experience (Years)',
                    keyboardType: TextInputType.number,
                    hintText: 'e.g. 5',
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  _buildTextField(
                    controller: _experienceSummaryController,
                    label: 'Experience Summary',
                    hintText: 'Brief summary of your background and achievements...',
                    maxLines: 4,
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Skills & Expertise
                  ProfileChipInput(
                    label: 'Skills & Expertise',
                    items: _skills,
                    hintText: 'e.g. Project Management, Flutter',
                    accentColor: AppColor.primary,
                    onChanged: (updated) {
                      setState(() {
                        _skills = updated;
                      });
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Leadership Roles
                  ProfileChipInput(
                    label: 'Leadership Roles',
                    items: _leadershipRoles,
                    hintText: 'e.g. Chapter President, Tech Lead',
                    accentColor: const Color(0xFF10B981),
                    onChanged: (updated) {
                      setState(() {
                        _leadershipRoles = updated;
                      });
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Special Recognitions
                  ProfileChipInput(
                    label: 'Special Recognitions & Awards',
                    items: _specialRecognitions,
                    hintText: 'e.g. Speaker of the Year 2024',
                    accentColor: const Color(0xFFF59E0B),
                    onChanged: (updated) {
                      setState(() {
                        _specialRecognitions = updated;
                      });
                    },
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
    TextInputType? keyboardType,
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
          keyboardType: keyboardType,
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
}
