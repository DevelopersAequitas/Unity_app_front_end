import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unity_app/features/profile/presentation/bloc/profile_bloc.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_common_bar.dart';
import '../../../../core/widgets/app_gradient_background.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/responsive_container.dart';
import '../../../profile/presentation/bloc/profile_event.dart';
import '../../../profile/presentation/bloc/profile_state.dart';
import '../bloc/leadership_certification/leadership_certification_bloc.dart';
import '../bloc/leadership_certification/leadership_certification_event.dart';
import '../bloc/leadership_certification/leadership_certification_state.dart';
import '../widgets/certification_info_banner.dart';
import '../widgets/certification_personal_info_card.dart';
import '../widgets/certification_question_card.dart';
import '../widgets/certification_result_dialog.dart';

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
      const LoadLeadershipQuestionsEvent(),
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

  void _submit(BuildContext context, LeadershipCertificationState state) {
    if (_fullNameController.text.trim().isEmpty ||
        _businessNameController.text.trim().isEmpty) {
      AppSnackBar.showError(
        context,
        'Please complete your personal and business details.',
      );
      return;
    }
    if (state.answers.length < state.questions.length) {
      AppSnackBar.showError(
        context,
        'Please answer all questions before submitting.',
      );
      return;
    }

    context.read<LeadershipCertificationBloc>().add(
      SubmitLeadershipCertificationEvent(
        fullName: _fullNameController.text.trim(),
        businessName: _businessNameController.text.trim(),
        email: _emailController.text.trim(),
        contactNo: _contactController.text.trim(),
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
                    Navigator.pop(context);
                  },
                ),
              );
            } else if (state.errorMessage != null) {
              AppSnackBar.showError(context, state.errorMessage!);
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppCommonBar(
          title: 'Leadership Certification',
          showBack: Navigator.canPop(context),
          showProfile: true,
          onProfileTap: () => Navigator.pushNamed(context, AppRoutes.profile),
          onBackTap: Navigator.canPop(context)
              ? () => Navigator.pop(context)
              : null,
        ),
        body: AppGradientBackground(
          child: ResponsiveContainer(
            child:
                BlocBuilder<
                  LeadershipCertificationBloc,
                  LeadershipCertificationState
                >(
                  builder: (context, state) {
                    if (state.status == LeadershipCertificationStatus.loading &&
                        state.questions.isEmpty) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColor.primaryBlue,
                        ),
                      );
                    }

                    return ListView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 14,
                      ),
                      children: [
                        const CertificationInfoBanner(
                          title: 'Leadership Assessment',
                          description:
                              'Complete all situational questions to assess and certify your leadership competencies.',
                          icon: Icons.military_tech_outlined,
                        ),
                        const SizedBox(height: 14),
                        CertificationPersonalInfoCard(
                          fullNameController: _fullNameController,
                          businessNameController: _businessNameController,
                          emailController: _emailController,
                          contactController: _contactController,
                        ),
                        const SizedBox(height: 14),
                        ...state.questions.asMap().entries.map((entry) {
                          final index = entry.key;
                          final q = entry.value;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: CertificationQuestionCard(
                              questionIndex: index + 1,
                              totalQuestions: state.questions.length,
                              question: q,
                              selectedAnswer: state.answers[q.field],
                              onSelectAnswer: (ans) {
                                context.read<LeadershipCertificationBloc>().add(
                                  AnswerLeadershipQuestionEvent(
                                    field: q.field,
                                    answer: ans,
                                  ),
                                );
                              },
                            ),
                          );
                        }),
                        const SizedBox(height: 14),
                        SizedBox(
                          width: double.infinity,
                          height: 46,
                          child: ElevatedButton(
                            onPressed:
                                state.status ==
                                    LeadershipCertificationStatus.submitting
                                ? null
                                : () => _submit(context, state),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColor.primaryBlue,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child:
                                state.status ==
                                    LeadershipCertificationStatus.submitting
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(
                                    'Submit Assessment',
                                    style: AppTypography.labelLarge.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
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
      ),
    );
  }
}
