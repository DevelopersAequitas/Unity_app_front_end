import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/widgets/app_common_bar.dart';
import '../../../../core/widgets/app_gradient_background.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/responsive_container.dart';
import '../../../profile/presentation/bloc/profile_bloc.dart';
import '../../../profile/presentation/bloc/profile_event.dart';
import '../../../profile/presentation/bloc/profile_state.dart';
import '../bloc/entrepreneur_certification/entrepreneur_certification_bloc.dart';
import '../bloc/entrepreneur_certification/entrepreneur_certification_event.dart';
import '../bloc/entrepreneur_certification/entrepreneur_certification_state.dart';
import '../widgets/certification_result_dialog.dart';
import '../widgets/entrepreneur_certificate_card.dart';
import '../widgets/entrepreneur_certificate_dialog.dart';
import '../widgets/entrepreneur_certification_bottom_nav.dart';
import '../widgets/entrepreneur_questionnaire_pager.dart';
import '../widgets/entrepreneur_review_submit_sheet.dart';
import '../widgets/entrepreneur_submissions_history_tab.dart';
import '../widgets/entrepreneur_under_review_card.dart';

class EntrepreneurCertificationScreen extends StatefulWidget {
  const EntrepreneurCertificationScreen({super.key});

  @override
  State<EntrepreneurCertificationScreen> createState() =>
      _EntrepreneurCertificationScreenState();
}

class _EntrepreneurCertificationScreenState
    extends State<EntrepreneurCertificationScreen> {
  final _fullNameController = TextEditingController();
  final _businessNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _contactController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<EntrepreneurCertificationBloc>().add(
      const LoadEntrepreneurInitialDataEvent(),
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
    EntrepreneurCertificationState state,
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
            EntrepreneurCertificationBloc,
            EntrepreneurCertificationState
          >(
            builder: (context, currentState) {
              final isSubmitting =
                  currentState.status ==
                  EntrepreneurCertificationStatus.submitting;
              return EntrepreneurReviewSubmitSheet(
                fullNameController: _fullNameController,
                businessNameController: _businessNameController,
                emailController: _emailController,
                contactController: _contactController,
                answeredCount: currentState.answers.length,
                totalQuestions: currentState.questions.length,
                isSubmitting: isSubmitting,
                onConfirmSubmit: () {
                  if (_fullNameController.text.trim().isEmpty ||
                      _businessNameController.text.trim().isEmpty) {
                    AppSnackBar.showError(
                      context,
                      'Please provide your full name and business name.',
                    );
                    return;
                  }
                  Navigator.pop(bottomSheetContext);
                  context.read<EntrepreneurCertificationBloc>().add(
                    SubmitEntrepreneurCertificationEvent(
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
        BlocListener<
          EntrepreneurCertificationBloc,
          EntrepreneurCertificationState
        >(
          listener: (context, state) {
            if (state.status == EntrepreneurCertificationStatus.success &&
                state.result != null) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => CertificationResultDialog(
                  title: 'Entrepreneur Certification',
                  tier: state.result!.certificationTier,
                  score: state.result!.totalScore,
                  percentage: state.result!.percentage,
                  certificateUrl: state.result!.certificateUrl,
                  onDismiss: () {
                    Navigator.pop(context);
                    context.read<EntrepreneurCertificationBloc>().add(
                      const LoadEntrepreneurInitialDataEvent(),
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
            EntrepreneurCertificationBloc,
            EntrepreneurCertificationState
          >(
            builder: (context, state) {
              return Scaffold(
                backgroundColor: Colors.transparent,
                appBar: AppCommonBar(
                  title: 'Entrepreneur Certification',
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
                bottomNavigationBar: EntrepreneurCertificationBottomNav(
                  selectedIndex: state.selectedTab,
                  hasCertificate: state.hasApprovedCertificate,
                  isUnderReview: state.isUnderReview,
                  onTabSelected: (index) {
                    context.read<EntrepreneurCertificationBloc>().add(
                      SelectEntrepreneurTabEvent(index),
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

  Widget _buildBody(
    BuildContext context,
    EntrepreneurCertificationState state,
  ) {
    if (state.selectedTab == 1) {
      return EntrepreneurSubmissionsHistoryTab(
        submissions: state.submissions,
        isLoading: state.isLoadingSubmissions,
        currentPage: state.submissionsPage,
        lastPage: state.submissionsLastPage,
        onRefresh: () async {
          context.read<EntrepreneurCertificationBloc>().add(
            const LoadEntrepreneurSubmissionsEvent(page: 1, isRefresh: true),
          );
        },
        onLoadMore: (page) {
          context.read<EntrepreneurCertificationBloc>().add(
            LoadEntrepreneurSubmissionsEvent(page: page),
          );
        },
        onViewCertificate: (cert) {
          showDialog(
            context: context,
            builder: (_) => EntrepreneurCertificateDialog(certificate: cert),
          );
        },
        onRetake: () {
          context.read<EntrepreneurCertificationBloc>().add(
            const RetakeEntrepreneurAssessmentEvent(),
          );
          context.read<EntrepreneurCertificationBloc>().add(
            const SelectEntrepreneurTabEvent(0),
          );
        },
      );
    }

    if (state.status == EntrepreneurCertificationStatus.loading &&
        state.questions.isEmpty &&
        state.latestSubmission == null &&
        state.latestApprovedCertificate == null) {
      return const Center(
        child: CircularProgressIndicator(color: AppColor.primaryBlue),
      );
    }

    if (state.hasApprovedCertificate && !state.isRetaking) {
      return EntrepreneurCertificateCard(
        certificate: state.latestApprovedCertificate!,
        onViewCertificate: () {
          showDialog(
            context: context,
            builder: (_) => EntrepreneurCertificateDialog(
              certificate: state.latestApprovedCertificate!,
            ),
          );
        },
      );
    }

    if (state.isUnderReview && !state.isRetaking) {
      return EntrepreneurUnderReviewCard(
        submission: state.latestSubmission,
        onViewHistory: () {
          context.read<EntrepreneurCertificationBloc>().add(
            const SelectEntrepreneurTabEvent(1),
          );
        },
        onRefresh: () async {
          context.read<EntrepreneurCertificationBloc>().add(
            const LoadEntrepreneurInitialDataEvent(),
          );
        },
      );
    }

    return EntrepreneurQuestionnairePager(
      questions: state.questions,
      currentStep: state.currentStep,
      answers: state.answers,
      isSubmitting: state.status == EntrepreneurCertificationStatus.submitting,
      onStepChanged: (step) {
        context.read<EntrepreneurCertificationBloc>().add(
          SetEntrepreneurQuestionnaireStepEvent(step),
        );
      },
      onSelectAnswer: (ans) {
        if (state.currentStep < state.questions.length) {
          final q = state.questions[state.currentStep];
          context.read<EntrepreneurCertificationBloc>().add(
            AnswerEntrepreneurQuestionEvent(field: q.field, answer: ans),
          );
        }
      },
      onSubmit: () => _openSubmitSheet(context, state),
    );
  }
}
