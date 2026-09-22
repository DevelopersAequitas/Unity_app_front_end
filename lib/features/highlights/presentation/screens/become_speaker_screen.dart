import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/paywall_gate_helper.dart';
import '../../../../core/widgets/app_common_bar.dart';
import '../../../../core/widgets/app_gradient_background.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/responsive_container.dart';
import '../../../profile/presentation/bloc/profile_bloc.dart';
import '../../../profile/presentation/bloc/profile_event.dart';
import '../../../profile/presentation/bloc/profile_state.dart';
import '../../domain/entities/speaker_submission_entity.dart';
import '../bloc/speaker/speaker_bloc.dart';
import '../bloc/speaker/speaker_event.dart';
import '../bloc/speaker/speaker_state.dart';
import '../widgets/become_speaker_history_list.dart';
import '../widgets/highlight_segmented_tab_bar.dart';
import '../widgets/speaker_form_tab.dart';

class BecomeSpeakerScreen extends StatefulWidget {
  const BecomeSpeakerScreen({super.key});

  @override
  State<BecomeSpeakerScreen> createState() => _BecomeSpeakerScreenState();
}

class _BecomeSpeakerScreenState extends State<BecomeSpeakerScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final _formKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cityController = TextEditingController();
  final _companyController = TextEditingController();
  final _designationController = TextEditingController();
  final _topicController = TextEditingController();
  final _linkedinController = TextEditingController();
  final _bioController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    context.read<SpeakerBloc>().add(const FetchSpeakerHistoryEvent());
    _prefillFromProfile();
  }

  void _prefillFromProfile() {
    final profileState = context.read<ProfileBloc>().state;
    if (profileState.profile == null) {
      context.read<ProfileBloc>().add(const ProfileFetchRequested());
      return;
    }
    final p = profileState.profile!;
    if (_firstNameController.text.isEmpty) {
      _firstNameController.text = p.firstName ?? (p.displayName.isNotEmpty ? p.displayName.split(' ').first : '');
    }
    if (_lastNameController.text.isEmpty) {
      final parts = p.displayName.trim().split(' ');
      _lastNameController.text = p.lastName ?? (parts.length > 1 ? parts.sublist(1).join(' ') : '');
    }
    if (_emailController.text.isEmpty && p.email != null) _emailController.text = p.email!;
    if (_phoneController.text.isEmpty && p.phone != null) _phoneController.text = p.phone!;
    if (_cityController.text.isEmpty) {
      _cityController.text = p.city?.formattedLocation ?? p.city?.name ?? p.businessCity ?? p.state ?? '';
    }
    if (_companyController.text.isEmpty && p.companyName != null) _companyController.text = p.companyName!;
    if (_designationController.text.isEmpty && p.designation != null) _designationController.text = p.designation!;
    if (_topicController.text.isEmpty) {
      final topics = [
        if (p.skills.isNotEmpty) p.skills.join(', '),
        if (p.industryTags.isNotEmpty) p.industryTags.join(', '),
        if (p.businessCategory != null && p.businessCategory!.isNotEmpty) p.businessCategory!,
      ].where((s) => s.isNotEmpty).join(', ');
      if (topics.isNotEmpty) _topicController.text = topics;
    }
    if (_linkedinController.text.isEmpty && p.socialLinks?.linkedin != null) {
      _linkedinController.text = p.socialLinks!.linkedin!;
    }
    if (_bioController.text.isEmpty) {
      _bioController.text = p.bio ?? p.experienceSummary ?? '';
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    for (final c in [_firstNameController, _lastNameController, _emailController, _phoneController, _cityController, _companyController, _designationController, _topicController, _linkedinController, _bioController]) {
      c.dispose();
    }
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    if (!PaywallGateHelper.checkPro(context, message: 'Upgrade to Pro to apply as a speaker.')) {
      return;
    }

    final entity = SpeakerSubmissionEntity(
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      city: _cityController.text.trim(),
      company: _companyController.text.trim(),
      designation: _designationController.text.trim(),
      topicExpertise: _topicController.text.trim(),
      linkedinProfile: _linkedinController.text.trim(),
      briefBio: _bioController.text.trim().isNotEmpty ? _bioController.text.trim() : null,
    );

    context.read<SpeakerBloc>().add(SubmitSpeakerApplicationEvent(entity: entity));
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
        BlocListener<SpeakerBloc, SpeakerState>(
          listenWhen: (prev, curr) =>
              prev.status != curr.status &&
              (curr.status == SpeakerStatus.success || curr.status == SpeakerStatus.error),
          listener: (context, state) {
            if (state.status == SpeakerStatus.success && state.successMessage != null) {
              AppSnackBar.showSuccess(context, state.successMessage!);
              _formKey.currentState?.reset();
              _tabController.animateTo(1);
            } else if (state.status == SpeakerStatus.error && state.errorMessage != null) {
              AppSnackBar.showError(context, state.errorMessage!);
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppCommonBar(
          title: 'Become a Speaker',
          showBack: Navigator.canPop(context),
          onBackTap: Navigator.canPop(context) ? () => Navigator.pop(context) : null,
        ),
        body: AppGradientBackground(
          child: ResponsiveContainer(
            child: BlocBuilder<SpeakerBloc, SpeakerState>(
              builder: (context, state) {
                return Column(
                  children: [
                    HighlightSegmentedTabBar(
                      controller: _tabController,
                      tabTitles: const ['Apply as Speaker', 'My Submissions'],
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          SpeakerFormTab(
                            formKey: _formKey,
                            firstNameController: _firstNameController,
                            lastNameController: _lastNameController,
                            emailController: _emailController,
                            phoneController: _phoneController,
                            cityController: _cityController,
                            companyController: _companyController,
                            designationController: _designationController,
                            topicController: _topicController,
                            linkedinController: _linkedinController,
                            bioController: _bioController,
                            state: state,
                            onSubmit: _submit,
                          ),
                          BecomeSpeakerHistoryList(
                            submissions: state.submissions,
                            isLoading: state.status == SpeakerStatus.loading,
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
