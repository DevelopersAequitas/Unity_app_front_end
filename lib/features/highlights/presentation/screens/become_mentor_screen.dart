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
import '../../domain/entities/mentor_submission_entity.dart';
import '../bloc/mentor/mentor_bloc.dart';
import '../bloc/mentor/mentor_event.dart';
import '../bloc/mentor/mentor_state.dart';
import '../widgets/become_mentor_history_list.dart';
import '../widgets/highlight_segmented_tab_bar.dart';
import '../widgets/mentor_form_tab.dart';

class BecomeMentorScreen extends StatefulWidget {
  const BecomeMentorScreen({super.key});

  @override
  State<BecomeMentorScreen> createState() => _BecomeMentorScreenState();
}

class _BecomeMentorScreenState extends State<BecomeMentorScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final _formKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cityController = TextEditingController();
  final _linkedinController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    context.read<MentorBloc>().add(const FetchMentorHistoryEvent());
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
    if (_linkedinController.text.isEmpty && p.socialLinks?.linkedin != null) {
      _linkedinController.text = p.socialLinks!.linkedin!;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
    _linkedinController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    if (!PaywallGateHelper.checkPro(context, message: 'Upgrade to Pro to apply as a mentor.')) {
      return;
    }

    final entity = MentorSubmissionEntity(
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      city: _cityController.text.trim(),
      linkedinProfile: _linkedinController.text.trim(),
    );

    context.read<MentorBloc>().add(SubmitMentorApplicationEvent(entity));
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
        BlocListener<MentorBloc, MentorState>(
          listenWhen: (prev, curr) =>
              prev.status != curr.status &&
              (curr.status == MentorStatus.success || curr.status == MentorStatus.error),
          listener: (context, state) {
            if (state.status == MentorStatus.success && state.successMessage != null) {
              AppSnackBar.showSuccess(context, state.successMessage!);
              _formKey.currentState?.reset();
              _tabController.animateTo(1);
            } else if (state.status == MentorStatus.error && state.errorMessage != null) {
              AppSnackBar.showError(context, state.errorMessage!);
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppCommonBar(
          title: 'Become a Mentor',
          showBack: Navigator.canPop(context),
          onBackTap: Navigator.canPop(context) ? () => Navigator.pop(context) : null,
        ),
        body: AppGradientBackground(
          child: ResponsiveContainer(
            child: BlocBuilder<MentorBloc, MentorState>(
              builder: (context, state) {
                return Column(
                  children: [
                    HighlightSegmentedTabBar(
                      controller: _tabController,
                      tabTitles: const ['Apply to Mentor', 'My Submissions'],
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          MentorFormTab(
                            formKey: _formKey,
                            firstNameController: _firstNameController,
                            lastNameController: _lastNameController,
                            emailController: _emailController,
                            phoneController: _phoneController,
                            cityController: _cityController,
                            linkedinController: _linkedinController,
                            state: state,
                            onSubmit: _submit,
                          ),
                          BecomeMentorHistoryList(
                            submissions: state.submissions,
                            isLoading: state.status == MentorStatus.loading,
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
