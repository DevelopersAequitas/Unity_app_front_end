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
import '../../domain/entities/partner_with_us_entity.dart';
import '../bloc/partner_with_us/partner_with_us_bloc.dart';
import '../bloc/partner_with_us/partner_with_us_event.dart';
import '../bloc/partner_with_us/partner_with_us_state.dart';
import '../widgets/highlight_segmented_tab_bar.dart';
import '../widgets/partner_form_tab.dart';
import '../widgets/partner_with_us_history_list.dart';

class PartnerWithUsScreen extends StatefulWidget {
  const PartnerWithUsScreen({super.key});

  @override
  State<PartnerWithUsScreen> createState() => _PartnerWithUsScreenState();
}

class _PartnerWithUsScreenState extends State<PartnerWithUsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final _formKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _cityController = TextEditingController();
  final _brandController = TextEditingController();
  final _websiteController = TextEditingController();
  final _industryController = TextEditingController();
  final _aboutBusinessController = TextEditingController();
  final _partnershipGoalController = TextEditingController();
  final _whyPartnerController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    context.read<PartnerWithUsBloc>().add(const FetchPartnerWithUsHistoryEvent());
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
    if (_phoneController.text.isEmpty && p.phone != null) _phoneController.text = p.phone!;
    if (_emailController.text.isEmpty && p.email != null) _emailController.text = p.email!;
    if (_cityController.text.isEmpty) {
      _cityController.text = p.city?.formattedLocation ?? p.city?.name ?? p.businessCity ?? p.state ?? '';
    }
    if (_brandController.text.isEmpty && p.companyName != null) {
      _brandController.text = p.companyName!;
    }
    if (_websiteController.text.isEmpty) {
      _websiteController.text = p.businessWebsite ?? p.socialLinks?.website ?? p.socialLinks?.linkedin ?? '';
    }
    if (_industryController.text.isEmpty) {
      _industryController.text = p.mainBusinessCategory ?? p.businessCategory ?? p.businessType ?? '';
    }
    if (_aboutBusinessController.text.isEmpty) {
      _aboutBusinessController.text = p.experienceSummary ?? p.bio ?? '';
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _cityController.dispose();
    _brandController.dispose();
    _websiteController.dispose();
    _industryController.dispose();
    _aboutBusinessController.dispose();
    _partnershipGoalController.dispose();
    _whyPartnerController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    if (!PaywallGateHelper.checkPro(context, message: 'Upgrade to Pro to submit partnership requests.')) {
      return;
    }

    final entity = PartnerWithUsEntity(
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      mobileNumber: _phoneController.text.trim(),
      emailId: _emailController.text.trim(),
      city: _cityController.text.trim(),
      brandOrCompanyName: _brandController.text.trim(),
      websiteOrSocialMediaLink: _websiteController.text.trim(),
      industry: _industryController.text.trim(),
      aboutYourBusiness: _aboutBusinessController.text.trim(),
      partnershipGoal: _partnershipGoalController.text.trim(),
      whyPartnerWithPeersGlobal: _whyPartnerController.text.trim(),
    );

    context.read<PartnerWithUsBloc>().add(SubmitPartnerWithUsEvent(entity));
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
        BlocListener<PartnerWithUsBloc, PartnerWithUsState>(
          listenWhen: (prev, curr) =>
              prev.status != curr.status &&
              (curr.status == PartnerWithUsStatus.success ||
                  curr.status == PartnerWithUsStatus.error),
          listener: (context, state) {
            if (state.status == PartnerWithUsStatus.success &&
                state.successMessage != null) {
              AppSnackBar.showSuccess(context, state.successMessage!);
              _formKey.currentState?.reset();
              _partnershipGoalController.clear();
              _whyPartnerController.clear();
              _tabController.animateTo(1);
            } else if (state.status == PartnerWithUsStatus.error &&
                state.errorMessage != null) {
              AppSnackBar.showError(context, state.errorMessage!);
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppCommonBar(
          title: 'Partner With Us',
          showBack: Navigator.canPop(context),
          onBackTap: Navigator.canPop(context) ? () => Navigator.pop(context) : null,
        ),
        body: AppGradientBackground(
          child: ResponsiveContainer(
            child: BlocBuilder<PartnerWithUsBloc, PartnerWithUsState>(
              builder: (context, state) {
                return Column(
                  children: [
                    HighlightSegmentedTabBar(
                      controller: _tabController,
                      tabTitles: const ['Proposal Form', 'Submissions'],
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          PartnerFormTab(
                            formKey: _formKey,
                            firstNameController: _firstNameController,
                            lastNameController: _lastNameController,
                            phoneController: _phoneController,
                            emailController: _emailController,
                            cityController: _cityController,
                            brandController: _brandController,
                            websiteController: _websiteController,
                            industryController: _industryController,
                            aboutBusinessController: _aboutBusinessController,
                            partnershipGoalController: _partnershipGoalController,
                            whyPartnerController: _whyPartnerController,
                            state: state,
                            onSubmit: _submit,
                          ),
                          PartnerWithUsHistoryList(
                            submissions: state.submissions,
                            isLoading: state.status == PartnerWithUsStatus.loading,
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
