import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/utils/paywall_gate_helper.dart';
import '../../../../core/widgets/app_common_bar.dart';
import '../../../../core/widgets/app_gradient_background.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/responsive_container.dart';
import '../../../profile/presentation/bloc/profile_bloc.dart';
import '../../../profile/presentation/bloc/profile_event.dart';
import '../../../profile/presentation/bloc/profile_state.dart';
import '../bloc/leadership_certification/leadership_certification_bloc.dart';
import '../bloc/leadership_certification/leadership_certification_event.dart';
import '../bloc/leadership_certification/leadership_certification_state.dart';
import '../widgets/certification_result_dialog.dart';
import '../widgets/leadership_certificate_card.dart';
import '../widgets/leadership_certificate_dialog.dart';
import '../widgets/leadership_certification_bottom_nav.dart';
import '../widgets/leadership_questionnaire_pager.dart';
import '../widgets/leadership_review_submit_sheet.dart';
import '../widgets/leadership_submissions_history_tab.dart';
import '../widgets/leadership_under_review_card.dart';

class LeadershipCertificationScreen extends StatefulWidget {
  const LeadershipCertificationScreen({super.key});

  @override
  State<LeadershipCertificationScreen> createState() =>
      _LeadershipCertificationScreenState();
}

class _LeadershipCertificationScreenState
    extends State<LeadershipCertificationScreen> {
  final _fullNameController = TextEditingController();
  final _businessNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _contactController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<LeadershipCertificationBloc>().add(
      const LoadLeadershipInitialDataEvent(),
    );
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
    if (_businessNameController.text.isEmpty && p.companyName != null) {
      _businessNameController.text = p.companyName!;
    }
    if (_emailController.text.isEmpty && p.email != null) {
      _emailController.text = p.email!;
    }
    if (_contactController.text.isEmpty && p.phone != null) {
      _contactController.text = p.phone!;
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _businessNameController.dispose();
    _emailController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  void _openSubmitSheet(
    BuildContext context,
    LeadershipCertificationState state,
  ) {
    if (state.answers.length < state.questions.length) {
      AppSnackBar.showError(
        context,
        'Please answer all ${state.questions.length} questions before submitting.',
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) =>
          BlocBuilder<
            LeadershipCertificationBloc,
            LeadershipCertificationState
          >(
            builder: (context, currentState) {
              final isSubmitting =
                  currentState.status ==
                  LeadershipCertificationStatus.submitting;
              return LeadershipReviewSubmitSheet(
                fullNameController: _fullNameController,
                businessNameController: _businessNameController,
                emailController: _emailController,
                contactController: _contactController,
                answeredCount: currentState.answers.length,
                totalQuestions: currentState.questions.length,
                isSubmitting: isSubmitting,
                onConfirmSubmit: () {
                  if (!PaywallGateHelper.checkPro(context, message: 'Upgrade to Pro to submit leadership certification.')) {
                    return;
                  }
                  if (_fullNameController.text.trim().isEmpty ||
                      _businessNameController.text.trim().isEmpty) {
                    AppSnackBar.showError(
                      context,
                      'Please provide your full name and business name.',
                    );
                    return;
                  }
                  Navigator.pop(bottomSheetContext);
                  context.read<LeadershipCertificationBloc>().add(
                    SubmitLeadershipCertificationEvent(
                      fullName: _fullNameController.text.trim(),
                      businessName: _businessNameController.text.trim(),
                      email: _emailController.text.trim(),
                      contactNo: _contactController.text.trim(),
                    ),
                  );
                },
              );
            },
          ),
    );
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
        BlocListener<LeadershipCertificationBloc, LeadershipCertificationState>(
          listener: (context, state) {
            if (state.status == LeadershipCertificationStatus.success &&
                state.result != null) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => CertificationResultDialog(
                  title: 'Leadership Certification',
                  tier: state.result!.certificationLevel,
                  score: state.result!.totalScore,
                  percentage: state.result!.percentage,
                  certificateUrl: state.result!.certificateUrl,
                  onDismiss: () {
                    Navigator.pop(context);
                    context.read<LeadershipCertificationBloc>().add(
                      const LoadLeadershipInitialDataEvent(),
                    );
                  },
                ),
              );
            } else if (state.errorMessage != null) {
              AppSnackBar.showError(context, state.errorMessage!);
            }
          },
        ),
      ],
      child:
          BlocBuilder<
            LeadershipCertificationBloc,
            LeadershipCertificationState
          >(
            builder: (context, state) {
              return Scaffold(
                backgroundColor: Colors.transparent,
                appBar: AppCommonBar(
                  title: 'Leadership Certification',
                  showBack: Navigator.canPop(context),
                  showProfile: false,
                  showNotifications: false,
                  showSearch: false,
                  onProfileTap: () =>
                      Navigator.pushNamed(context, AppRoutes.profile),
                  onBackTap: Navigator.canPop(context)
                      ? () => Navigator.pop(context)
                      : null,
                ),
                bottomNavigationBar: LeadershipCertificationBottomNav(
                  selectedIndex: state.selectedTab,
                  hasCertificate: state.hasApprovedCertificate,
                  isUnderReview: state.isUnderReview,
                  onTabSelected: (index) {
                    context.read<LeadershipCertificationBloc>().add(
                      SelectLeadershipTabEvent(index),
                    );
                  },
                ),
                body: AppGradientBackground(
                  child: ResponsiveContainer(child: _buildBody(context, state)),
                ),
              );
            },
          ),
    );
  }

  Widget _buildBody(BuildContext context, LeadershipCertificationState state) {
    if (state.selectedTab == 1) {
      return LeadershipSubmissionsHistoryTab(
        submissions: state.submissions,
        isLoading: state.isLoadingSubmissions,
        currentPage: state.submissionsPage,
        lastPage: state.submissionsLastPage,
        onRefresh: () async {
          context.read<LeadershipCertificationBloc>().add(
            const LoadLeadershipSubmissionsEvent(page: 1, isRefresh: true),
          );
        },
        onLoadMore: (page) {
          context.read<LeadershipCertificationBloc>().add(
            LoadLeadershipSubmissionsEvent(page: page),
          );
        },
        onViewCertificate: (cert) {
          showDialog(
            context: context,
            builder: (_) => LeadershipCertificateDialog(certificate: cert),
          );
        },
        onRetake: () {
          context.read<LeadershipCertificationBloc>().add(
            const RetakeLeadershipAssessmentEvent(),
          );
          context.read<LeadershipCertificationBloc>().add(
            const SelectLeadershipTabEvent(0),
          );
        },
      );
    }

    if (state.status == LeadershipCertificationStatus.loading &&
        state.questions.isEmpty &&
        state.latestSubmission == null &&
        state.latestApprovedCertificate == null) {
      return const Center(
        child: CircularProgressIndicator(color: AppColor.primaryBlue),
      );
    }

    if (state.hasApprovedCertificate && !state.isRetaking) {
      return LeadershipCertificateCard(
        certificate: state.latestApprovedCertificate!,
        onViewCertificate: () {
          showDialog(
            context: context,
            builder: (_) => LeadershipCertificateDialog(
              certificate: state.latestApprovedCertificate!,
            ),
          );
        },
      );
    }

    if (state.isUnderReview && !state.isRetaking) {
      return LeadershipUnderReviewCard(
        submission: state.latestSubmission,
        onViewHistory: () {
          context.read<LeadershipCertificationBloc>().add(
            const SelectLeadershipTabEvent(1),
          );
        },
        onRefresh: () async {
          context.read<LeadershipCertificationBloc>().add(
            const LoadLeadershipInitialDataEvent(),
          );
        },
      );
    }

    return LeadershipQuestionnairePager(
      questions: state.questions,
      currentStep: state.currentStep,
      answers: state.answers,
      isSubmitting: state.status == LeadershipCertificationStatus.submitting,
      onStepChanged: (step) {
        context.read<LeadershipCertificationBloc>().add(
          SetQuestionnaireStepEvent(step),
        );
      },
      onSelectAnswer: (ans) {
        if (state.currentStep < state.questions.length) {
          final q = state.questions[state.currentStep];
          context.read<LeadershipCertificationBloc>().add(
            AnswerLeadershipQuestionEvent(field: q.field, answer: ans),
          );
        }
      },
      onSubmit: () => _openSubmitSheet(context, state),
    );
  }
}
