import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/app_common_bar.dart';
import '../../../../core/widgets/app_gradient_background.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/responsive_container.dart';
import '../../../profile/presentation/bloc/profile_bloc.dart';
import '../../../profile/presentation/bloc/profile_event.dart';
import '../../../profile/presentation/bloc/profile_state.dart';
import '../../domain/entities/vyapaar_jagat_story_entity.dart';
import '../bloc/vyapaar_jagat/vyapaar_jagat_bloc.dart';
import '../bloc/vyapaar_jagat/vyapaar_jagat_event.dart';
import '../bloc/vyapaar_jagat/vyapaar_jagat_state.dart';
import '../widgets/vyapaar_jagat_story_form_tab.dart';

class VyapaarJagatStoryScreen extends StatefulWidget {
  const VyapaarJagatStoryScreen({super.key});

  @override
  State<VyapaarJagatStoryScreen> createState() => _VyapaarJagatStoryScreenState();
}

class _VyapaarJagatStoryScreenState extends State<VyapaarJagatStoryScreen> {
  final _formKey = GlobalKey<FormState>();

  final _fullNameController = TextEditingController();
  final _designationController = TextEditingController();
  final _companyNameController = TextEditingController();
  final _websiteController = TextEditingController();
  final _journeyController = TextEditingController();
  final _businessDescController = TextEditingController();
  final _challengeController = TextEditingController();
  final _achievementController = TextEditingController();
  final _impactController = TextEditingController();
  final _goalsController = TextEditingController();
  final _adviceController = TextEditingController();
  final _linkedinController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<VyapaarJagatBloc>().add(const FetchStoryStatusEvent());
    _prefillFromProfile();
  }

  void _prefillFromProfile() {
    final profileState = context.read<ProfileBloc>().state;
    if (profileState.profile == null) {
      context.read<ProfileBloc>().add(const ProfileFetchRequested());
      return;
    }
    final p = profileState.profile!;
    if (_fullNameController.text.isEmpty) {
      _fullNameController.text = p.displayName;
    }
    if (_designationController.text.isEmpty && p.designation != null) {
      _designationController.text = p.designation!;
    }
    if (_companyNameController.text.isEmpty && p.companyName != null) {
      _companyNameController.text = p.companyName!;
    }
    if (_websiteController.text.isEmpty) {
      _websiteController.text = p.businessWebsite ?? p.socialLinks?.website ?? '';
    }
    if (_businessDescController.text.isEmpty) {
      _businessDescController.text = p.experienceSummary ?? p.bio ?? '';
    }
    if (_linkedinController.text.isEmpty && p.socialLinks?.linkedin != null) {
      _linkedinController.text = p.socialLinks!.linkedin!;
    }
    if (_impactController.text.isEmpty && p.lifeImpactedCount > 0) {
      _impactController.text = '${p.lifeImpactedCount} lives impacted across the network';
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _designationController.dispose();
    _companyNameController.dispose();
    _websiteController.dispose();
    _journeyController.dispose();
    _businessDescController.dispose();
    _challengeController.dispose();
    _achievementController.dispose();
    _impactController.dispose();
    _goalsController.dispose();
    _adviceController.dispose();
    _linkedinController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final entity = VyapaarJagatStoryEntity(
      fullName: _fullNameController.text.trim(),
      designation: _designationController.text.trim(),
      companyName: _companyNameController.text.trim(),
      website: _websiteController.text.trim(),
      entrepreneurialJourney: _journeyController.text.trim(),
      businessDescription: _businessDescController.text.trim(),
      biggestChallenge: _challengeController.text.trim(),
      biggestAchievement: _achievementController.text.trim(),
      businessImpact: _impactController.text.trim(),
      futureGoals: _goalsController.text.trim(),
      adviceForEntrepreneurs: _adviceController.text.trim(),
      linkedinUrl: _linkedinController.text.trim(),
      facebookUrl: '',
      instagramUrl: '',
      twitterUrl: '',
      consent: true,
    );

    context.read<VyapaarJagatBloc>().add(SubmitStoryEvent(entity));
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state.profile != null) _prefillFromProfile();
          },
        ),
        BlocListener<VyapaarJagatBloc, VyapaarJagatState>(
          listenWhen: (prev, curr) =>
              prev.status != curr.status &&
              (curr.status == VyapaarJagatStatus.success ||
                  curr.status == VyapaarJagatStatus.error),
          listener: (context, state) {
            if (state.status == VyapaarJagatStatus.success &&
                state.successMessage != null) {
              AppSnackBar.showSuccess(context, state.successMessage!);
              _formKey.currentState?.reset();
              _journeyController.clear();
              _challengeController.clear();
              _achievementController.clear();
              _goalsController.clear();
              _adviceController.clear();
            } else if (state.status == VyapaarJagatStatus.error &&
                state.errorMessage != null) {
              AppSnackBar.showError(context, state.errorMessage!);
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppCommonBar(
          title: 'Vyapaar Jagat Story',
          showBack: Navigator.canPop(context),
          showProfile: true,
          onProfileTap: () => Navigator.pushNamed(context, AppRoutes.profile),
          onBackTap: Navigator.canPop(context) ? () => Navigator.pop(context) : null,
        ),
        body: AppGradientBackground(
          child: ResponsiveContainer(
            child: BlocBuilder<VyapaarJagatBloc, VyapaarJagatState>(
              builder: (context, state) {
                return VyapaarJagatStoryFormTab(
                  formKey: _formKey,
                  fullNameController: _fullNameController,
                  designationController: _designationController,
                  companyNameController: _companyNameController,
                  websiteController: _websiteController,
                  journeyController: _journeyController,
                  businessDescController: _businessDescController,
                  challengeController: _challengeController,
                  achievementController: _achievementController,
                  impactController: _impactController,
                  goalsController: _goalsController,
                  adviceController: _adviceController,
                  linkedinController: _linkedinController,
                  state: state,
                  onSubmit: _submit,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
