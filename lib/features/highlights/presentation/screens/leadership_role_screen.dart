import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/paywall_gate_helper.dart';
import '../../../../core/widgets/app_common_bar.dart';
import '../../../../core/widgets/app_gradient_background.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/responsive_container.dart';
import '../../../profile/presentation/bloc/profile_bloc.dart';
import '../../../profile/presentation/bloc/profile_event.dart';
import '../../domain/entities/leadership_interest_entity.dart';
import '../bloc/leadership_role/leadership_role_bloc.dart';
import '../bloc/leadership_role/leadership_role_event.dart';
import '../bloc/leadership_role/leadership_role_state.dart';
import '../widgets/certification_info_banner.dart';
import '../widgets/leadership_role_form_fields.dart';
import '../widgets/leadership_type_selector.dart';
import '../widgets/nominate_peer_form_fields.dart';

class LeadershipRoleScreen extends StatefulWidget {
  const LeadershipRoleScreen({super.key});

  @override
  State<LeadershipRoleScreen> createState() => _LeadershipRoleScreenState();
}

class _LeadershipRoleScreenState extends State<LeadershipRoleScreen> {
  String _applyingFor = 'myself';
  final _referredNameController = TextEditingController();
  final _referredMobileController = TextEditingController();
  String? _selectedRole = 'CF';
  final _cityController = TextEditingController();
  final _domainController = TextEditingController();
  final _whyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _prefillFromProfile();
  }

  void _prefillFromProfile() {
    final profileState = context.read<ProfileBloc>().state;
    if (profileState.profile == null) {
      context.read<ProfileBloc>().add(const ProfileFetchRequested());
      return;
    }
    final p = profileState.profile!;
    if (_cityController.text.isEmpty) {
      _cityController.text = p.city?.name ?? p.businessCity ?? p.state ?? '';
    }
    if (_domainController.text.isEmpty) {
      _domainController.text = p.mainBusinessCategory ?? p.businessCategory ?? p.skills.join(', ');
    }
  }

  @override
  void dispose() {
    _referredNameController.dispose();
    _referredMobileController.dispose();
    _cityController.dispose();
    _domainController.dispose();
    _whyController.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    if (!PaywallGateHelper.checkPro(context, message: 'Upgrade to Pro to apply for leadership roles.')) {
      return;
    }

    if (_applyingFor == 'referring_friend') {
      if (_referredNameController.text.trim().isEmpty || _referredMobileController.text.trim().isEmpty) {
        AppSnackBar.showError(context, 'Please enter referred peer name and mobile.');
        return;
      }
      context.read<LeadershipRoleBloc>().add(
            SubmitLeadershipRoleInterestEvent(
              LeadershipInterestEntity(
                applyingFor: 'referring_friend',
                referredName: _referredNameController.text.trim(),
                referredMobile: _referredMobileController.text.trim(),
              ),
            ),
          );
    } else {
      if (_cityController.text.trim().isEmpty || _domainController.text.trim().isEmpty) {
        AppSnackBar.showError(context, 'Please fill in city and primary domain.');
        return;
      }
      context.read<LeadershipRoleBloc>().add(
            SubmitLeadershipRoleInterestEvent(
              LeadershipInterestEntity(
                applyingFor: 'myself',
                leadershipRole: _selectedRole,
                contributeCity: _cityController.text.trim(),
                primaryDomain: _domainController.text.trim(),
                whyInterested: _whyController.text.trim(),
                excitement: 'building_people',
                ownership: 'yes',
                timeCommitment: '6_10_hours',
                hasLedBefore: true,
              ),
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppCommonBar(
        title: 'Leadership Roles',
        showBack: Navigator.canPop(context),
        onBackTap: Navigator.canPop(context) ? () => Navigator.pop(context) : null,
      ),
      body: AppGradientBackground(
        child: ResponsiveContainer(
          child: BlocConsumer<LeadershipRoleBloc, LeadershipRoleState>(
            listener: (context, state) {
              if (state.status == LeadershipRoleStatus.success && state.successMessage != null) {
                AppSnackBar.showSuccess(context, state.successMessage!);
                Navigator.pop(context);
              } else if (state.errorMessage != null) {
                AppSnackBar.showError(context, state.errorMessage!);
              }
            },
            builder: (context, state) {
              final isSubmitting = state.status == LeadershipRoleStatus.submitting;

              return ListView(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                children: [
                  const CertificationInfoBanner(
                    title: 'Lead in Peers Global Unity',
                    description: 'Express interest to hold key regional or circle leadership roles and shape ecosystem growth.',
                    icon: Icons.military_tech_outlined,
                  ),
                  const SizedBox(height: 14),
                  LeadershipTypeSelector(
                    selectedType: _applyingFor,
                    onTypeChanged: (val) => setState(() => _applyingFor = val),
                  ),
                  const SizedBox(height: 14),
                  if (_applyingFor == 'referring_friend')
                    NominatePeerFormFields(
                      nameController: _referredNameController,
                      mobileController: _referredMobileController,
                    )
                  else
                    LeadershipRoleFormFields(
                      selectedRole: _selectedRole,
                      onRoleChanged: (val) => setState(() => _selectedRole = val),
                      cityController: _cityController,
                      domainController: _domainController,
                      whyController: _whyController,
                    ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: ElevatedButton(
                      onPressed: isSubmitting ? null : () => _submit(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.primaryBlue,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: isSubmitting
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : Text(
                              _applyingFor == 'referring_friend' ? 'Nominate Peer' : 'Submit Application',
                              style: AppTypography.labelLarge.copyWith(color: Colors.white, fontWeight: FontWeight.w500),
                            ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
